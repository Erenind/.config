import QtQuick
import Quickshell

FloatingWindow {
    id: root

    required property var colours

    implicitWidth: 300
    implicitHeight: implicitWidth
    color: colours.background
}
