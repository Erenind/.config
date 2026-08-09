import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    property int capacity: 0
    property string capacityLevel: ""
    property string status: ""
    property double energy: 0          // Wh
    property double power: 0           // W
    property double health: 0          // %

    property int _eNow: 0
    property int _eFull: 0
    property int _eFullDes: 0
    property int _pNow: 0

    on_ENowChanged: energy = _eNow / 1000000
    on_PNowChanged: power = _pNow / 1000000
    on_EFullChanged: _updateHealth()
    on_EFullDesChanged: _updateHealth()

    function _updateHealth() {
        if (_eFullDes > 0)
            health = _eFull / _eFullDes * 100
    }

    function _setInt(val, prop) {
        const v = parseInt(val)
        if (isNaN(v)) return
        if (root[prop] !== v) root[prop] = v
    }

    function _setProp(val, prop) {
        if (val !== root[prop]) root[prop] = val
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            capFv.reload()
            capLvlFv.reload()
            eNowFv.reload()
            eFullFv.reload()
            eFullDesFv.reload()
            pNowFv.reload()
            statFv.reload()
        }
    }

    FileView { id: capFv;     path: "/sys/class/power_supply/BAT0/capacity";           onLoaded: _setInt(text(), "capacity") }
    FileView { id: capLvlFv;  path: "/sys/class/power_supply/BAT0/capacity_level";     onLoaded: _setProp(text(), "capacityLevel") }
    FileView { id: eNowFv;    path: "/sys/class/power_supply/BAT0/energy_now";         onLoaded: _setInt(text(), "_eNow") }
    FileView { id: eFullFv;   path: "/sys/class/power_supply/BAT0/energy_full";        onLoaded: _setInt(text(), "_eFull") }
    FileView { id: eFullDesFv; path: "/sys/class/power_supply/BAT0/energy_full_design"; onLoaded: _setInt(text(), "_eFullDes") }
    FileView { id: pNowFv;    path: "/sys/class/power_supply/BAT0/power_now";          onLoaded: _setInt(text(), "_pNow") }
    FileView { id: statFv;    path: "/sys/class/power_supply/BAT0/status";             onLoaded: _setProp(text(), "status") }
}
