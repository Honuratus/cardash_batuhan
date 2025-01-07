import QtQuick 2.15
import QtQuick.Shapes 1.15
import Qt5Compat.GraphicalEffects


Item {

    //Width and height
    property real widthValue: 500
    property real heightValue: 500

    id: progress
    implicitWidth: widthValue
    implicitHeight: heightValue
    antialiasing: true


    //General
    property bool spRoundCap: false
    property int startAngle: -228
    property real maxValue: 100
    property real value: 270 / 3.6
    property int samples: 20
    //Properties
    property color bgColor: "#1B1B1B" //1B1B1B
    property color bgStrokeColor: "black"
    property int bgStrokeWidth: 32

    //Progress Circle
    property color progressColor: "#55aaff"
    property int progressWidth: 32

    //Text
    property string textValue: ""
    property bool textShowValue: true
    property string fontFamily: "Segoe UI"
    property int textSize: 64
    property color textColor: "#fff"

    //Property title text
    property string titleTextValue: "KM/H"
    property string titleFontFamily: "Segoe UI"
    property int titleTextSize: 16;
    property color titleTextColor: "red"
    property bool isBold: true

    property string imageSource: "images/speedometer_inner.png"

    Shape{
        id: shape
        anchors.fill: parent
        layer.enabled: true
        //layer.samples: progress.samples
        antialiasing: true
        smooth: true

        ShapePath{
            id:pathBg
            strokeColor: progress.bgStrokeColor
            fillColor: progress.bgColor
            strokeWidth: progress.bgStrokeWidth
            capStyle: progress.spRoundCap ? ShapePath.RoundCap : ShapePath.FlatCap

            PathAngleArc{
                radiusX: (progress.width / 2) - (progress.progressWidth / 2)
                radiusY: (progress.height / 2) - (progress.progressWidth / 2)
                centerX: progress.width / 2
                centerY: progress.height / 2
                startAngle: progress.startAngle
                sweepAngle: 360

            }
        }
        Image{
            source: progress.imageSource
            width: 460
            height: 440
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2 - 20
        }

        ShapePath{
            id:path
            strokeColor: progress.progressColor
            fillColor: "transparent"
            strokeWidth: progress.bgStrokeWidth
            capStyle: progress.spRoundCap ? ShapePath.RoundCap : ShapePath.FlatCap

            PathAngleArc{
                radiusX: (progress.width / 2) - (progress.progressWidth / 2)
                radiusY: (progress.height / 2) - (progress.progressWidth / 2)
                centerX: progress.width / 2
                centerY: progress.height / 2
                startAngle: progress.startAngle
                sweepAngle: (360 / progress.maxValue * progress.value)
            }
        }
        Text{
            id:textProgress
            text: progress.textValue
            font.family: progress.fontFamily
            font.bold: true
            font.italic: true
            font.pointSize: progress.textSize
            color: progress.textColor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
        Text{
            id: titleProgress
            color: progress.titleTextColor
            font.family: progress.titleFontFamily
            font.bold: true
            font.italic: true
            text: progress.titleTextValue
            anchors.top: textProgress.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: progress.titleTextSize
            anchors.topMargin: 15
        }
    }

}
