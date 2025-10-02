import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.config as Cfg

ColumnLayout {
  spacing: 6
  Layout.alignment: Qt.AlignHCenter


  Repeater {
    model: [
  { name: "spotify", label: "" },
  { name: "slack", label: "" },
  { name: "discord", label: "" }
    ]

    delegate: Rectangle {
  required property var modelData

  readonly property string specialName: "special:" + modelData.name
  readonly property bool active: Hyprland.activeToplevel?.workspace.name === specialName ?? false

  // Loop through top levels to check for urgent
  readonly property bool urgent: Hyprland.toplevels.values.some(win =>
    win?.workspace?.id === modelData + 1 && win.urgent
  )
  readonly property bool hasWindows: Hyprland.toplevels.values.some(win =>
    win?.workspace?.name === specialName
  )

  color: urgent ? Cfg.Colors.data.red : active ? Cfg.Colors.data.blue : (hasWindows ? Cfg.Colors.data.text : Cfg.Colors.data.surface0)
  Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
  implicitWidth: 22   // Larger to accommodate text
  implicitHeight: 22  // Square shape
  radius: 8       // Slight rounding

  Behavior on color {
    ColorAnimation { duration: 100 }
  }

  MouseArea {
    anchors.fill: parent
    onClicked: Hyprland.dispatch("togglespecialworkspace " + parent.modelData.name)
    cursorShape: Qt.PointingHandCursor
  }

  // Icon/Letter display
  Text {
    anchors.centerIn: parent
    text: parent.modelData.label
    color: Cfg.Colors.data.base  // White/light text on colored background
    font.pixelSize: 18
    font.bold: true
    font.family: "NotoSans Nerd Font Mono"  // Change to "Symbols Nerd Font" or your preferred Nerd Font
  }
    }
  }

}
