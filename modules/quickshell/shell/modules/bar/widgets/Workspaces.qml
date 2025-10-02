import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import qs.config as Cfg

Repeater {
  model: Cfg.General.bar.workspaceCount
  delegate: Rectangle {
    required property int modelData
    readonly property bool specialActive: Hyprland.activeToplevel?.workspace.name - 1 == modelData
    readonly property bool active: (Hyprland.focusedWorkspace?.id - 1 ?? 0) == modelData
    readonly property bool urgent: Hyprland.toplevels.values.some(win =>
      win?.workspace?.id === modelData + 1 && win.urgent
    )
    color:  urgent ? Cfg.Colors.data.red : specialActive ? Cfg.Colors.data.blue : Cfg.Colors.data.text
    Layout.alignment: Qt.AlignHCenter
    implicitWidth: 20
    implicitHeight: this.implicitWidth * (active ? 1.5 : 1)
    radius: this.implicitWidth

    Behavior on implicitHeight {
      NumberAnimation {
        duration: 100
      }
    }

    MouseArea {
      anchors.fill: parent
      onClicked: Hyprland.dispatch("workspace " + (parent.modelData + 1))
      cursorShape: Qt.PointingHandCursor
    }
  }
}
