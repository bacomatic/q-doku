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
