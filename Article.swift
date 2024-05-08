//
//  Article.swift
//  PersonalData2
//
//  Created by bogdan on 07.05.2024.
//

import Foundation

struct Article: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
    let url: URL
}
