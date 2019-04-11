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
    var charDict: [String: [Int]] = Dictionary()
    var guessSet = Set<String>()
    var guessArr: [String] = Array()
    
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
            displayWord = displayWord + "_"
        }
        
        self.displayWord = displayWord
    }
    
    func buildCharDict(word: String)
    {
        for (index, char) in word.enumerated()
        {
            if(charDict[String(char)] != nil)
            {
                charDict[String(char)]!.append(index)
            }
            else
            {
                var arr : [Int] = Array()
                arr.append(index)
                charDict[String(char)] = arr
            }
        }
    }
    
    func guess(guess: String) -> String
    {
        let guess_low = guess.lowercased()

        if(guess_low.count == 1)
        {
            if(charDict[guess_low] != nil)
            {
                if(guessSet.contains(guess_low))
                {
                    //Letter already successfully guessed
                    return "You have already guessed this."
                }
                else
                {
                    guessSet.insert(guess_low)
                    guessArr.append(guess_low)
                    let letterCount = charDict[guess_low]!.count
                    lettersLeft = lettersLeft! - letterCount
                    print(lettersLeft!)
                    updateDisplayWord(letter: guess_low)
                    return "Guess correct!"
                }
            }
            else
            {
                if(guessSet.contains(guess_low))
                {
                    return "You have already guessed this."
                }
                else
                {
                    guessSet.insert(guess_low)
                    guessArr.append(guess_low)
                    tryCount = tryCount - 1
                    return "Incorrect guess!"
                }
            }
        }
        else
        {
            if(guess_low == word)
            {
                guessSet.insert(guess_low)
                guessArr.append(guess_low)
                displayWord = word
                lettersLeft = 0
                return "You win!"
            }
            else
            {
                guessSet.insert(guess_low)
                guessArr.append(guess_low)
                tryCount = tryCount - 1
                return "Incorrect guess!"
            }
        }
    }
    
    func updateDisplayWord(letter: String)
    {
        var indices = charDict[letter]!
        var buildWord = ""
        
        var  i = 0;
        
        for (index, char) in displayWord!.enumerated()
        {
            if(char == "_")
            {
                if(i<indices.count && index == indices[i])
                {
                    buildWord = buildWord + String(letter)
                    i = i + 1
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
