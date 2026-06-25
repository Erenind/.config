import QtQuick
import QtQuick.Shapes

Item {
  id: root
  property string path: ""
  property color color: "white"
  property int iconSize: 16

  implicitWidth: root.iconSize
  implicitHeight: root.iconSize

  Shape {
    anchors.fill: parent
    antialiasing: true

    ShapePath {
      fillColor: root.color
      strokeColor: "transparent"
      strokeWidth: 0

      PathSvg {
        path: root.path
      }
    }
  }
}
