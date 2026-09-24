import QtQuick
import Quickshell
import Quickshell.Hyprland
import QtQuick.Layouts

PanelWindow {
    Colors {id:wal}
    anchors {
        bottom: true;
        left: true;
    }
    margins {
        bottom: 5;
        left: 5;
    }
    color: "transparent"
    implicitHeight:100;
    implicitWidth:1920;

    // property

    RowLayout {
        Repeater {
            model:1
            Rectangle {
                required property int index
                implicitWidth: 200;
                implicitHeight: 100;
                color: wal.background
                radius: 10
                ColumnLayout {
                Repeater {
                    model:Hyprland.toplevels.values.length
                    Text {
                        // text: `${Hyprland.toplevels.values[index].lastIpcObject."at"[0]},${Hyprland.toplevels.values[index].lastIpcObject.at[1]}`
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
            console.log(Hyprland.toplevels.values[0].lastIpcObject.at)
            Hyprland.refreshToplevels()
        }
    }
}
