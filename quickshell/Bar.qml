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

    Rectangle {
	anchors.fill: parent
    	color: colorsJson.colors.color0
	opacity: 0.9

	//Rectangle {
	//    anchors {
	//    	left: true
	    	//top: true
	//    }
	    //spacing: 4
	    Repeater {
		model: SystemTray.items
		delegate: MouseArea {
		    width:25
		    height: 33
		
		    Image {
			anchors.fill: parent
			source: modelData.icon
			smooth: true
		    }

		    onClicked: (mouse)=>{
			if (mouse.button === Qt.RightButton) {
			    modelData.display(trayIconArea, mouse.x, mouse.y)
			    console.log(0)
			}
			else if (mouse.button === Qt.LeftButton) {
			    modelData.activate()
			}
		    }
		}
	    }
	}

	Text {
	    anchors.centerIn: parent
            text: Qt.formatDateTime(clock.date, "MM dd hh:mm")
	    color: colorsJson.special.foreground
	    font.pixelSize: 16
	    font.family: "JetBrainsMono Nerd Font"
	    font.weight: Font.ExtraBlod
        }
    //}
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

}


	    

    
