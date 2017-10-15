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

.pragma library

var demoBoard = {
    size: 3,
    boardId: "ba7998da-f51d-490e-b461-341e3ce21ec1",
    randomSeed: 0,
    board: [
        7,8,2, 5,4,6, 9,1,3,
        6,4,3, 9,1,8, 7,5,2,
        1,5,9, 3,7,2, 6,4,8,

        9,7,4, 6,2,1, 8,3,5,
        5,1,6, 4,8,3, 2,7,9,
        3,2,8, 7,9,5, 4,6,1,

        8,6,7, 1,3,9, 5,2,4,
        4,9,1, 2,5,7, 3,8,6,
        2,3,5, 8,6,4, 1,9,7
    ],
    puzzle: [
        0,0,0, 0,0,1, 1,1,0,
        0,0,0, 1,0,0, 0,0,1,
        0,1,0, 0,0,0, 1,0,0,

        0,0,1, 0,1,0, 0,0,1,
        0,0,1, 0,0,1, 0,0,0,
        0,0,1, 0,1,0, 1,0,0,

        1,0,1, 0,1,0, 1,0,0,
        1,0,1, 0,0,1, 0,1,0,
        0,1,0, 1,0,0, 0,1,1
    ],
};

var smallDemoBoard = {
    size: 2,
    boardId: "200e5b5c-f758-460d-a77b-a60b02355ebb",
    randomSeed: 0,
    board: [
        1,3, 2,4,
        4,2, 1,3,
        3,1, 4,2,
        2,4, 3,1
    ],
    puzzle: [
        1,0, 0,1,
        0,1, 1,0,

        1,0, 0,1,
        1,0, 1,0
    ]
}

function getBoard(size, seed) {
    // TODO: Request board/puzzle from server
    if (size === 2) {
        return smallDemoBoard;
    }
    return demoBoard;
}
