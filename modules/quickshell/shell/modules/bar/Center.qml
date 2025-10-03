import QtQuick
import QtQuick.Layouts

import qs.modules.common
import qs.modules.bar.widgets as Wid

Item {
  height: col.implicitHeight

  ColumnLayout {
    id: col
    anchors.fill: parent
    spacing: 8

    Wid.Workspaces {}
    Rectangle {
      implicitHeight: 10
    }
    Wid.SpecialWorkspaces {}
  }
}
