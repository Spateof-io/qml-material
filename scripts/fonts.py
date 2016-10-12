#! /usr/bin/env python2
import sys
import os.path
import urllib

def load_yaml(fileName):
    from yaml import load
    try:
        from yaml import CLoader as Loader
    except ImportError:
        from yaml import Loader
    stream = open(fileName, "r")
    return load(stream, Loader=Loader)


def DefineQrcFile(names, out_dirname):
    resources = {}
    for icon in names:
        """download_icon(icon, out_dirname)"""
        group, name = icon.split('/')
        if group in resources:
            resources[group].append(name)
        else:
            resources[group] = [name]

    text = '<!DOCTYPE RCC>\n<RCC version="1.0">\n\n'

    for group, names in resources.items():
        text += """<qresource prefix="/icons/Fonts">
        <file>MaterialFontLoader.qml</file>
        <file>qmldir</file>\n"""
        for name in names:
            text += '\t<file>{group}/{name}.ttf</file>\n'.format(group=group, name=name)
        text += '</qresource>\n\n'

    text += '</RCC>\n'

    return text

def DefineQmlFile(names, out_dirname):
    resources = {}
    for icon in names:
        group, name = icon.split('/')
        if group in resources:
            resources[group].append(name)
        else:
            resources[group] = [name]
    text = """/*
 * QML Material - An application framework implementing Material Design.
 *
 * Copyright (C) 2016 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */


import QtQuick 2.0"""
    for group, names in resources.items():
        text += 'Item {\n'
        for name in names:
            text += '\tFontLoader {source: Qt.resolvedUrl('+'{group}/{name}'.format(group=group, name=name)+ '.ttf)}\n'
    text += '}\n'

    return text


if __name__ == '__main__':
    if len(sys.argv) > 1:
        filename = sys.argv[1]
    else:
        filename = 'fonts.yml'

    config = load_yaml(filename)
    icons = config.get('fonts', [])
    qrc_out = config.get('out', 'fonts')
    qml_out = qrc_out
    if qrc_out.endswith('.qrc'):
        out_dirname = os.path.dirname(qrc_out)
    else:
        out_dirname = qrc_out
        qrc_out = os.path.join(out_dirname, 'icons.qrc')
        qml_out = os.path.join(out_dirname, 'MaterialFontLoader.qml')

    if not os.path.exists(out_dirname):
        os.makedirs(out_dirname)

    qrc = DefineQrcFile(icons, out_dirname)
    qml = DefineQmlFile(icons, out_dirname)

    with open(qrc_out, 'w') as f:
        f.write(qrc)
    with open(qml_out, 'w') as f:
        f.write(qml)
