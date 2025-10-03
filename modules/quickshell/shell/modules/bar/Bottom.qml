import QtQuick
import QtQuick.Layouts

import qs.modules.common
import qs.modules.bar.widgets as Widgets

Item {
  ColumnLayout {
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    spacing: 8

    Widgets.Time {}
    Widgets.BatteryIndicator {}
  }
}
