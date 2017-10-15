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
import "qrc:/sudoku/"

Item {
    id: container

    function refresh() {
        canvas.requestPaint();
    }

    // This will be overlayed on top of the game board
    Canvas {
        id: canvas
        width: parent.width
        height: parent.height
        antialiasing: false

        onPaint: {
            var ctx = getContext("2d");
            var gameSize = SudokuGame.size;
            var boxWidth = width / gameSize;
            var boxHeight = height / gameSize;

            ctx.save();

            // clear first
            ctx.clearRect(0, 0, width, height);
            ctx.lineWidth = 2.0;

            // number of dividers in each direction is size - 1
            for (var ii = 1; ii <= gameSize; ii++) {
                // horizontal divider
                ctx.beginPath();
                ctx.moveTo(0, boxHeight * ii);
                ctx.lineTo(width, boxHeight * ii);
                ctx.closePath();
                ctx.stroke();

                // vertical divider
                ctx.beginPath();
                ctx.moveTo(boxWidth * ii, 0);
                ctx.lineTo(boxWidth * ii, height);
                ctx.closePath();
                ctx.stroke();
            }
            ctx.restore();
        }
    }
}
