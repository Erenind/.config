import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    // acoording to your screen
    property int max_nits: 300
    property string backlight_path: "/sys/class/backlight/intel_backlight"

    property int current_nits: 0
    property int max_brightness: 0
    property int brightness: 0
    property string result: ""

    Process {
        id:max_brightness_process
        running: true
        command: ["cat", `${backlight_path}/max_brightness`]
        stdout: StdioCollector {
            onStreamFinished: root.max_brightness = this.text
        }
    }
    Process {
        id:brightness_process
        running: true
        command: ["cat", `${backlight_path}/brightness`]
        stdout: StdioCollector {
            onStreamFinished: {
                root.brightness = this.text
                root.result = `${root.brightness}/${root.max_brightness}`
            }
        }
    }
    Timer {
        id:buffer
        interval:30
        onTriggered: {
            max_brightness_process.running = false
            brightness_process.running = false
            max_brightness_process.running = true
            brightness_process.running = true
        }
    }
    function restart(): void {
        buffer.restart()
    }

}
