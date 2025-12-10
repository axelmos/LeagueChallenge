//
//  PostItem.swift
//  LeagueiOSChallenge
//
//  Created by Axel Mosiejko on 08/12/2025.
//

import Foundation

// This lightweight DTO is a combination of Post and User models.
// PostsListViewModel maps and merges the models into this single UI-ready structure

struct PostItem {
    let id: Int
    let title: String
    let body: String
    let userId: Int
    let user: User?
}
