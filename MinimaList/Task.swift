//
//  Task.swift
//  MinimaList
//
//  Created by Philipp Eibl on 5/23/17.
//  Copyright © 2017 Philipp Eibl. All rights reserved.
//

import Foundation

class Task {
    dynamic var title: String
    dynamic var isDone: Bool
    
    init(title: String) {
        self.title = title
        self.isDone = false
    }
}
