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
    property string lastUpdated: ""

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
            const v = text().trim()
            if (v !== root.version) root.version = v
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
        id: lastUpdProc
        command: ["stat", "-c", "%Y", "/run/current-system"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const ts = parseInt(data.trim())
                if (!isNaN(ts)) {
                    const dt = Qt.formatDateTime(new Date(ts * 1000), "yyyy-MM-dd HH:mm")
                    if (dt !== root.lastUpdated) root.lastUpdated = dt
                }
            }
        }
    }
}
