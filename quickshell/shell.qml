import Quickshell
import Quickshell.Io
import QtQuick

import "services" as Svc
import "modules/bar"
import "modules/onScreenDisplay"
import "modules/notificationPopup"

Scope {
  id: root
  property bool initialized: false
  property string lastToggle: ""

  Bar {}

  Loader {
    id: codeTimeLoader
    active: false
    source: "CodeTimePanel.qml"
  }

  OSD { id: osd }

  NotificationPopup { id: notificationPopup }

  Process {
    id: toggleProc
    command: ["bash", "-c", "cat /tmp/qscodetime-toggle 2>/dev/null || true"]
    running: false

    stdout: StdioCollector {
      onStreamFinished: {
        const content = this.text.trim()
        if (!root.initialized) {
          root.initialized = true
          root.lastToggle = content
        } else if (content.length > 0 && content !== root.lastToggle) {
          root.lastToggle = content
          codeTimeLoader.active = !codeTimeLoader.active
        }
      }
    }
  }

  Timer {
    interval: 500
    running: true
    repeat: true
    onTriggered: toggleProc.running = true
  }

  Component.onCompleted: {
    // WallpaperTheme, services auto-initialize via their own Component.onCompleted
  }
}
