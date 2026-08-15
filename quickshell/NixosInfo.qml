import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    property string version: ""
    property string codename: ""
    property int systemPackages: 0
    property int userPackages: 0
    property int generation: 0
    property int nixStoreCount: 0
    property string lastUpdated: ""
    property string kernelVersion: ""

    Timer {
        interval: 0
        running: true
        repeat: false
        onTriggered: {
            versionFv.reload()
            osReleaseFv.reload()
        }
    }

    FileView {
        id: versionFv
        path: "/run/current-system/nixos-version"
        onLoaded: {
            const v = text().trim().split(".")
            if (v !== root.version) root.version = v.slice(0,2).join(".")
        }
    }

    FileView {
        id: osReleaseFv
        path: "/run/current-system/etc/os-release"
        onLoaded: {
            const match = text().match(/VERSION_CODENAME=(\S+)/)
            if (match) {
                const cn = match[1]
                if (cn !== root.codename) root.codename = cn
            }
        }
    }

    Process {
        id: genProc
        command: ["readlink", "/nix/var/nix/profiles/system"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const match = data.trim().match(/system-(\d+)-link/)
                if (match) {
                    const g = parseInt(match[1])
                    if (!isNaN(g) && g !== root.generation) root.generation = g
                }
            }
        }
    }

    Process {
        id: sysPkgProc
        command: ["sh", "-c", "nix path-info -r --json /run/current-system | python3 -c 'import sys,json; print(len(json.load(sys.stdin)))'"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const v = parseInt(data.trim())
                if (!isNaN(v) && v !== root.systemPackages) root.systemPackages = v
            }
        }
    }

    Process {
        id: usrPkgProc
        command: ["sh", "-c", "a=$(nix profile list 2>/dev/null | wc -l); b=$(nix-env -q 2>/dev/null | wc -l); echo $((a + b))"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const v = parseInt(data.trim())
                if (!isNaN(v) && v !== root.userPackages) root.userPackages = v
            }
        }
    }

    Process {
        id: storeCountProcess
        command: ["sh", "-c", "ls -1 /nix/store | wc -l"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.nixStoreCount = parseInt(text.trim()) || 0
            }
        }
    }

    Process {
        command: ["sh","-c","nixos-rebuild list-generations | grep True"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.lastUpdated = this.text.trim().split(/\s+/)[1].slice(5) || "error"
                root.kernelVersion = this.text.trim().split(/\s+/)[4] || "error"
            }
        }
    }
}
