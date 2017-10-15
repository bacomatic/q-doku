/*
 * Copyright (c) 2017, David DeHaven, All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

import QtQuick 2.7
import QtQuick.Controls 2.1

MainMenuForm {
    id: root

    signal startNewGame();
    signal resumeGame();
    signal selectNewSize(int size);
    signal setRandomSeed(int seed);

    sizeSelect.onCurrentIndexChanged: {
        var size = 3;
        switch (sizeSelect.currentIndex) {
        case 0: // 2x2
            size = 2;
            break;
        case 2: // Random
            size = 0;
            break;
        default:
            break; // default to 3
        }
        selectNewSize(size);
    }

    Component.onCompleted: {
        startButton.onClicked.connect(startNewGame);
        resumeButton.onClicked.connect(resumeGame);
    }

    // NOTE: Ugly workaround for https://bugreports.qt.io/browse/QTBUG-59908
    Connections {
        target: randomSeed
        onEditingFinished: {
            // The validator on the TextField guarantees we only have numbers
            setRandomSeed(randomSeed.text.parseInt());
        }
    }
}
