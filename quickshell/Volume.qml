import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: root

    // accroding to your PC
    property int nsteps: 87
    property int stepsize: 2
    property real max_dB: (root.nsteps * root.stepsize) / 4

    property int percent_volume
    property string result:"111"

    Process {
        id: max_volume_dB
        command: ["sh","-c","wpctl get-volume @DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.percent_volume = parseFloat(this.text.match(/-?\d+(\.\d+)?/g))
                if (/\bMUTED\b/.test(this.text)) {
                    root.result = `Muted ${root.percent_volume}% ${root.percent_volume * root.max_dB}dB`
                } else {
                    root.result = `${root.percent_volume}% ${root.percent_volume * root.max_dB}dB`
                }
            }
        }
    }

    Timer {
        id: buffer
        interval: 30
        onTriggered: {
            max_volume_dB.running = false
            max_volume_dB.running = true
        }
    }

    function restart():void {
        buffer.restart()
    }
}
