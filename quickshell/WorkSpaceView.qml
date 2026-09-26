import QtQuick
import Quickshell
import Quickshell.Hyprland
import QtQuick.Layouts
import Quickshell.Io

PanelWindow {
    id:panel_left
    visible:false
    Colors {id:wal}
    anchors {
        top: true
        left: true
    }
    margins {
        top: 10
        left: 10
    }
    color: "transparent"

    property int resolusion_width:1920
    property int resolusion_height:1080
    property real scaling: 0.173

    implicitHeight: resolusion_height * scaling * 5 + 100
    implicitWidth: resolusion_width * scaling

    ColumnLayout {
        Repeater {
            model:5
            Rectangle {
                required property int index
                implicitWidth: resolusion_width * scaling
                implicitHeight: resolusion_height * scaling
                color: wal.background

                radius: 10
                ColumnLayout {
                    Repeater {
                        model:Hyprland.toplevels.values.length
                        Text {
                            text: Hyprland.toplevels.values[index].lastIpcObject.title
                            color: wal.color3
                        }
                    }
                }
            }
        }
    }
    Timer {
        interval:3000
        running: true
        repeat:true
        onTriggered: {
            // console.log(Hyprland.toplevels.values[0].lastIpcObject.at)
            Hyprland.refreshToplevels()
        }
    }

    Timer {
        id: show_timer
        interval: 3000
        onTriggered: {
            panel_left.visible = false
        }
    }

    IpcHandler {
        target: "workspace_view"

        function workspace_view():void {
            panel_left.visible = true
            show_timer.restart()
        }
    }

}
