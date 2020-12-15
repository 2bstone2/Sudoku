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
    var ogPuzzleStr: String = "070000043040009610800634900094052000358460020000800530080070091902100005007040802"
    var ogPuzzle = [[Int?]](repeating: [Int?](repeating: 0, count: 9), count: 9)
    var solutionStr: String = "679518243543729618821634957794352186358461729216897534485276391962183475137945862"
    var solution = [[Int?]](repeating: [Int?](repeating: 0, count: 9), count: 9)
    
    
    func populateArrays() {
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
                    
                    print("\(solution[i][j]!)   ", terminator: "")
                }
            }
            print("\n")
        }
    }
    
    
    
}
