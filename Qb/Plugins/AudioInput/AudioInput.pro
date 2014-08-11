# Webcamoid, webcam capture application.
# Copyright (C) 2011-2013  Gonzalo Exequiel Pedone
#
# Webcamod is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Webcamod is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Webcamod. If not, see <http://www.gnu.org/licenses/>.
#
# Email     : hipersayan DOT x AT gmail DOT com
# Web-Site 1: http://github.com/hipersayanX/Webcamoid
# Web-Site 2: http://kde-apps.org/content/show.php/Webcamoid?content=144796

exists(commons.pri) {
    include(commons.pri)
} else {
    exists(../../commons.pri) {
        include(../../commons.pri)
    } else {
        error("commons.pri file not found.")
    }
}

CONFIG += plugin

!isEmpty(USEQTMOBILITY):isEqual(USEQTMOBILITY, 1): lessThan(QT_MAJOR_VERSION, 5) {
    CONFIG += mobility
    MOBILITY += multimedia
}

DEFINES += __STDC_CONSTANT_MACROS

HEADERS += \
    include/audioinput.h \
    include/audioinputelement.h \
    include/audiobuffer.h

INCLUDEPATH += \
    include \
    ../../include

!win32: LIBS += -L../../ -lQb
win32: LIBS += -L../../ -lQb$${VER_MAJ}

!isEmpty(FFMPEGINCLUDES) {
    INCLUDEPATH += $${FFMPEGINCLUDES}
}

!isEmpty(FFMPEGLIBS) {
    LIBS += \
        $${FFMPEGLIBS} \
        -lavdevice$${FFMPEGSUFFIX} \
        -lavfilter$${FFMPEGSUFFIX} \
        -lavformat$${FFMPEGSUFFIX} \
        -lavcodec$${FFMPEGSUFFIX} \
        -lavresample$${FFMPEGSUFFIX} \
        -lpostproc$${FFMPEGSUFFIX} \
        -lswresample$${FFMPEGSUFFIX} \
        -lswscale$${FFMPEGSUFFIX} \
        -lavutil$${FFMPEGSUFFIX}
}

OTHER_FILES += pspec.json

QT += core gui
isEmpty(USEQTMOBILITY): QT += multimedia
!isEmpty(USEQTMOBILITY): isEqual(USEQTMOBILITY, 0) | greaterThan(QT_MAJOR_VERSION, 4): QT += multimedia

SOURCES += \
    src/audioinput.cpp \
    src/audioinputelement.cpp \
    src/audiobuffer.cpp

DESTDIR = $${PWD}

TEMPLATE = lib

unix {
    isEmpty(FFMPEGLIBS) {
        CONFIG += link_pkgconfig

        PKGCONFIG += \
            libavdevice \
            libavfilter \
            libavformat \
            libavcodec \
            libavresample \
            libpostproc \
            libswresample \
            libswscale \
            libavutil
    }
}

INSTALLS += target

target.path = $${LIBDIR}/$${COMMONS_TARGET}
