import Quickshell
import QtQuick
import Quickshell.Process

Item {
    property int max_dB
    property int current_dB
    property int percent
    property bool muted

    Process {
        id: volumeProcess

        
    }
}