import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

FloatingWindow {
    id: controlerWindow

    required property QtObject moduleConfig

    implicitWidth: 780
    implicitHeight: 480
    color: "#1a1a1a"

    QtObject {
        id: tr
        readonly property string bar: "状态栏"
        readonly property string systemInfo: "系统信息"
        readonly property string block: "信息块"
        readonly property string notification: "通知中心"
        readonly property string wallpaper: "壁纸"
        readonly property string corners: "圆角"
    }

    component ColorIcon: Item {
        id: iconRoot
        property string source: ""
        property real size: 24
        property color tint: "#ffffff"

        implicitWidth: size
        implicitHeight: size

        Image {
            id: _img
            source: iconRoot.source
            width: iconRoot.size
            height: iconRoot.size
            sourceSize: Qt.size(iconRoot.size, iconRoot.size)
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        MultiEffect {
            source: _img
            width: iconRoot.size
            height: iconRoot.size
            colorizationColor: iconRoot.tint
            colorization: 1.0
        }
    }

    component ToggleSwitch: Rectangle {
        id: toggleRoot
        property bool checked: false

        implicitWidth: 44
        implicitHeight: 24
        radius: 12

        color: checked ? "#4a9eff" : "#3a3a3a"

        Rectangle {
            id: knob
            width: toggleRoot.height - 4
            height: width
            radius: width / 2
            y: (toggleRoot.height - height) / 2
            x: checked ? toggleRoot.width - width - 2 : 2
            color: "#ffffff"

            Behavior on x {
                NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
            }
        }

        Behavior on color {
            ColorAnimation { duration: 180 }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: toggleRoot.checked = !toggleRoot.checked
        }
    }

    RowLayout {
        spacing: 0
        anchors.fill: parent

        Rectangle {
            Layout.preferredWidth: 200
            Layout.fillHeight: true
            color: "#0d0d0d"

            ColumnLayout {
                width: parent.width
                height: parent.height
                spacing: 0

                Text {
                    text: "模块"
                    color: "#888"
                    font {
                        family: "Noto Sans CJK SC"
                        pixelSize: 13
                        letterSpacing: 2
                    }
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    verticalAlignment: Text.AlignVCenter
                    Layout.leftMargin: 20
                }

                Item { Layout.fillHeight: true }
            }
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.fillHeight: true
            color: "#252525"
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#1a1a1a"

            ColumnLayout {
                width: parent.width
                height: parent.height
                spacing: 0

                Text {
                    text: "模块管理"
                    color: "#ccc"
                    font {
                        family: "Noto Sans CJK SC"
                        pixelSize: 16
                        bold: true
                    }
                    Layout.fillWidth: true
                    Layout.preferredHeight: 52
                    verticalAlignment: Text.AlignVCenter
                    Layout.leftMargin: 28
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    Layout.leftMargin: 28
                    Layout.rightMargin: 28
                    color: "#252525"
                }

                Item { Layout.preferredHeight: 12 }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 28
                    Layout.rightMargin: 28
                    spacing: 2

                    // ── Bar ──
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        color: "transparent"

                        RowLayout {
                            width: parent.width
                            height: parent.height
                            spacing: 12

                            ColorIcon {
                                source: "icons/bar.svg"
                                size: 22
                                tint: moduleConfig.barEnabled ? "#ddd" : "#555"
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Text {
                                text: tr.bar
                                color: moduleConfig.barEnabled ? "#ddd" : "#666"
                                font {
                                    family: "Noto Sans CJK SC"
                                    pixelSize: 14
                                }
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                            }

                            ToggleSwitch {
                                Layout.alignment: Qt.AlignVCenter
                                checked: moduleConfig.barEnabled
                                onCheckedChanged: moduleConfig.barEnabled = checked
                            }
                        }
                    }

                    // ── System Info ──
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        color: "transparent"

                        RowLayout {
                            width: parent.width
                            height: parent.height
                            spacing: 12

                            ColorIcon {
                                source: "icons/systeminfo.svg"
                                size: 22
                                tint: moduleConfig.systemInfoEnabled ? "#ddd" : "#555"
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Text {
                                text: tr.systemInfo
                                color: moduleConfig.systemInfoEnabled ? "#ddd" : "#666"
                                font {
                                    family: "Noto Sans CJK SC"
                                    pixelSize: 14
                                }
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                            }

                            ToggleSwitch {
                                Layout.alignment: Qt.AlignVCenter
                                checked: moduleConfig.systemInfoEnabled
                                onCheckedChanged: moduleConfig.systemInfoEnabled = checked
                            }
                        }
                    }

                    // ── Block ──
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        color: "transparent"

                        RowLayout {
                            width: parent.width
                            height: parent.height
                            spacing: 12

                            ColorIcon {
                                source: "icons/block.svg"
                                size: 22
                                tint: moduleConfig.blockEnabled ? "#ddd" : "#555"
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Text {
                                text: tr.block
                                color: moduleConfig.blockEnabled ? "#ddd" : "#666"
                                font {
                                    family: "Noto Sans CJK SC"
                                    pixelSize: 14
                                }
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                            }

                            ToggleSwitch {
                                Layout.alignment: Qt.AlignVCenter
                                checked: moduleConfig.blockEnabled
                                onCheckedChanged: moduleConfig.blockEnabled = checked
                            }
                        }
                    }

                    // ── Notification ──
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        color: "transparent"

                        RowLayout {
                            width: parent.width
                            height: parent.height
                            spacing: 12

                            ColorIcon {
                                source: "icons/notification.svg"
                                size: 22
                                tint: moduleConfig.notificationEnabled ? "#ddd" : "#555"
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Text {
                                text: tr.notification
                                color: moduleConfig.notificationEnabled ? "#ddd" : "#666"
                                font {
                                    family: "Noto Sans CJK SC"
                                    pixelSize: 14
                                }
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                            }

                            ToggleSwitch {
                                Layout.alignment: Qt.AlignVCenter
                                checked: moduleConfig.notificationEnabled
                                onCheckedChanged: moduleConfig.notificationEnabled = checked
                            }
                        }
                    }

                    // ── Wallpaper ──
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        color: "transparent"

                        RowLayout {
                            width: parent.width
                            height: parent.height
                            spacing: 12

                            ColorIcon {
                                source: "icons/wallpaper.svg"
                                size: 22
                                tint: moduleConfig.wallpaperEnabled ? "#ddd" : "#555"
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Text {
                                text: tr.wallpaper
                                color: moduleConfig.wallpaperEnabled ? "#ddd" : "#666"
                                font {
                                    family: "Noto Sans CJK SC"
                                    pixelSize: 14
                                }
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                            }

                            ToggleSwitch {
                                Layout.alignment: Qt.AlignVCenter
                                checked: moduleConfig.wallpaperEnabled
                                onCheckedChanged: moduleConfig.wallpaperEnabled = checked
                            }
                        }
                    }

                    // ── Corners ──
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        color: "transparent"

                        RowLayout {
                            width: parent.width
                            height: parent.height
                            spacing: 12

                            ColorIcon {
                                source: "icons/corners.svg"
                                size: 22
                                tint: moduleConfig.cornersEnabled ? "#ddd" : "#555"
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Text {
                                text: tr.corners
                                color: moduleConfig.cornersEnabled ? "#ddd" : "#666"
                                font {
                                    family: "Noto Sans CJK SC"
                                    pixelSize: 14
                                }
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                            }

                            ToggleSwitch {
                                Layout.alignment: Qt.AlignVCenter
                                checked: moduleConfig.cornersEnabled
                                onCheckedChanged: moduleConfig.cornersEnabled = checked
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }
    }
}
