import Quickshell
import Quickshell.Io
import "services" as Svc
import QtQuick
import QtQuick.Layouts

FloatingWindow {
  id: root
  implicitWidth: 500
  implicitHeight: Math.min(520, 90 + chartColumn.implicitHeight)

  color: "transparent"
  title: "Code Time"

  Process {
    id: centerProc
    command: ["sh", "-c", "sleep 0.3; addr=$(hyprctl clients | awk '/Window/{a=$2} /title: Code Time/{print a; exit}'); [ -z \"$addr\" ] && exit 0; floating=$(hyprctl clients | awk -v a=\"$addr\" '$0~\"Window \"a{f=1} f&&/floating:/{print $2; exit}'); [ \"$floating\" = \"0\" ] && hyprctl dispatch togglefloating address:\"$addr\" 2>/dev/null; sleep 0.1; hyprctl dispatch centerwindow address:\"$addr\" 2>/dev/null"]
    running: false
  }

  Timer {
    id: centerTimer
    interval: 200
    onTriggered: centerProc.running = true
  }

  Component.onCompleted: centerTimer.restart()

  Rectangle {
    anchors.fill: parent
    radius: 14
    color: Svc.WallpaperTheme.bg
    opacity: 0.96

    Rectangle {
      anchors.fill: parent
      radius: 14
      color: Svc.WallpaperTheme.surface
      border.color: Qt.rgba(Svc.WallpaperTheme.primary.r, Svc.WallpaperTheme.primary.g, Svc.WallpaperTheme.primary.b, 0.15)
      border.width: 1
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 16
    spacing: 8

    RowLayout {
      Layout.fillWidth: true

      Text {
        text: "Code Time"
        color: Svc.WallpaperTheme.on_surface_bright
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 16
        font.bold: true
      }

      Item { Layout.fillWidth: true }

      Text {
        text: "✕"
        color: Svc.WallpaperTheme.on_surface_dim
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 18

        MouseArea {
          anchors.fill: parent
          anchors.margins: -6
          cursorShape: Qt.PointingHandCursor
          onClicked: closeProc.running = true
        }
      }
    }

    Process {
      id: closeProc
      command: ["sh", "-c", "date '+%s%N' > /tmp/qscodetime-toggle"]
      running: false
    }

    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 1
      color: Svc.WallpaperTheme.on_surface_dim
      opacity: 0.15
    }

    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 56
      radius: 10
      color: Qt.rgba(Svc.WallpaperTheme.primary.r, Svc.WallpaperTheme.primary.g, Svc.WallpaperTheme.primary.b, 0.08)

      RowLayout {
        anchors.fill: parent
        anchors.margins: 12

        Text {
          text: "Total"
          color: Svc.WallpaperTheme.on_surface_dim
          font.family: "JetBrainsMono Nerd Font"
          font.pixelSize: 13
          font.bold: true
          Layout.alignment: Qt.AlignVCenter
        }

        Item { Layout.fillWidth: true }

        Text {
          text: CodeTime.totalText
          color: Svc.WallpaperTheme.primary
          font.family: "JetBrainsMono Nerd Font"
          font.pixelSize: 22
          font.bold: true
          Layout.alignment: Qt.AlignVCenter
        }
      }
    }

    Text {
      text: "Daily Breakdown"
      color: Svc.WallpaperTheme.on_surface
      font.family: "JetBrainsMono Nerd Font"
      font.pixelSize: 13
      font.bold: true
      Layout.topMargin: 4
    }

    Column {
      id: chartColumn
      Layout.fillWidth: true
      spacing: 6

      Repeater {
        model: CodeTime.dailyData
        delegate: RowLayout {
          spacing: 8
          Layout.fillWidth: true

          Text {
            text: modelData.date.slice(5)
            color: Svc.WallpaperTheme.on_surface_dim
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 11
            font.bold: true
            Layout.preferredWidth: 52
            Layout.alignment: Qt.AlignVCenter
          }

          Rectangle {
            Layout.preferredHeight: 18
            Layout.preferredWidth: Math.max(4, (modelData.seconds / CodeTime.maxDailySeconds) * 300)
            radius: 4
            color: {
              const ratio = modelData.seconds / CodeTime.maxDailySeconds;
              if (ratio > 0.75) return Svc.WallpaperTheme.accent3;
              if (ratio > 0.4) return Svc.WallpaperTheme.accent2;
              return Svc.WallpaperTheme.primary;
            }

            Behavior on Layout.preferredWidth {
              NumberAnimation {
                duration: 400
                easing.type: Easing.OutCubic
              }
            }
          }

          Item { Layout.fillWidth: true }

          Text {
            text: modelData.text
            color: Svc.WallpaperTheme.on_surface
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 11
            font.bold: true
            Layout.alignment: Qt.AlignVCenter
          }
        }
      }

      Text {
        visible: CodeTime.dailyData.length === 0
        text: "No data yet"
        color: Svc.WallpaperTheme.on_surface_dim
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 12
        font.italic: true
        anchors.horizontalCenter: parent.horizontalCenter
      }
    }
  }
}
