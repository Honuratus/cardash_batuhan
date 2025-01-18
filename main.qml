import QtQuick
import QtQuick.Window

Window {
    id: mainWindow //Componente erişmemizi sağlayan bir attribute yada özellik
    width: 1920
    height: 1080
    visible: true
    title: qsTr("Hello World")
    color: "#1E1E1E"

    // frame
    Image{
        source: "images/frame.png"
        anchors.centerIn: parent
        anchors.fill: parent
    }

    // mid frame
    Rectangle{
        id: midframe
        width: parent.width / 2
        height: parent.height / 2
        anchors.centerIn: parent
        color: "#242424"
        border.color: "blue"
        border.width: 1
        radius: 10
        Item{
            width: childrenRect.width
            height: childrenRect.height
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            Image{
                id: batteryicon
                source: 'images/car-battery.svg'
                width: 50
                height: 50
                anchors.left: parent.left
            }
            Image{
                id: handbrakeicon
                source: 'images/car-handbrake.svg'
                width: 50
                height: 50
                anchors.left: batteryicon.right
                anchors.leftMargin: 20
            }
            Image{
                id: engineboldicon
                source: 'images/engine-bold.svg'
                width: 50
                height: 50
                anchors.left: handbrakeicon.right
                anchors.leftMargin: 20
            }
        }
        CircularBar{
            id: fuel
            progressColor: "darkblue"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            value: 66
            widthValue: 150
            heightValue: 150
            textSize: 16
            titleTextSize: 8
            bgStrokeWidth: 8
            titleTextValue: "Charge"
            startAngle: 90
            textValue: parseInt(fuel.value)+ "%"
        }
        Item{
            width: childrenRect.width
            height: childrenRect.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 100
            Text{
                id: clock
                text: "00:\n23"
                color: "#fff"
                font.pixelSize: 50
                font.bold: true
            }
            Text{
                id: tempreture
                text: "13\n°C"
                anchors.left: clock.right
                anchors.leftMargin: 100
                font.pixelSize: 50
                color: "#fff"
                font.bold: true
            }
        }
    }

    CircularBar{
        property int currentSpeed: 0

        id: speed
        progressColor: "#218130"
        anchors.left: parent.left
        value: currentSpeed * 77 / 200
        anchors.leftMargin: 100
        anchors.verticalCenter: parent.verticalCenter
        textValue: parseInt(speed.value * 200 / 77) //progress.textShowValue ? parseInt(progress.value * 200/77) + progress.textValue
        onValueChanged: {
            if (speed.value >= 46.2 && speed.value < 61.6){
                speed.progressColor = "darkblue" // FDAB09
            }
            else if (speed.value >= 61.6){
                speed.progressColor = "darkred" //FF3737
            }
            else{
                speed.progressColor = "darkgreen" //06FDC0
            }
        }
        Behavior on value{
            PropertyAnimation{
                duration: 300
            }
        }

    }
    // rpm
    CircularBar{
        property var currentRpm: 0
        id: devir
        anchors.right: parent.right
        anchors.rightMargin: 100
        anchors.verticalCenter: parent.verticalCenter
        titleTextValue: "1000x"
        textValue: parseInt(value / 7.7)
        imageSource: "images/rpmmeter.png"
        value: currentRpm * 7.7
        onValueChanged: {
            if (devir.value <= 8 * 7.7){
                devir.progressColor = "green" // FDAB09
            }
            else{
                devir.progressColor = "red"
            }
        }
        Behavior on value{
            PropertyAnimation{
                duration: 300
            }
        }
    }
    Connections{
    target: canConnector
        function onSpeed(s){
            speed.currentSpeed = s;
        }
        function onRpm(r){
            devir.currentRpm = r;
        }
    }
    Item{
        id: signalContainer
        property bool leftChecked : true
        property bool rightChecked : true
        width: childrenRect.width
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        Image{
            id: leftsignal
            source: signalContainer.leftChecked ? "images/left_signal.svg" : "images/left_signal_checked.svg"
            width: 100
            height: 100
            anchors.right: rightsignal.left
            anchors.rightMargin: 200

            SequentialAnimation {
                       id: leftBlinkAnimation
                       loops: Animation.Infinite
                       running: !signalContainer.leftChecked
                       onStopped: leftsignal.opacity = 1
                       PropertyAnimation {
                           target: leftsignal
                           property: "opacity"
                           from: 1.0
                           to: 0.2
                           duration: 400
                       }
                       PropertyAnimation {
                           target: leftsignal
                           property: "opacity"
                           from: 0.2
                           to: 1.0
                           duration: 400

                       }
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    signalContainer.leftChecked = !signalContainer.leftChecked
                }
            }
        }


        Image{
            id: rightsignal
            source: signalContainer.rightChecked ? "images/right_signal.svg" : "images/right_signal_checked.svg"
            anchors.left: leftsignal.right
            anchors.leftMargin: 200
            width: 100
            height: 100
            SequentialAnimation {
                       id: rightBlinkAnimation
                       loops: Animation.Infinite
                       running: !signalContainer.rightChecked
                       onStopped: rightsignal.opacity = 1
                       PropertyAnimation {
                           target: rightsignal
                           property: "opacity"
                           from: 1.0
                           to: 0.2
                           duration: 400
                       }
                       PropertyAnimation {
                           target: rightsignal
                           property: "opacity"
                           from: 0.2
                           to: 1.0
                           duration: 400

                       }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    signalContainer.rightChecked = !signalContainer.rightChecked
                }
            }
        }
    }

    Item{
        property bool highChecked: false
        id:leftContainer
        width: childrenRect.width
        height: childrenRect.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 25
        Image{
            id: dimLight
            source: "images/kısa.svg"
            width:50
            height:50
        }
        Image{
            id: highLight
            source: leftContainer.highChecked ? "images/uzun_active.svg" : "images/uzun.svg"
            width:50
            height:50
            anchors.top: dimLight.bottom
            anchors.topMargin: 20
            MouseArea{
                anchors.fill: parent
                onClicked: leftContainer.highChecked = !leftContainer.highChecked
            }
        }
        Image{
            id: fogLight
            source: "images/sis.svg"
            width:50
            height:50
            anchors.top: highLight.bottom
            anchors.topMargin: 20
        }
    }




}
