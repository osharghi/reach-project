//
//  History.swift
//  Hangman
//
//  Created by Omid Sharghi on 4/8/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import Foundation

class History: NSObject, NSCoding
{
    var date: String
    var status: String
    
    init(date: String, status: String)
    {
        self.date = date
        self.status = status
    }
    required init(coder decoder: NSCoder) {
        self.date = decoder.decodeObject(forKey: "Date") as? String ?? ""
        self.status = decoder.decodeObject(forKey: "GameStatus") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(date, forKey: "Date")
        coder.encode(status, forKey: "GameStatus")
    }
}

enum GameStatus
{
    case win
    case loss
    case quit
}
