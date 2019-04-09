//
//  History.swift
//  Hangman
//
//  Created by Omid Sharghi on 4/8/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import Foundation

class History
{
    var date: Date?
    var status: String?
    
    init(date: Date, status: String)
    {
        self.date = date
        self.status = status
    }
}
