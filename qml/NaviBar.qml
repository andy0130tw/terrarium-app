import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: navigationBar
    width: parent.width
    height: Math.round(56 * scaleRatio)
    anchors {
        bottom: parent.bottom
        left: parent.left
    }
    color: "white"

    property int tabWidth: Math.round(160 * scaleRatio)
    property int tabHeight: Math.round(40 * scaleRatio)
    property string tabActiveBg: "#007edf"
    property string tabActiveFg: "white"
    property int fontPointSize: 14

    Rectangle {
        id: repeater
        border.color: tabActiveBg
        width: tabWidth * 3
        height: tabHeight
        anchors.centerIn: parent 
        radius: 5 
        smooth: true
        visible: false

        Row {
            Rectangle {
                width: tabWidth; height: tabHeight
                color: splitState == 'editor' ? tabActiveBg : "transparent"
                Text {
                    text: "Editor"
                    color: splitState == 'editor' ? tabActiveFg : tabActiveBg
                    anchors.centerIn: parent
                    font.pointSize: fontPointSize
                }
            }
            Rectangle {
                width: tabWidth; height: tabHeight
                border.width: 1
                border.color: tabActiveBg
                color: splitState == 'splitted' ? tabActiveBg : "transparent"
                Text {
                    text: "Split"
                    color: splitState == 'splitted' ? tabActiveFg : tabActiveBg
                    anchors.centerIn: parent
                    font.pointSize: fontPointSize
                }
            }
            Rectangle {
                width: tabWidth; height: tabHeight
                color: splitState == 'viewer' ? tabActiveBg : "transparent"
                Text {
                    text: "Viewer"
                    color: splitState == 'viewer' ? tabActiveFg : tabActiveBg
                    anchors.centerIn: parent
                    font.pointSize: fontPointSize
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
            width: tabWidth
            height: tabHeight
            onPressed: splitState = 'editor'
        }
        MouseArea {
            width: tabWidth
            height: tabHeight
            onPressed: splitState = 'splitted'
        }
        MouseArea {
            width: tabWidth
            height: tabHeight
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
            color: tabActiveBg
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
            color: tabActiveBg
            font.pointSize: fontPointSize
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
            color: tabActiveBg
            font.pointSize: fontPointSize
            text: "Select"
            MouseArea {
                anchors.fill: parent
                anchors.margins: -5 * scaleRatio
                onPressed: editor.selectWord()
            }
        }
        Text {
            visible: (editor.selectionStart === editor.selectionEnd)
            color: tabActiveBg
            font.pointSize: fontPointSize
            text: "Select All"
            MouseArea {
                anchors.fill: parent
                anchors.margins: -5 * scaleRatio
                onPressed: editor.selectAll()
            }
        }
        Text {
            visible: (editor.canPaste === true)
            color: tabActiveBg
            font.pointSize: fontPointSize
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
