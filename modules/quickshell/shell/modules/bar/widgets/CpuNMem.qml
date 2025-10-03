import QtQuick
import QtQuick.Layouts

import qs.components as Cmp
import qs.modules.common
import qs.data as Dat

Child {
  Layout.fillWidth: true
  implicitHeight: col.implicitHeight + 8

  component StyledProgress: Cmp.CircularProgress {
    rotation: -180
    size: 28
    primaryColor: Colour.lavender
    secondaryColor: Colour.mantle
  }

  component Label: Item {
    required property real usage
    Layout.fillWidth: true
    implicitHeight: 10
    Cmp.StyledText {
      anchors.centerIn: parent
      color: Colour.text
      text: (parent.usage * 100).toFixed(0) + "%"
      font.pointSize: 11
    }
  }

  ColumnLayout {
    id: col
    spacing: 8
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter

    StyledProgress {
      Layout.alignment: Qt.AlignCenter
      value: Dat.Resources.cpuUsage
    }

    Label {
      visible: true
      usage: Dat.Resources.cpuUsage
    }

    StyledProgress {
      Layout.topMargin: 2
      Layout.alignment: Qt.AlignCenter
      value: Dat.Resources.memUsage
      primaryColor: Colour.blue
    }

    Label {
      visible: false
      usage: Dat.Resources.memUsage
    }
  }
}
