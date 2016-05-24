/*
 * QML Material - An application framework implementing Material Design.
 * Copyright (C) 2015 Ricardo Vieira <ricardo.vieira@tecnico.ulisboa.pt>
 *               2015 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.4
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1
import Material 0.2
/*!
   \qmltype TextField
   \inqmlmodule Material

   \brief A single-line text input control.
 */
TextFieldStyle {
    id: style

    padding {
        left: 0
        right: 0
        top: 0
        bottom: 0
    }

    font {
        family: echoMode == TextInput.Password ? "Default" : "Roboto"
        pixelSize:16*dp
    }

    renderType: Text.QtRendering
    placeholderTextColor: "transparent"
    selectedTextColor: "white"
    selectionColor: control.hasOwnProperty("color") ? control.color : Theme.accentColor
    textColor: Theme.light.textColor

    background : Item {
        id: background
        Component.onCompleted:{
            implicitHeight=  height+ (floatingLabel ? fieldPlaceholder.font.pixelSize : 0) + (helperTextLabel.visible ? helpertextRow.height : 0)
            console.log(".......this is the fieldPlaceholder.font.pixelSize : " + fieldPlaceholder.font.pixelSize)
            console.log(".......helpertextRow.height : " + helperTextLabel.height)
            console.log("...........height : " + background.height)

        }

        property color color: control.hasOwnProperty("color") ? control.color : Theme.accentColor
        property color errorColor: control.hasOwnProperty("errorColor")
                                   ? control.errorColor : Palette.colors["red"]["500"]
        property string helperText: control.hasOwnProperty("helperText") ? control.helperText : ""
        property bool floatingLabel: control.hasOwnProperty("floatingLabel") ? control.floatingLabel : ""
        property bool hasError: control.hasOwnProperty("hasError")
                                ? control.hasError : characterLimit && control.length > characterLimit
        property int characterLimit: control.hasOwnProperty("characterLimit") ? control.characterLimit : 0
        property bool showBorder: control.hasOwnProperty("showBorder") ? control.showBorder : true

        Rectangle {
            id: underline
            color: background.hasError ? background.errorColor
                                       : control.activeFocus ? background.color
                                                             : Theme.light.hintColor

            height: control.activeFocus ?dp*2 :dp*1
            visible: true // background.showBorder

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                bottomMargin: floatingLabel ? helperTextLabel.height :0
            }

            Behavior on height {
                NumberAnimation { duration: 200 }
            }

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        Label {
            id: fieldPlaceholder

            anchors.verticalCenter: parent.verticalCenter
            text: control.placeholderText
            font.pixelSize:16*dp
            anchors.margins: -dp(1)
            color: background.hasError ? background.errorColor
                                       : control.activeFocus && control.text !== ""
                                         ? background.color : Theme.light.hintColor

            states: [
                State {
                    name: "floating"
                    when: control.displayText.length > 0 && background.floatingLabel
                    AnchorChanges {
                        target: fieldPlaceholder
                        anchors.verticalCenter: undefined
                        anchors.top: parent.top
                    }
                    PropertyChanges {
                        target: fieldPlaceholder
                        font.pixelSize:12*dp
                    }
                },
                State {
                    name: "hidden"
                    when: control.displayText.length > 0 && !background.floatingLabel
                    PropertyChanges {
                        target: fieldPlaceholder
                        visible: false
                    }
                }
            ]

            transitions: [
                Transition {
                    id: floatingTransition
                    enabled: false
                    AnchorAnimation {
                        duration: 200
                    }
                    NumberAnimation {
                        duration: 200
                        property: "font.pixelSize"
                    }
                }
            ]

            Component.onCompleted: floatingTransition.enabled = true
        }

        RowLayout {
            id: helpertextRow
            anchors {
                left: parent.left
                right: parent.right
                top: underline.top
                topMargin:dp*4
            }

            Label {
                id: helperTextLabel
                visible: background.helperText && background.showBorder
                text: background.helperText
                font.pixelSize:12*dp
                color: background.hasError ? background.errorColor
                                           : Qt.darker(Theme.light.hintColor)

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }

                property string helperText: control.hasOwnProperty("helperText")
                                            ? control.helperText : ""
            }

            Label {
                id: charLimitLabel
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                visible: background.characterLimit && background.showBorder
                text: control.length + " / " + background.characterLimit
                font.pixelSize:12*dp
                color: background.hasError ? background.errorColor : Theme.light.hintColor
                horizontalAlignment: Text.AlignLeft

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
            }
        }

    }
}
