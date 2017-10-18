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

var puzzleReceivedCallback = null;

// FIXME: Just roll this into SudokuGame? There isn't as much to it as I thought there would be.

function postNewBoardRequest(size, seed) {
    var request = new XMLHttpRequest;
    // FIXME: change this when the puzzle API is done
    var reqURL = "https://sudoku-serve.herokuapp.com/sudoku/puzzles/demo?size="+size;
    if (seed != 0) {
        reqURL += "&randomSeed="+seed;
    }

    request.open("GET", reqURL, true, null, null);
    request.setRequestHeader("Accept-Type", "application/json");
    request.onreadystatechange = function() {
        if (request.readyState === XMLHttpRequest.DONE) {
            if (request.status === 200) {
                console.log("Request response: " + request.responseText);
                var puzzleInfo = JSON.parse(request.responseText);
                if (puzzleInfo.puzzle && (puzzleInfo.puzzle.length > 0)) {
                    console.log("Full puzzle received, starting game!");
                    puzzleReceivedCallback(puzzleInfo);
                } else if (puzzleInfo.puzzleId) {
                    // got a puzzleId, wait for it to be generated
                    console.log("Puzzle being generated. Id = " + puzzleInfo.puzzleId);
                    // periodically poll until it's done.
                    // TODO: server doesn't support this yet, so leave this blank for now
                } else {
                    console.log("ERROR: Got response from puzzle request but invalid puzzle?? Abandoning request.");
                }
            } else {
                console.log("Error: " + request.statusText);
            }
        }
    }
    console.log("Sending puzzle request...");
    request.send();
}

/*
 * Request a Sudoku puzzle from the server.
 */
function getPuzzle(size, seed, callback) {
    // Request puzzle from server
    puzzleReceivedCallback = callback;
    postNewBoardRequest(size, seed);
}
