import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.data as Dat
import qs.modules.common

Variants {
  model: Quickshell.screens
  PanelWindow {
    readonly property int anchorMargin: 4
    required property ShellScreen modelData
    screen: modelData
    anchors {
      left: true
      bottom: true
      top: true
    }

    color: "transparent"
    implicitWidth: 60

    WlrLayershell.namespace: `${Dat.Paths.shellName}.bar.quickshell`
    WlrLayershell.exclusionMode: ExclusionMode.Auto
    WlrLayershell.layer: WlrLayer.Top

    Item {
      anchors.margins: anchorMargin
      anchors.rightMargin: 0
      anchors.fill: parent
      Rectangle {
        id: base
        radius: 10
        anchors.fill: parent
        color: Colour.base
      }

      Top {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: middleContainer.top
        anchors.margins: anchorMargin
      }
      Center {
        id: middleContainer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: anchorMargin
      }
      Bottom {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: middleContainer.bottom
        anchors.margins: anchorMargin
      }
    }
  }
}
