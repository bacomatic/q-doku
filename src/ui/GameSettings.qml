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

import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import "qrc:/sudoku"

Item {
    property var db : null

    // Convenience accessors
    property int boardSize: 3
    // flag to indicate that board settings have changed
    property bool gameDirty: false

    property int randomSeed: 0

    property bool showCellErrors: true
    property bool highlightLikeNumbers: true
    property bool requestDemoBoards: false

    function setBoardSize(size) {
        if (boardSize !== size) {
            // don't dirty if we're setting to random size
            // or changing from random to the current size
            gameDirty = (size === 0) ? false : size !== SudokuGame.size
            boardSize = size
        }
    }

    // returns an object containing "width" and "height" fields
    // FIXME: I probably won't use these, I need to implement resizeability first
    function getWindowSize() {
        var size = getNamedSetting("WindowSize")
        // validate stored settings
        if (size && size.width && size.height) {
            return size
        }
        // return null so we can use default setting
        return null
    }

    // size must be an object containing "width" and "height"
    // other fields ignored
    function setWindowSize(size) {
        if (size && size.width && size.height) {
            // extract only the fields we care about
            var obj = {
                width: size.width,
                height: size.height
            }
            setNamedSetting("WindowSize", obj)
        }
    }

    // Named setting accessors (things like window position/size, etc.)
    function getNamedSetting(name, defaultValue) {
        if (defaultValue === undefined) {
            defaultValue = null
        }

        var result = null
        initDB()
        if (!db || !name || name.length === 0) {
            return // FIXME: error handling
        }

        db.transaction(
            function(tx) {
                var res = tx.executeSql('SELECT * FROM settings WHERE name=?', [name])
                if (res.rows.length >= 1) {
                    var entry = res.rows[0]
                    // !entry.value obliterates "false" and zero values
                    if (entry.value === null || entry.value === undefined) {
                        // Corrupt entry? Delete the bad row
                        tx.executeSql('DELETE FROM settings WHERE name=?', [name])
                    } else {
                        result = JSON.parse(entry.value)
                    }
                } else {
                    result = defaultValue
                }
            }
        )
        return result
    }

    function setNamedSetting(name, value) {
        // value can be null, in which case the setting will be deleted
        initDB()
        if (!db || !name || name.length === 0) {
            return // FIXME: Error handling
        }

        db.transaction(
            function(tx) {
                // !value corrupts "false" and zero values
                if (value !== null && value !== undefined) {
                    var json = JSON.stringify(value)
                    var res = tx.executeSql('SELECT * FROM settings WHERE name=?', [name])
                    if (res.rows.length === 1) {
                        tx.executeSql('UPDATE settings SET value=? WHERE name=?', [json,name])
                    } else {
                        tx.executeSql('INSERT INTO settings VALUES (?,?)', [name,json])
                    }
                } else {
                    tx.executeSql('DELETE FROM settings WHERE name=?', [name])
                }
            }
        )
    }

    function initDB() {
        if (!db) {
            db = LocalStorage.openDatabaseSync("Q-Doku", "1.0", "Q-Doku game settings", 100000)
            db.transaction(
                function(tx) {
                    // one table for storing named settings, each entry will contain JSON data
                    tx.executeSql('CREATE TABLE IF NOT EXISTS settings(name TEXT, value TEXT)')
                }
            )
        }
    }

    function loadSettings() {
        boardSize = getNamedSetting("BoardSize", boardSize)
        randomSeed = getNamedSetting("RandomSeed", randomSeed)
        showCellErrors = getNamedSetting("ShowCellErrors", showCellErrors)
        highlightLikeNumbers = getNamedSetting("HighlightLikeNumbers", highlightLikeNumbers)
        requestDemoBoards = getNamedSetting("RequestDemoBoards", requestDemoBoards)
    }

    function saveSettings() {
        setNamedSetting("BoardSize", boardSize)
        setNamedSetting("RandomSeed", randomSeed)
        setNamedSetting("ShowCellErrors", showCellErrors)
        setNamedSetting("HighlightLikeNumbers", highlightLikeNumbers)
        setNamedSetting("RequestDemoBoards", requestDemoBoards)
    }

    Component.onCompleted: {
        // inialize the database and load settings
        initDB()
        loadSettings()
    }

    Component.onDestruction: {
        // Save settings before we exit
        saveSettings()
    }
}
