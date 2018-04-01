/*
 * Copyright (c) 2017, 2018, David DeHaven, All Rights Reserved.
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

// We can only handle one request at a time
var puzzleReceivedCallback = null

 var baseServerURL = "https://sudoku-serve.herokuapp.com/sudoku/puzzles"
//var baseServerURL = "http://localhost:8080/sudoku/puzzles"

// readyState change handler, since it's common between the two requests we have here
function puzzleRequestHandler(request) {
    if (request.readyState === XMLHttpRequest.DONE) {
        console.log("Request status: " + request.status)
        if (request.status === 200) {
            console.log("Request response: " + request.responseText)
            var puzzleInfo = JSON.parse(request.responseText)
            if (puzzleInfo.puzzleId) {
                // Send it to the caller, even if it's still being generated
                // Because we have no timer facilities here and to avoid
                // callback hell
                puzzleReceivedCallback(puzzleInfo)
            } else {
                console.log("ERROR: Got response from puzzle request but invalid puzzle?? Abandoning request.")
            }
        } else {
            console.log("ERROR: " + request.statusText)
        }
    }
}

function requestPuzzle(size, seed, demo, callback) {
    var request = new XMLHttpRequest
    var reqURL = baseServerURL
    var reqType = "POST"

    // FIXME: throw error if callback is undefined
    puzzleReceivedCallback = callback

    if (demo) {
        // demo puzzles just use a GET /sudoku/puzzles/Demo-<size>
        reqURL += "/Demo-"+size
        reqType = "GET"
    } else {
        reqURL += "/new?size=" + size
        if (seed !== 0) {
            reqForm += "&randomSeed="+seed
        }
    }

    request.open(reqType, reqURL, true, null, null)
    request.setRequestHeader("Accept-Type", "application/json")
    if (reqType === "POST") {
        // Server needs this set, even though there is no body data allowed
        request.setRequestHeader("Content-Type", "application/json")
    }
    // we need the request to process...
    request.onreadystatechange = function() {
        puzzleRequestHandler(request)
    }
    console.log("Sending puzzle request...")
    request.send()
}

function getPuzzleWithId(puzzleId, callback) {
    // Use XHR to GET
    var request = new XMLHttpRequest
    var reqURL = baseServerURL + "/" + puzzleId

    puzzleReceivedCallback = callback

    request.open("GET", reqURL, true, null, null)
    request.setRequestHeader("Accept-Type", "application/json")
    request.onreadystatechange = function() {
        puzzleRequestHandler(request)
    }
    console.log("Sending puzzle request...")
    request.send()
}
