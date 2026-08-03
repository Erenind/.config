import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Services.SystemTray

PanelWindow {
    id: bar

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 33

    color: "transparent"

    FileView {
	path: "/home/kyee/.cache/wal/colors.json"

	watchChanges: true

	
	JsonAdapter {
	    id: colorsJson
	    property var colors
	    property var special
		property var color0
		property var colorscolor1
		property var foreground
	}
    }

	Text {
	    anchors.centerIn: parent
            text: Qt.formatDateTime(clock.date, "MM dd hh:mm")
	    color: colorsJson.special?.foreground ?? "#ffffff"
	    font.pixelSize: 16
	    font.family: "JetBrainsMono Nerd Font"
	    font.weight: Font.ExtraBold
        }
    //}
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

}


	    

    
