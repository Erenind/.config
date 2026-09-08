import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
// import Quickshell.Widgets
// import Quickshell.Services.SystemTray
// import Quickshell.Services.Pipewire

Scope {
    id: barRoot

    property bool leftmenuOpen: false
    property bool rightmenuOpen: false
    property bool leftmenuVisible: false
    property bool rightmenuVisible: false

    onLeftmenuOpenChanged: {
        if (leftmenuOpen) {
            leftmenuVisible = true
            leftCloseTimer.stop()
        } else {
            leftCloseTimer.start()
        }
    }

    onRightmenuOpenChanged: {
        if (rightmenuOpen) {
            rightmenuVisible = true
            rightCloseTimer.stop()
        } else {
            rightCloseTimer.start()
        }
    }

    Timer {
        id: leftCloseTimer
        interval: 350
        onTriggered: {
            if (!leftmenuOpen)
            leftmenuVisible = false
        }
    }

    Timer {
        id: rightCloseTimer
        interval: 350
        onTriggered: {
            if (!rightmenuOpen)
            rightmenuVisible = false
        }
    }

    Colors { id: wal }
    BatteryInfo { id: battery }
    NixosInfo { id: nixos }
    Brightness {id:brightness}

    // bar
    PanelWindow {
        id: bar
        color: "transparent"
        implicitHeight: 33

        anchors {
            bottom: true
            left: true
            right: true
        }

        margins {
            bottom: 5
            left: 5
            right: 5
        }

        Rectangle {
            color: wal.background
            radius:10
            anchors.fill: parent

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                spacing: 5

                // left
                Rectangle {
                    id: icon
                    implicitHeight:33
                    implicitWidth: 80
                    color: "transparent"

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true

                        onClicked: {
                            barRoot.leftmenuOpen = ! barRoot.leftmenuOpen
                        }
                    }

                    RowLayout {

                        Text {
                            text: ""
                            font.pixelSize: 24
                            color: wal.color4
                            Layout.topMargin:2
                        }
                        Text {
                            text: nixos.codename
                            color: wal.color3
                            font.pixelSize: 14
                            font.bold:true
                        }
                    }
                }

                // workspaces
                Repeater {
                    model: Hyprland.workspaces.values

                    delegate: Rectangle {
                        required property HyprlandWorkspace modelData

                        // 判断当前工作区是否激活
                        property bool isActive: Hyprland.activeWorkspace === modelData

                        implicitWidth: 28
                        implicitHeight: 28
                        radius: 6

                        // 激活与未激活的动态背景色
                        color: {
                            if (modelData.focused) return wal.color1       // 处于全局焦点的工作区
                            if (modelData.urgent) return wal.color4        // 存在紧急事件 (urgent) 的窗口
                            if (modelData.active) return wal.color8        // 在某个显示器上处于激活状态
                            return wal.color0                              // 普通后台工作区
                        }

                        // 悬停高亮叠加层
                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            color: "white"
                            opacity: wsMouseArea.containsMouse ? 0.3 : 0
                            Behavior on opacity { NumberAnimation { duration: 120 } }
                        }

                        border.color: modelData.hasFullscreen ? wal.color6 : "transparent"
                        border.width: 2

                        Text {
                            anchors.centerIn: parent
                            text: modelData.name !== "" ? modelData.name : modelData.id
                            color: (modelData.focused || modelData.urgent) ? wal.color0 : wal.foreground
                            font.bold: true
                            font.pixelSize: 13
                        }

                        // 鼠标点击切换工作区
                        MouseArea {
                            id: wsMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                // 调用 Hyprland dispatch 命令进行工作区切换
                                modelData.activate()
                            }
                        }
                    }
                }

                // middle spacing
                Rectangle {
                    color: "transparent"
                    Layout.fillWidth: true;
                    implicitHeight: 33
                }

                // light and volume

                // Rectangle {
                //     Layout.fillHeight: true;
                //     implicitWidth: 30;
                //     Text {
                //         // text: `${Math.round(sink.audio.volume * 100)}`;
                //         text: currentVolume
                //     }
                // }
                Rectangle {
                    Layout.fillHeight: true;
                    implicitWidth: 100;
                    id: brightness_rect
                    visible: false
                    Text {
                        text: brightness.result
                    }
                }
                Process {
                    id: brightness_up_process
                    command: ["sh","-c","brightnessctl -e0 set 50+"]
                }
                Process {
                    id: brightness_down_process
                    command: ["sh","-c","brightnessctl -e0 set 50-"]
                }
                Timer {
                    id: brightness_rect_cutdown
                    interval: 2000
                    onTriggered: {
                        brightness_rect.visible = false
                    }
                }
                IpcHandler {
                    target: "brightness"
                    function brightness(ipc_r:string): void {
                        brightness_rect.visible = true
                        brightness_rect_cutdown.restart()
                        if(ipc_r == "up") {
                            brightness_up_process.running = true
                        }
                        if (ipc_r == "down") {
                            brightness_down_process.running = true
                        }
                        brightness.restart()

                    }
                }

                // battery
                Rectangle {
                    implicitHeight:33
                    implicitWidth:50
                    color:"transparent"

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            barRoot.rightmenuOpen = ! barRoot.rightmenuOpen
                        }
                    }

                    Text {
                        color: wal.color6
                        text: `󱐋${battery.capacity}`
                        font.pixelSize: 18
                        font.bold: true
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: 1
                    }
                }

                // time
                Rectangle {
                    color: "transparent"
                    implicitHeight: 33
                    implicitWidth: 105

                    Text {
                        id: clockText
                        color:wal.color5
                        font {
                            pixelSize: 18
                            bold: true
                        }
                        anchors.centerIn: parent

                        Timer {
                            interval: 1000
                            running: true
                            repeat: true
                            triggeredOnStart: true

                            onTriggered: {

                                clockText.text = Qt.formatDateTime(new Date(), "h:mm ap")
                            }
                        }
                    }

                }

            }

        }

    }

    // subinfoleft
    PanelWindow {
        id: subinfoleft
        implicitHeight: 400
        implicitWidth: subinfoleft.implicitHeight * 0.618
        color: "transparent"
        visible: barRoot.leftmenuVisible
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
        focusable: true

        anchors {
            left: true
            bottom: true
        }

        margins {
            left:5
            bottom:5
        }

        HoverHandler {
            id: hoverHandler
            onHoveredChanged: {
                if (!hovered && leftmenuOpen) {
                    leftmenuOpen = false
                }
            }
        }

        Rectangle {
            color: wal.background
            implicitHeight: subinfoleft.implicitHeight
            implicitWidth: subinfoleft.implicitWidth
            radius: 10
            y: leftmenuOpen ? 0 : this.implicitHeight

            Behavior on y {
                NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 10
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.bottomMargin: 10
                spacing: 10

                // system info
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius:10
                    color: wal.color2Dark
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing:10
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 33
                            Text {
                                width: 24
                                text: ""
                                font.family: "JetBrainsMono Nerd Font Mono"
                                font.pixelSize: 26
                                color: wal.color6
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                text: "Kernel_v"
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color7
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                text: nixos.kernelVersion
                                font.family: "Noto Sans CJK SC"
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color5
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 33

                            Text {
                                width: 24
                                text: ""
                                font.family: "JetBrainsMono Nerd Font Mono"
                                font.pixelSize: 28
                                color: wal.color6
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                text: "Nixos_v"
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color7
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                text: nixos.version
                                font.family: "Noto Sans CJK SC"
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color5
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 33
                            Text {
                                width: 24
                                text: "󰄛"
                                font.family: "JetBrainsMono Nerd Font Mono"
                                font.pixelSize: 28
                                color: wal.color6
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                text:"Codename"
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color7
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                text: nixos.codename
                                font.family: "Noto Sans CJK SC"
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color5
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 33
                            Text {
                                width: 24
                                text: ""
                                font.family: "JetBrainsMono Nerd Font Mono"
                                font.pixelSize: 24
                                color: wal.color6
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                text:"Nix/store"
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color7
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                text: nixos.nixStoreCount
                                font.family: "Noto Sans CJK SC"
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color5
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 33
                            Text {
                                width: 24
                                text: ""
                                font.family: "JetBrainsMono Nerd Font Mono"
                                font.pixelSize: 24
                                color: wal.color6
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                text: "Generation"
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color7
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                text:nixos.generation
                                font.family: "Noto Sans CJK SC"
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color5
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 33
                            Text {
                                width: 24
                                text: "󰚰"
                                font.family: "JetBrainsMono Nerd Font Mono"
                                font.pixelSize: 26
                                color: wal.color6
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                text: "LastRebuild"
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color7
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                text: nixos.lastUpdated
                                font.family: "Noto Sans CJK SC"
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color5
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }

                // reboot
                Rectangle {
                    id: rebootMenu
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignBottom
                    implicitHeight:33
                    radius:10
                    color: wal.color2

                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: "white"
                        opacity: rebootMenuMouse.containsMouse ? 0.15 : 0
                        Behavior on opacity { NumberAnimation { duration: 120 } }
                    }

                    Text {
                        text: "󰑓 Reboot"
                        font.pixelSize: 16
                        font.bold: true
                        color: wal.color0
                        anchors.centerIn: parent
                    }

                    Process {
                        id: rebootProcess
                        running: false
                    }

                    MouseArea {
                        id: rebootMenuMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            rebootProcess.exec(["sh","-c","reboot"])
                        }
                    }
                }

                // shutdown
                Rectangle {
                    id: powerMenu
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignBottom
                    implicitHeight:33
                    radius:10
                    color: wal.color1

                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: "white"
                        opacity: powerMenuMouse.containsMouse ? 0.15 : 0
                        Behavior on opacity { NumberAnimation { duration: 120 } }
                    }

                    Text {
                        text: ">_< Shutdown now"
                        font.pixelSize: 16
                        font.bold: true
                        color: wal.color0
                        anchors.centerIn: parent
                    }

                    Process {
                        id:shutdownProcess
                        running: false
                    }

                    MouseArea {
                        id: powerMenuMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            shutdownProcess.exec(["sh","-c","shutdown now"])
                        }
                    }
                }
            }
        }
    }

    // subinforight
    PanelWindow {
        id: subinforight
        implicitHeight: 290
        implicitWidth: subinforight.implicitHeight * 0.9
        color: "transparent"
        visible: barRoot.rightmenuVisible
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
        focusable: true

        anchors {
            right: true
            bottom: true
        }

        margins {
            right: 5
            bottom: 5
        }

        HoverHandler {
            id: rightHoverHandler
            onHoveredChanged: {
                if (!hovered && rightmenuOpen) {
                    rightmenuOpen = false
                }
            }
        }

        Rectangle {
            color: wal.background
            implicitHeight: subinforight.implicitHeight
            implicitWidth: subinforight.implicitWidth
            radius: 10
            x: rightmenuOpen ? 0 : this.implicitWidth

            Behavior on x {
                NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 10
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.bottomMargin: 10
                spacing: 10

                // battery info
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 10
                    color: wal.color3Dark
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 33
                            Item {
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 33
                                Text {
                                    anchors.centerIn: parent
                                    font.family: "JetBrainsMono Nerd Font Mono"
                                    text: "󰁹"
                                    font.pixelSize: 20
                                    font.bold: true
                                    color: wal.color7
                                }
                            }
                            Text {
                                text: "Capacity"
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color7
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                text: `${battery.capacity}%`
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color5
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 33
                            Item {
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 33
                                Text {
                                    anchors.centerIn: parent
                                    font.family: "JetBrainsMono Nerd Font Mono"
                                    text: "󰚥"
                                    font.pixelSize: 20
                                    font.bold: true
                                    color: wal.color7
                                }
                            }
                            Text {
                                text: "Status"
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color7
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                text: battery.status
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color5
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 33
                            Item {
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 33
                                Text {
                                    anchors.centerIn: parent
                                    font.family: "JetBrainsMono Nerd Font Mono"
                                    text: "󰊚"
                                    font.pixelSize: 28
                                    font.bold: true
                                    color: wal.color7
                                }
                            }
                            Text {
                                text: "Level"
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color7
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                text: battery.capacityLevel
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color5
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 33
                            Item {
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 33
                                Text {
                                    anchors.centerIn: parent
                                    font.family: "JetBrainsMono Nerd Font Mono"
                                    text: "󱐋"
                                    font.pixelSize: 20
                                    font.bold: true
                                    color: wal.color7
                                }
                            }
                            Text {
                                text: "Energy"
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color7
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                text: `${battery.energy.toFixed(1)} Wh`
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color5
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 33
                            Item {
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 33
                                Text {
                                    anchors.centerIn: parent
                                    font.family: "JetBrainsMono Nerd Font Mono"
                                    text: "󱩘"
                                    font.pixelSize: 25
                                    font.bold: true
                                    color: wal.color7
                                }
                            }
                            Text {
                                text: "Power"
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color7
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                text: `${battery.power.toFixed(1)} W`
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color5
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 33
                            Item {
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 33
                                Text {
                                    anchors.centerIn: parent
                                    font.family: "JetBrainsMono Nerd Font Mono"
                                    text: "󰗶"
                                    font.pixelSize: 25
                                    font.bold: true
                                    color: wal.color7
                                }
                            }
                            Text {
                                text: "Health"
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color7
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                text: `${battery.health.toFixed(1)}%`
                                font.pixelSize: 18
                                font.bold: true
                                color: wal.color5
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
