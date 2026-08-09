import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Scope {
    id: barRoot

    property bool leftmenuOpen: false

    Colors { id: wal }
    BatteryInfo { id: battery }
    NixosInfo { id: nixos }

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
                spacing: 10

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

                // battery
                Rectangle {
                    implicitHeight:33
                    implicitWidth:50
                    color:"transparent"
                    Text {
                        color: wal.color6
                        text: `󱐋${battery.capacity}`
                        font.pixelSize: 18
                        font.bold: true
                        anchors.centerIn: parent
                    }
                }

                // time
                Rectangle {
                    color: "transparent"
                    implicitHeight: 33
                    implicitWidth: 80

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

                                clockText.text = Qt.formatDateTime(new Date(), "HH:mm")
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
        visible: barRoot.leftmenuOpen
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
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onExited: {
                    leftmenuCloseTimer.restart()
                }

                onEntered: {
                    leftmenuCloseTimer.stop()
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 10
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.bottomMargin: 10
                spacing: 10

                Rectangle {
                    id: trayContainer
                    implicitHeight: 33
                    color: wal.color8
                    radius:10
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop 

                    RowLayout {
                        spacing: 5
                        Repeater {
                            model: SystemTray.items

                            delegate: Item {
                                required property SystemTrayItem modelData
                                width:28
                                height:28

                                Image {
                                    anchors.fill: parent
                                    source: modelData.icon
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                                    onClicked: (mouse) => {
                                        if (mouse.button === Qt.LeftButton) {
                                            if (modelData.onlyMenu) {
                                                modelData.display(parentWindow, mouse.x, mouse.y)
                                            } else {
                                                modelData.activate()
                                            }
                                        } else if (mouse.button === Qt.RightButton) {
                                            if (modelData.hasMenu) {
                                                modelData.display(parentWindow, mouse.x, mouse.y)
                                            }
                                        } else if (mouse.button === Qt.MiddleButton) {
                                            modelData.secondaryActivate()
                                        }
                                    }
                                }

                            }
                        }

                    }

                }

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

                    MouseArea {
                        id: powerMenuMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Process.exec(["shutdown","now"])
                        }
                    }
                }
            }
        }
    }
}
