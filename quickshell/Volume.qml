import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: root

    // accroding to your PC
    property int nsteps: 87
    property int stepsize: 2
    property real max_dB: (root.nsteps * root.stepsize) / 4

    property real percent_volume:0
    property string result:"111"
    property real current_dB: 1

    Process {
        id: max_volume_dB
        command: ["sh","-c","wpctl get-volume @DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.percent_volume = parseFloat(this.text.match(/-?\d+(\.\d+)?/g))
                root.current_dB = (root.percent_volume * root.max_dB).toFixed(2)
                if (/\bMUTED\b/.test(this.text)) {
                    root.result = `Muted ${parseInt(root.percent_volume * 100)}% ${root.current_dB}dB`
                } else {
                    root.result = `${parseInt(root.percent_volume * 100)}% ${current_dB}dB`
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
