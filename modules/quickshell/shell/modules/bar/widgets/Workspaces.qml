import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import qs.modules.common

Repeater {
  model: 10
  delegate: Rectangle {
    required property int modelData
    readonly property bool specialActive: Hyprland.activeToplevel?.workspace.name - 1 == modelData
    readonly property bool active: (Hyprland.focusedWorkspace?.id - 1 ?? 0) == modelData
    readonly property bool urgent: Hyprland.toplevels.values.some(win =>
      win?.workspace?.id === modelData + 1 && win.urgent
    )
    color:  urgent ? Colour.red : specialActive ? Colour.blue : Colour.text
    Layout.alignment: Qt.AlignHCenter
    implicitWidth: 24
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
