//
//  ShoppingItem.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/4/24.
//

import Foundation

struct ShoppingItem {
    var id: UUID
    var name: String
    var isDone: Bool
    var isFavorite: Bool
    
    init(name: String, isDone: Bool = false, isFavorite: Bool = false) {
        self.id = UUID()
        self.name = name
        self.isDone = isDone
        self.isFavorite = isFavorite
    }
}
