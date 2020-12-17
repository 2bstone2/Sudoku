//
//  SudokuModel.swift
//  Sudoku
//
//  Created by Bailey Stone on 12/8/20.
//  Copyright © 2020 Bailey Stone. All rights reserved.
//

// sudoku puzzle creds: https://www.kaggle.com/rohanrao/sudoku

import Foundation

class Sudoku {
    // TODO: - make array of strings, randomize an idx then choose that puzzle
    var ogPuzzleStrArr: [String] = ["070000043040009610800634900094052000358460020000800530080070091902100005007040802", "008317000004205109000040070327160904901450000045700800030001060872604000416070080", "301086504046521070500000001400800002080347900009050038004090200008734090007208103", "048301560360008090910670003020000935509010200670020010004002107090100008150834029", "040890630000136820800740519000467052450020700267010000520003400010280970004050063",
        "561092730020780090900005046600000427010070003073000819035900670700103080000000050",
        "310450900072986143906010508639178020150090806004003700005731009701829350000645010"]
    var ogPuzzle = [[Int?]](repeating: [Int?](repeating: 0, count: 9), count: 9) // initial array
    var solutionStrArr: [String] = ["679518243543729618821634957794352186358461729216897534485276391962183475137945862", "298317645764285139153946278327168954981453726645792813539821467872634591416579382", "371986524846521379592473861463819752285347916719652438634195287128734695957268143", "748391562365248791912675483421786935589413276673529814834962157296157348157834629", "142895637975136824836742519398467152451328796267519348529673481613284975784951263", "561492738324786195987315246659831427418279563273564819135928674746153982892647351",
    "318457962572986143946312578639178425157294836284563791425731689761829354893645217"]
    var solution = [[Int?]](repeating: [Int?](repeating: 0, count: 9), count: 9) // solution array
    var gamePuzzle = [[Int?]](repeating: [Int?](repeating: 0, count: 9), count: 9)
    var selectedChoiceTile: Int?
    
    
    func populateArrays() {
        let randNum = arc4random_uniform(UInt32(ogPuzzleStrArr.count))
        
        let randNumInt: Int = Int(randNum)
        
        let ogPuzzleStr = ogPuzzleStrArr[randNumInt]
        let solutionStr = solutionStrArr[randNumInt]
        
        if ogPuzzleStr.count != solutionStr.count {
            print ("ERROR WITH BOARD LOAD")
            return
        }
        
        let tempPuzzleArr = Array(ogPuzzleStr)
        let tempSolutionArr = Array(solutionStr)
        
        var puzzleIdx = 0
        
        for i in 0..<9 {
            for j in 0..<9 {
                if let puzzleVal = Int(String(tempPuzzleArr[puzzleIdx])), let solutionVal = Int(String(tempSolutionArr[puzzleIdx])) {
                    ogPuzzle[i][j] = puzzleVal
                    solution[i][j] = solutionVal
                    puzzleIdx+=1
                    
                    print("\(ogPuzzle[i][j]!)   ", terminator: "")
                }
            }
            print("\n")
        }
        gamePuzzle = ogPuzzle
        print("gamePuzzle: ")
        print(gamePuzzle)
    }
    
    
    
}
