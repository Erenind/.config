import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets

PanelWindow {
    id: root

    color: "transparent"
    anchors.top: true
    margins { top: 10 }
    exclusionMode: ExclusionMode.Ignore

    visible: cardCount > 0
    implicitWidth: stack.width
    implicitHeight: stack.height

    required property NotificationServer server

    readonly property int maxVisible: 5
    readonly property real cardSpacing: 8
    // Quickshell v0.3.0 的 expireTimeout 实际是 D-Bus 原始值（毫秒），
    // <= 0 表示“由服务端决定”，这里统一用 5 秒兜底。
    readonly property int defaultTimeoutMs: 5000
    property int cardCount: 0
    property var cards: []

    Colors { id: wal }

    Connections {
        target: server

        function onNotification(notification) {
            notification.tracked = true
            var card = cardComponent.createObject(stack, {
                notif: notification,
                targetY: -300
            })
            cards.unshift(card)

            while (cards.length > root.maxVisible) {
                var dropped = cards.pop()
                dropped.dropped = true
                dropped.destroy()
                dropped.notif.tracked = false
            }

            relayout()
        }
    }

    function iconSource(notif) {
        var name = notif.appIcon !== "" ? notif.appIcon : notif.desktopEntry
        if (name === "")
            return ""
        var path = Quickshell.iconPath(name, true)
        if (path === "")
            path = Quickshell.iconPath(name)
        return path
    }

    function removeCard(card) {
        var i = cards.indexOf(card)
        if (i >= 0)
            cards.splice(i, 1)
        relayout()
    }

    function relayout() {
        var y = 0
        var w = 0
        var h = 0
        for (var i = 0; i < cards.length; i++) {
            var c = cards[i]
            c.targetY = y
            y += c.height + root.cardSpacing
            w = Math.max(w, c.width)
            h += c.height
        }
        if (cards.length > 1)
            h += root.cardSpacing * (cards.length - 1)

        stack.width = w
        stack.height = h
        root.cardCount = cards.length

        // 卡片居中
        for (var j = 0; j < cards.length; j++)
            cards[j].x = (stack.width - cards[j].width) / 2
    }

    Item {
        id: stack
        width: 0
        height: 0
    }

    Component {
        id: cardComponent

        Rectangle {
            id: card
            property var notif: null
            property real targetY: 0
            property bool entered: false
            property bool hovered: false
            property bool closing: false
            property bool externallyClosed: false
            property bool closeByExpire: false
            property bool dropped: false
            property real remainingMs: -1
            property real deadline: 0
            property real timeoutMs: 0

            width: implicitWidth
            height: implicitHeight
            y: targetY
            opacity: entered && !closing ? 1 : 0

            radius: 14
            color: hovered ? Qt.lighter(wal.background, 1.08) : wal.background
            border.color: Qt.rgba(wal.color8.r, wal.color8.g, wal.color8.b, 0.45)
            border.width: 1
            clip: true

            Behavior on y { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
            Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 150 } }
            Behavior on color { ColorAnimation { duration: 120 } }

            // ---- 尺寸：由内容决定，80 只是最小高度，宽度上限 400 ----
            property real textNaturalWidth: Math.max(titleLabel.implicitWidth, bodyLabel.implicitWidth)
            property real textHeight: texts.implicitHeight
            property real imageAspect: bigImage.status === Image.Ready && bigImage.implicitHeight > 0
                                       ? bigImage.implicitWidth / bigImage.implicitHeight : 1
            property real imageWidth: bigImage.visible
                                      ? Math.min(120, Math.max(32, imageAspect * (implicitHeight - 28)))
                                      : 0

            implicitHeight: {
                var h = Math.max(80, textHeight + 28)
                if (bigImage.visible)
                    h = Math.min(160, h)
                return h
            }
            implicitWidth: {
                var w = 28
                if (appIcon.visible)
                    w += 40 + 12
                w += Math.max(textNaturalWidth, 130)
                if (bigImage.visible)
                    w += imageWidth + 12
                return Math.min(400, w)
            }

            onWidthChanged: root.relayout()
            onHeightChanged: root.relayout()

            Component.onCompleted: {
                entered = true
                startTimeout()
            }

            // ---- 悬停：暂停计时并显示关闭按钮 ----
            MouseArea {
                id: hoverArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: card.hovered = true
                onExited: card.hovered = false
            }

            onHoveredChanged: {
                if (closing)
                    return
                if (hovered)
                    pauseTimeout()
                else
                    resumeTimeout()
            }

            // ---- 自动超时关闭（悬停暂停） ----
            Timer {
                id: timeoutTimer
                repeat: false
                onTriggered: card.expireByTimeout()
            }

            function startTimeout() {
                timeoutMs = notif.expireTimeout > 0
                    ? Math.round(notif.expireTimeout)
                    : root.defaultTimeoutMs
                deadline = Date.now() + timeoutMs
                timeoutTimer.interval = Math.max(1, timeoutMs)
                console.log("NTF startTimeout id=" + notif.id + " expireTimeout=" + notif.expireTimeout + " interval=" + timeoutTimer.interval)
                timeoutTimer.start()
            }

            function pauseTimeout() {
                if (timeoutTimer.running) {
                    remainingMs = deadline - Date.now()
                    timeoutTimer.stop()
                }
            }

            function resumeTimeout() {
                if (closing)
                    return
                var ms = remainingMs > 0 ? remainingMs : timeoutMs
                timeoutTimer.interval = Math.max(1, Math.round(ms))
                timeoutTimer.start()
            }

            function expireByTimeout() {
                console.log("NTF expireByTimeout id=" + notif.id)
                closeByExpire = true
                beginClose()
            }

            function closeByUser() {
                console.log("NTF closeByUser id=" + notif.id)
                closeByExpire = false
                beginClose()
            }

            // ---- 退出动画：淡出后移除 ----
            function beginClose() {
                if (closing)
                    return
                closing = true
                hovered = false
                timeoutTimer.stop()
                closeDoneTimer.start()
            }

            function finishClose() {
                console.log("NTF finishClose id=" + notif.id + " ext=" + externallyClosed + " byExpire=" + closeByExpire)
                if (!externallyClosed) {
                    if (closeByExpire)
                        notif.expire()
                    else
                        notif.dismiss()
                }
                root.removeCard(card)
                card.destroy()
            }

            Timer {
                id: closeDoneTimer
                interval: 160
                repeat: false
                onTriggered: card.finishClose()
            }

            Connections {
                target: card.notif

                function onClosed(reason) {
                    card.externallyClosed = true
                    if (!card.closing && !card.dropped)
                        card.beginClose()
                }
            }

            // ---- 内容 ----
            RowLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 12

                IconImage {
                    id: appIcon
                    source: root.iconSource(card.notif)
                    implicitSize: 40
                    Layout.preferredWidth: visible ? 40 : 0
                    Layout.preferredHeight: visible ? 40 : 0
                    Layout.alignment: Qt.AlignTop
                    Layout.topMargin: 2
                    visible: source !== "" && status !== Image.Error
                    asynchronous: true
                }

                ColumnLayout {
                    id: texts
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 2

                    Text {
                        id: titleLabel
                        text: card.notif.appName
                        font.family: "Noto Sans CJK SC"
                        font.pixelSize: 13
                        font.bold: true
                        color: wal.foreground
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        Layout.fillWidth: true
                    }

                    Text {
                        id: bodyLabel
                        text: card.notif.body.length > 0 ? card.notif.body : card.notif.summary
                        textFormat: Text.AutoText
                        wrapMode: Text.Wrap
                        lineHeight: 1.15
                        font.family: "Noto Sans CJK SC"
                        font.pixelSize: 12
                        color: wal.color7
                        elide: Text.ElideRight
                        maximumLineCount: 2
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }

                Image {
                    id: bigImage
                    visible: card.notif.image !== ""
                    source: visible ? card.notif.image : ""
                    sourceSize.width: 480
                    sourceSize.height: 480
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    Layout.fillHeight: true
                    Layout.maximumHeight: 160
                    Layout.preferredWidth: card.imageWidth
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            // ---- 悬停时显示的关闭按钮 ----
            Rectangle {
                id: closeBtn
                width: 26
                height: 26
                radius: 13
                color: Qt.rgba(wal.color8.r, wal.color8.g, wal.color8.b, 0.3)
                opacity: card.hovered ? 1 : 0
                z: 10

                anchors {
                    top: parent.top
                    right: parent.right
                    topMargin: 8
                    rightMargin: 8
                }

                Behavior on opacity { NumberAnimation { duration: 120 } }

                MouseArea {
                    anchors.fill: parent
                    enabled: card.hovered
                    onClicked: card.closeByUser()
                }

                Text {
                    anchors.centerIn: parent
                    text: "󰅖"
                    font.family: "JetBrainsMono Nerd Font Mono"
                    font.pixelSize: 15
                    color: wal.color7
                }
            }
        }
    }
}
