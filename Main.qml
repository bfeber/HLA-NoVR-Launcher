import QtMultimedia
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Window

Window {
    id: window
    visible: true
    color: "#000000"
    maximumHeight: 408
    minimumHeight: 408
    maximumWidth: 976
    minimumWidth: 976
    title: qsTr("Half-Life: Alyx NoVR Launcher")

    onClosing: (close) => {
        if (!updateButton.enabled) {
            close.accepted = false;
            errorLabel.text = "Installation in progress!\nPlease wait.";
            error.open();
        }
    }

    Connections {
        target: launcher
        function onUpdateModInstalling() {
            updateButton.text = "Installing...";
        }
        function onUpdateModFinished() {
            updateButton.text = "Update/Install NoVR";
            updateButton.enabled = true;
            playButton.enabled = true;
            quitButton.enabled = true;
            error.close();
        }
    }

    FolderDialog {
        id: folderDialog
        currentFolder: "file:///C:/Program Files (x86)/Steam/steamapps/common/Half-Life Alyx"
        onAccepted: {
            launcher.updateMod(folderDialog.selectedFolder)
            if (launcher.validInstallation) {
                updateButton.enabled = false;
                updateButton.text = "Downloading...";
                playButton.enabled = false;
                quitButton.enabled = false;
            } else {
                errorLabel.text = "Half-Life: Alyx installation not found!\nPlease try again.";
                error.open();
            }
        }
    }

    Popup {
        id: error
        anchors.centerIn: parent
        height: 100
        width: 600
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        Label {
            id: errorLabel
            anchors.fill: parent
            font.pointSize: 24
        }
    }

    Video {
        id: video
        anchors.fill: parent
        source: "file:///" + applicationDirPath + "/background.webm"
        fillMode: VideoOutput.PreserveAspectCrop
        loops: MediaPlayer.Infinite
        Component.onCompleted: play()
    }

    Column {
        id: column
        width: 228
        height: 400
        anchors.left: parent.left
        anchors.top: parent.top
        spacing: 2
        anchors.leftMargin: 34
        anchors.topMargin: 188

        Button {
            id: playButton
            width: 217
            height: 34
            text: "Play NoVR"
            enabled: launcher.validInstallation
            onClicked: {
                launcher.playGame()
                Qt.quit()
            }
        }

        Button {
            id: updateButton
            width: 217
            height: 34
            text: "Update/Install NoVR"
            onClicked: folderDialog.open()
        }

        Button {
            id: optionsButton
            width: 217
            height: 34
            text: "Options"
            enabled: false
        }

        Button {
            id: quitButton
            width: 217
            height: 34
            text: "Quit"
            onClicked: Qt.quit()
        }
    }

    Label {
        id: label
        y: 463
        width: 262
        height: 15
        color: "#ffffff"
        text: "NoVR by GB_2 Development Team"
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        font.bold: true
        anchors.bottomMargin: 2
        anchors.leftMargin: 2
        font.family: "Tahoma"
    }
}
