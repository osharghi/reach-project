//
//  Game.swift
//  Hangman
//
//  Created by Omid Sharghi on 4/8/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import Foundation

class Game
{
    var tryCount = 6
    var word: String?
    var displayWord: String?
    var lettersLeft: Int?
    var charDict: [Character: [Int]] = Dictionary()
    var guesses = Set<Character>()
    
    init(word: String)
    {
        self.word = word
        lettersLeft = word.count
        buildCharDict(word: word)
        buildDisplayWord(word: word)
    }
    
    func buildDisplayWord(word: String)
    {
        var displayWord = ""
        
        for _ in 0..<word.count
        {
            displayWord = displayWord + " " + "_"
        }
        
        self.displayWord = displayWord
    }
    
    func buildCharDict(word: String)
    {
        for (index, char) in word.enumerated()
        {
            if(charDict[char] != nil)
            {
                charDict[char]!.append(index)
            }
            else
            {
                var arr : [Int] = Array()
                arr.append(index)
                charDict[char] = arr
            }
        }
    }
    
    func guess(letter: Character) -> String
    {
        if(charDict[letter] != nil)
        {
            if(guesses.contains(letter))
            {
                //Letter already successfully guessed
                return "You have already guessed this letter"
            }
            else
            {
                guesses.insert(letter)
                let letterCount = charDict[letter]!.count
                lettersLeft = lettersLeft! - letterCount
                updateDisplayWord(letter: letter)
                return "Guess correct!"
            }
        }
        else
        {
            guesses.insert(letter)
            tryCount = tryCount - 1
            return "Incorrect guess!"
        }
    }
    
    func updateDisplayWord(letter: Character)
    {
        var indices = charDict[letter]!
        var buildWord = ""
        
        var  i = 0;
        let stop = indices.count
        
        for (index, char) in displayWord!.enumerated()
        {
            if(char == "_")
            {
                if(index == indices[i])
                {
                    buildWord = buildWord + String(letter)
                    i = i + 1
                    
                    if(i == stop)
                    {
                        break
                    }
                }
                else
                {
                    buildWord = buildWord + String("_")
                }
            }
            else
            {
                buildWord = buildWord + String(char)
            }
        }
        
        displayWord = buildWord
    }
    
}
