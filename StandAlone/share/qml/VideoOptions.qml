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

ColumnLayout {
    id: videoOptions

    signal openVideoOutputAddEditDialog(string videoOutput)
    signal openVideoInputOptions(string videoInput)
    signal openVideoOutputOptions(string videoOutput)

    TabBar {
        id: tabBar
        Layout.fillWidth: true

        TabButton {
            text: qsTr("Sources")
        }
        TabButton {
            text: qsTr("Outputs")
        }
    }
    StackLayout {
        id: stack
        Layout.fillWidth: true
        Layout.fillHeight: true
        currentIndex: tabBar.currentIndex
        clip: true

        VideoInputs {
            onOpenVideoInputOptions:
                videoOptions.openVideoInputOptions(videoInput)
        }
        VideoOutputs {
            onOpenVideoOutputAddEditDialog:
                videoOptions.openVideoOutputAddEditDialog(videoOutput)
            onOpenVideoOutputOptions:
                videoOptions.openVideoOutputOptions(videoOutput)
        }
    }
}
