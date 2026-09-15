import QtQuick
import Quickshell
import Quickshell.Hyprland
import QtQuick.Layouts

PanelWindow {
    anchors {
        bottom: true;
        left: true;
    }
    implicitWidth: 500;
    implicitHeight: 100;
    margins {
        bottom: 5;
        left: 5;
    }

    readonly property var ws: Hyprland.workspaces 

    ColumnLayout {
        Repeater {
            model: ws.toplevels
            delegate: Text {
                text:`${modelData.lastIpcObject.at[1]}` 
                // text:2 
            }
        }

    }

    // Repeater {
    //     model: HyprlandToplevel
    //     delegate: Text {
    //         text: modelData.title
    //     }
    // }

}
