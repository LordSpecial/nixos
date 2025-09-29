import QtQuick
import QtQuick.Layouts

import qs.components
import qs.config as Cfg
import qs.services
import qs.modules.common.widgets

Child {
    Layout.fillWidth: true
    implicitHeight: this.width * 1.1
    implicitWidth: this.width

    readonly property color iconColour: {
        if (Battery.isCharging) return Cfg.Colors.data.green
        else if (Battery.isCritical) return Cfg.Colors.data.red
        else if (Battery.isLow) return Cfg.Colors.data.yellow
        else return Cfg.Colors.data.lavender
    }


    Text {
        anchors.centerIn: parent
        visible: true
        font.pixelSize: Math.min(parent.width, parent.height) * 0.6
        font.bold: true
        color: iconColour
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: {
            if (Battery.isCharging) {
                if (Battery.percentage >= 0.98) return "󰂅"       // Charging full
                if (Battery.percentage >= 0.9) return "󰂋"        // Charging 90%
                else if (Battery.percentage >= 0.80) return "󰂊"  // Charging 80%
                else if (Battery.percentage >= 0.70) return "󰢞"  // Charging 70%
                else if (Battery.percentage >= 0.60) return "󰂉"  // Charging 60%
                else if (Battery.percentage >= 0.50) return "󰢝"  // Charging 50%
                else if (Battery.percentage >= 0.40) return "󰂈"  // Charging 40%
                else if (Battery.percentage >= 0.30) return "󰂇"  // Charging 30%
                else if (Battery.percentage >= 0.20) return "󰂆"  // Charging 20%
                else if (Battery.percentage >= 0.10) return "󰢜"  // Charging 10%
                else return "󰢟"                     // Charging empty
            }

            // Not charging - show regular battery levels
            if (Battery.percentage >= 0.9) return "󰁹"       // Full battery
            else if (Battery.percentage >= 0.80) return "󰂁" // 80%
            else if (Battery.percentage >= 0.70) return "󰂀" // 70%
            else if (Battery.percentage >= 0.60) return "󰁿" // 60%
            else if (Battery.percentage >= 0.50) return "󰁾" // 50%
            else if (Battery.percentage >= 0.40) return "󰁽" // 40%
            else if (Battery.percentage >= 0.30) return "󰁼" // 30%
            else if (Battery.percentage >= 0.20) return "󰁻" // 20%
            else if (Battery.percentage >= 0.10) return "󰁺" // 10%
            else return "󰂃"                    // Empty battery
        }


        SequentialAnimation on scale {
            running: Battery.isCharging
            loops: Animation.Infinite
            NumberAnimation { to: 1.1; duration: 2000; easing.type: Easing.InOutSine }
            NumberAnimation { to: 1.0; duration: 2000; easing.type: Easing.InOutSine }
        }

        SequentialAnimation on opacity {
            running: !Battery.isCharging && Battery.isCritical
            loops: Animation.Infinite
            NumberAnimation { to: 0.3; duration: 500 }
            NumberAnimation { to: 1.0; duration: 500 }
        }
    }

    MouseArea {
        id: mArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        // FIXME do something on click
        onPressed: console.log("Battery clicked: " + Battery.percentage + "%")
    }
}
