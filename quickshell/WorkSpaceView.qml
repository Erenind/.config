import QtQuick
import Quickshell
import Quickshell.Hyprland
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Widgets

Item {
    id: root

    Colors { id: wal }

    readonly property int resolusion_width: 1920
    readonly property int resolusion_height: 1080
    readonly property real scaling: 0.173
    readonly property int gap: 10

    // 每个面板显示几个工作区，以及左右面板各自起始的工作区 id
    readonly property int workspacePerPanel: 5
    readonly property int leftFirstWorkspace: 1
    readonly property int rightFirstWorkspace: 6

    readonly property real workspaceWidth: resolusion_width * scaling
    readonly property real workspaceHeight: resolusion_height * scaling

    // 按工作区 id 查找，还没创建的返回 null（面板里留空）
    function workspaceById(id) {
        const values = Hyprland.workspaces.values
        for (let i = 0; i < values.length; i++) {
            if (values[i].id === id)
                return values[i]
        }
        return null
    }

    // 一个工作区总览面板；左右两侧各放一个，右侧的 mirrored 为 true
    component WorkspacePanel: PanelWindow {
        id: panel

        required property int firstWorkspaceId
        // 右侧面板为 true：窗口的 x 坐标左右镜像，面板贴右上角
        property bool mirrored: false

        visible: false
        color: "transparent"

        anchors {
            top: true
            left: !panel.mirrored
            right: panel.mirrored
        }

        margins {
            top: root.gap
            left: panel.mirrored ? 0 : root.gap
            right: panel.mirrored ? root.gap : 0
        }

        // 面板尺寸正好等于内容，留白全部交给 margins，
        // 否则内容贴在面板左上角，多出来的宽度会全堆到右侧
        implicitWidth: root.workspaceWidth
        implicitHeight: root.workspaceHeight * root.workspacePerPanel + (root.workspacePerPanel - 1) * root.gap

        ColumnLayout {
            spacing: root.gap

            Repeater {
                model: root.workspacePerPanel

                Rectangle {
                    id: workspace_rect
                    required property int index

                    readonly property int workspaceId: panel.firstWorkspaceId + workspace_rect.index
                    readonly property var workspace: root.workspaceById(workspace_rect.workspaceId)

                    implicitWidth: root.workspaceWidth
                    implicitHeight: root.workspaceHeight
                    color: wal.background
                    radius: 10

                    Repeater {
                        model: workspace_rect.workspace ? workspace_rect.workspace.toplevels.values.length : 0

                        Rectangle {
                            id: tile
                            required property int index

                            // 该工作区里对应的窗口（不存在时为 null）
                            readonly property var toplevel: {
                                const ws = workspace_rect.workspace
                                if (!ws) return null
                                const tl = ws.toplevels.values[index]
                                return tl ? tl : null
                            }

                            // 窗口的 IPC 数据
                            readonly property var ipc: tile.toplevel ? tile.toplevel.lastIpcObject : null

                            // 用于匹配图标与桌面条目的窗口标识（优先 initialClass，而不是直接显示 class）
                            readonly property string appId: tile.ipc ? (tile.ipc.initialClass || tile.ipc.class || "") : ""

                            // 匹配到的 .desktop 桌面条目，匹配不到时为 null
                            readonly property var desktopEntry: tile.appId !== "" ? DesktopEntries.heuristicLookup(tile.appId) : null

                            // 方块中间的图标路径
                            readonly property string iconSource: {
                                const iconName = tile.desktopEntry && tile.desktopEntry.icon !== "" ? tile.desktopEntry.icon : tile.appId
                                if (iconName === "") return ""
                                return Quickshell.iconPath(iconName, true)
                            }

                            // 图标下方的应用名（桌面条目的正式名称，找不到时回退窗口标题）
                            readonly property string appName: {
                                if (tile.desktopEntry && tile.desktopEntry.name !== "") return tile.desktopEntry.name
                                return tile.toplevel ? tile.toplevel.title : ""
                            }

                            readonly property real iconSize: Math.max(12, Math.min(tile.height * 0.4, 64))
                            readonly property real labelSize: Math.max(9, Math.min(tile.height * 0.12, 15))

                            implicitWidth: tile.ipc ? tile.ipc.size[0] * root.scaling : 0
                            implicitHeight: tile.ipc ? tile.ipc.size[1] * root.scaling : 0
                            x: tile.ipc ? (panel.mirrored ? root.resolusion_width - tile.ipc.at[0] - tile.ipc.size[0] : tile.ipc.at[0]) * root.scaling : 0
                            y: tile.ipc ? tile.ipc.at[1] * root.scaling : 0
                            radius: 8
                            color: wal.foreground

                            ColumnLayout {
                                anchors.centerIn: parent
                                width: Math.max(0, tile.width * 0.9)
                                spacing: 4

                                IconImage {
                                    Layout.alignment: Qt.AlignHCenter
                                    visible: tile.iconSource !== ""
                                    implicitSize: tile.iconSize
                                    source: tile.iconSource
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: tile.appName
                                    color: wal.background
                                    font.pixelSize: tile.labelSize
                                    font.bold: true
                                    horizontalAlignment: Text.AlignHCenter
                                    elide: Text.ElideRight
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    WorkspacePanel {
        id: panel_left
        firstWorkspaceId: root.leftFirstWorkspace
        mirrored: false
    }

    WorkspacePanel {
        id: panel_right
        firstWorkspaceId: root.rightFirstWorkspace
        mirrored: true
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            Hyprland.refreshToplevels()
        }
    }

    IpcHandler {
        target: "workspace_view"

        // 由 hyprland 绑定触发（Super + B），再按一次收起
        function workspace_view():void {
            const shown = !panel_left.visible
            panel_left.visible = shown
            panel_right.visible = shown
        }
    }
}
