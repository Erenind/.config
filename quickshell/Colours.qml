import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property color background: "#000000"
    property color foreground: "#ffffff"
    property color cursor: "#ffffff"

    property color color0: "#000000"
    property color color1: "#000000"
    property color color2: "#000000"
    property color color3: "#000000"
    property color color4: "#000000"
    property color color5: "#000000"
    property color color6: "#000000"
    property color color7: "#000000"
    property color color8: "#000000"
    property color color9: "#000000"
    property color color10: "#000000"
    property color color11: "#000000"
    property color color12: "#000000"
    property color color13: "#000000"
    property color color14: "#000000"
    property color color15: "#000000"

    // readonly property string wallpaper: ""
    // readonly property string checksum: ""

    // signal loaded()

    // FileView {
    //     id: fileView
    //     path: Env.getEnv("HOME") + "/.cache/wal/colors.json"
    //     watchChanges: true
    //     onFileChanged: reload()
    //     onLoaded: {
    //         try {
    //             const wal = JSON.parse(fileView.text())
    //             root.background = wal.special.background
    //             root.foreground = wal.special.foreground
    //             root.cursor = wal.special.cursor
    //             root.color0 = wal.colors.color0
    //             root.color1 = wal.colors.color1
    //             root.color2 = wal.colors.color2
    //             root.color3 = wal.colors.color3
    //             root.color4 = wal.colors.color4
    //             root.color5 = wal.colors.color5
    //             root.color6 = wal.colors.color6
    //             root.color7 = wal.colors.color7
    //             root.color8 = wal.colors.color8
    //             root.color9 = wal.colors.color9
    //             root.color10 = wal.colors.color10
    //             root.color11 = wal.colors.color11
    //             root.color12 = wal.colors.color12
    //             root.color13 = wal.colors.color13
    //             root.color14 = wal.colors.color14
    //             root.color15 = wal.colors.color15
    //             root.wallpaper = wal.wallpaper ?? ""
    //             root.checksum = wal.checksum ?? ""
    //             root.loaded()
    //         } catch (e) {}
    //     }
    // }

    // function reload(): void {
    //     fileView.reload()
    // }
    FileView {
        id: pywalColorJson

        path: "/home/kyee/.cache/wal/colors.json"

        watchChanges: true

        

    }
}
