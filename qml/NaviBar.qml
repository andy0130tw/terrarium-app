import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: navigationBar
    width: parent.width
    height: 56 * scaleRatio
    anchors {
        bottom: parent.bottom
        left: parent.left
    }
    color: "white"

    property double tabWidth : 160
    property double tabHeight: 40

    Rectangle {
        id: repeater
        border.color: "#007edf"
        width: tabWidth * 3 * scaleRatio
        height: tabHeight * scaleRatio
        anchors.centerIn: parent 
        radius: 5 
        smooth: true
        visible: false
        Row {
            Rectangle {
                width: tabWidth * scaleRatio ; height: 40 * scaleRatio
                color: splitState == 'editor' ? "#007edf" : "transparent"
                Text {
                    text: "Editor"
                    color: splitState == 'editor' ? "white" : '#007edf'
                    anchors.centerIn: parent
                    font.pointSize: 12
                }
            }
            Rectangle {
                width: tabWidth * scaleRatio; height: 40 * scaleRatio
                border.width: 1
                border.color: "#007edf"
                color: splitState == 'splitted' ? "#007edf" : "transparent"
                Text {
                    text: "Split"
                    color: splitState == 'splitted' ? "white" : "#007edf"
                    anchors.centerIn: parent
                    font.pointSize: 12
                }
            }
            Rectangle {
                width: tabWidth * scaleRatio; height: 40 * scaleRatio
                color: splitState == 'viewer' ? "#007edf" : "transparent"
                Text {
                    text: "Viewer"
                    color: splitState == 'viewer' ? "white" : "#007edf"
                    anchors.centerIn: parent
                    font.pointSize: 12
                }
            }
        }

    }
    Rectangle {
        id: mask
        width: repeater.width
        height: repeater.height
        anchors.fill: repeater
        radius: 5
    }
    OpacityMask {
        visible: (parent.state === 'view')
        anchors.fill: repeater
        source: repeater
        maskSource: mask
    }

    Row {
        anchors.centerIn: parent
        visible: (parent.state === 'view')
        MouseArea {
            width: tabWidth * scaleRatio
            height: tabHeight * scaleRatio
            onPressed: splitState = 'editor'
        }
        MouseArea {
            width: tabWidth * scaleRatio
            height: tabHeight * scaleRatio
            onPressed: splitState = 'splitted'
        }
        MouseArea {
            width: tabWidth * scaleRatio
            height: tabHeight * scaleRatio
            onPressed: splitState = 'viewer'
        }
    }

    Text {
        visible: (parent.state == 'selection')
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            margins: 10 * scaleRatio 
        }
        font { family: fontAwesome.name; pointSize: 26 }
        text: "\uf057"
        color: 'grey'
        MouseArea {
            anchors.fill: parent
            anchors.margins: -5 * scaleRatio
            onPressed: { 
                navigationBar.state = 'view'; 
                editor.deselect();
            }
        }
    }

    Row {
        anchors.centerIn: parent
        visible: (parent.state === 'selection')
        spacing: 40 * scaleRatio
        Text {
            visible: (editor.selectionStart !== editor.selectionEnd)
            color: "#007edf"
            font.pointSize: 14
            text: "Cut"
            MouseArea {
                anchors.fill: parent
                anchors.margins: -5 * scaleRatio
                onPressed: editor.cut()
            }
        }
        Text {
            visible: (editor.selectionStart !== editor.selectionEnd)
            color: "#007edf"
            font.pointSize: 14
            text: "Copy"
            MouseArea {
                anchors.fill: parent
                anchors.margins: -5 * scaleRatio
                onPressed: { 
                    editor.copy()
                    editor.deselect()
                }
            }
        }
        Text {
            visible: (editor.selectionStart === editor.selectionEnd)
            color: "#007edf"
            font.pointSize: 14
            text: "Select"
            MouseArea {
                anchors.fill: parent
                anchors.margins: -5 * scaleRatio
                onPressed: editor.selectWord()
            }
        }
        Text {
            visible: (editor.selectionStart === editor.selectionEnd)
            color: "#007edf"
            font.pointSize: 14
            text: "Select All"
            MouseArea {
                anchors.fill: parent
                anchors.margins: -5 * scaleRatio
                onPressed: editor.selectAll()
            }
        }
        Text {
            visible: (editor.canPaste === true)
            color: "#007edf"
            font.pointSize: 14
            text: "Paste"
            MouseArea {
                anchors.fill: parent
                anchors.margins: -5 * scaleRatio
                onPressed: editor.paste()
            }
        }
    }

    states: [
        State { 
            name: "view"
        },
        State {
            name: "selection"
        }
    ]
}
