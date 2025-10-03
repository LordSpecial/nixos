import QtQuick
import QtQuick.Layouts

import qs.modules.common
import qs.modules.bar.widgets as Wid

Item {
  ColumnLayout {
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    spacing: 8

    Wid.CpuNMem {}
  }
}
