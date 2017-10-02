import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    width: 640
    height: 480
    property alias backButton: backButton
    property alias forfeitButton: forfeitButton

    Grid {
        id: grid
        x: 232
        y: 8
        width: 400
        height: 400
        spacing: 1
        rows: 3
        columns: 3
    }

    Button {
        id: backButton
        x: 8
        y: 432
        width: 45
        height: 40
        text: qsTr("<")
        font.pointSize: 18
        ToolTip.visible: hovered
        ToolTip.delay: 1000
        ToolTip.timeout: 5000
        ToolTip.text: "Back to main menu"
    }

    Button {
        id: forfeitButton
        x: 59
        y: 432
        text: qsTr("Forfeit")
        font.pointSize: 18
    }
}
