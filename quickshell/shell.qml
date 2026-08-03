import Quickshell

Scope {
    id: root

    PersistentProperties {
        id: config
        reloadableId: "moduleConfig"
        property bool barEnabled: false
        property bool systemInfoEnabled: false
        property bool blockEnabled: false
        property bool notificationEnabled: false
        property bool wallpaperEnabled: false
        property bool cornersEnabled: false
    }

    Controler {
        id: controller
        moduleConfig: config
    }

    LazyLoader {
        active: config.barEnabled
        Bar {}
    }

    LazyLoader {
        active: config.cornersEnabled
        Corners {}
    }

    // Future modules:
    // LazyLoader { active: config.systemInfoEnabled; source: "SystemInfo.qml" }
    // LazyLoader { active: config.blockEnabled; source: "Block.qml" }
    // LazyLoader { active: config.notificationEnabled; source: "Notification.qml" }
    // LazyLoader { active: config.wallpaperEnabled; source: "Wallpaper.qml" }
}
