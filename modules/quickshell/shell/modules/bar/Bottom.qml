import QtQuick
import QtQuick.Layouts

import qs.config as Cfg
import qs.modules.bar.widgets as Widgets

Item {
  ColumnLayout {
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    spacing: Cfg.General.child.spacing

    Widgets.Time {}
    Widgets.BatteryIndicator {}
  }
}
