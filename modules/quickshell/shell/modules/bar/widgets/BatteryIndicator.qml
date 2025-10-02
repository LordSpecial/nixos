import QtQuick
import QtQuick.Layouts
import qs.components
import qs.config as Cfg
import qs.services

Child {
    id: root

    Layout.fillWidth: true
    implicitHeight: width * (mArea.containsMouse ? heightRatioExpanded : heightRatioCollapsed)

    readonly property real heightRatioCollapsed: 1.1
    readonly property real heightRatioExpanded: 1.7
    readonly property real iconSizeRatio: 0.6
    readonly property real percentSizeRatio: 0.5

    readonly property color iconColour: {
        if (Battery.isCharging) return Cfg.Colors.data.green
        if (Battery.isCritical) return Cfg.Colors.data.red
        if (Battery.isLow) return Cfg.Colors.data.yellow
        return Cfg.Colors.data.lavender
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    Text {
        id: batt_icon

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: mArea.containsMouse ? undefined : parent.verticalCenter
        anchors.bottom: mArea.containsMouse ? parent.bottom : undefined
        anchors.bottomMargin: mArea.containsMouse ? 0 : batt_icon.height / 4

        font.pixelSize: Math.min(parent.width, parent.height) * root.iconSizeRatio
        font.bold: true
        color: root.iconColour

        text: getBatteryIcon(Battery.percentage, Battery.isCharging)

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

    Text {
        id: batt_percent

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 10

        visible: mArea.containsMouse
        opacity: mArea.containsMouse ? 1.0 : 0.0

        font.pixelSize: Math.min(parent.width, parent.height) * root.percentSizeRatio
        font.bold: true
        color: root.iconColour

        text: Math.round(Battery.percentage * 100)

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
    }

    MouseArea {
        id: mArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }

    function getBatteryIcon(percentage, charging) {
        const chargingIcons = ["󰢟", "󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"]
        const normalIcons = ["󰂃", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰁹"]

        const icons = charging ? chargingIcons : normalIcons
        const index = Math.min(Math.floor(percentage * 10), icons.length - 1)

        return icons[index]
    }
}
