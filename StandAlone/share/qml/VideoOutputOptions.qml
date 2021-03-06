/* Webcamoid, webcam capture application.
 * Copyright (C) 2020  Gonzalo Exequiel Pedone
 *
 * Webcamoid is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Webcamoid is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Webcamoid. If not, see <http://www.gnu.org/licenses/>.
 *
 * Web-Site: http://webcamoid.github.io/
 */

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Ak 1.0

ScrollView {
    id: view

    property string videoOutput: ""
    readonly property string videoOtputDescription:
        videoLayer.description(videoOutput)

    signal openVideoOutputAddEditDialog(string videoOutput)
    signal videoOutputRemoved()

    function updateControls()
    {
        deviceInfo.text =
                "<b>" + videoLayer.description(videoOutput) + "</b>"
                + "<br/><i>" + videoOutput + "</i>"
        videoLayer.removeInterface("itmVideoOutputOptions")
        videoLayer.embedControls("itmVideoOutputOptions", videoOutput)
    }

    ColumnLayout {
        width: view.width
        spacing: AkUnit.create(16 * AkTheme.controlScale, "dp").pixels

        Label {
            id: deviceInfo
            elide: Label.ElideRight
            Layout.fillWidth: true
            Layout.leftMargin:
                AkUnit.create(16 * AkTheme.controlScale, "dp").pixels
            Layout.rightMargin:
                AkUnit.create(16 * AkTheme.controlScale, "dp").pixels
            Layout.bottomMargin:
                AkUnit.create(16 * AkTheme.controlScale, "dp").pixels
        }
        Button {
            text: qsTr("Edit")
            icon.source: "image://icons/edit"
            flat: true
            Layout.leftMargin:
                AkUnit.create(16 * AkTheme.controlScale, "dp").pixels
            Layout.rightMargin:
                AkUnit.create(16 * AkTheme.controlScale, "dp").pixels

            onClicked: view.openVideoOutputAddEditDialog(view.videoOutput)
        }
        Button {
            text: qsTr("Remove")
            icon.source: "image://icons/no"
            flat: true
            Layout.leftMargin:
                AkUnit.create(16 * AkTheme.controlScale, "dp").pixels
            Layout.rightMargin:
                AkUnit.create(16 * AkTheme.controlScale, "dp").pixels

            onClicked: {
                videoLayer.removeInterface("itmVideoOutputOptions")
                videoLayer.removeOutput(view.videoOutput)
                view.videoOutputRemoved()
            }
        }
        ColumnLayout {
            id: itmVideoOutputOptions
            objectName: "itmVideoOutputOptions"
            width: view.width
            Layout.leftMargin:
                AkUnit.create(16 * AkTheme.controlScale, "dp").pixels
            Layout.rightMargin:
                AkUnit.create(16 * AkTheme.controlScale, "dp").pixels
        }
    }

    onVideoOutputChanged: view.updateControls()
}
