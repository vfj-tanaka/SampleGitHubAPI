//
//  Model.swift
//  SampleGitHubAPI
//
//  Created by mtanaka on 2022/07/11.
//

import Foundation

struct GitHubResponse: Codable {
    let items: [Model]?
}

struct Model: Codable {
    let id: Int
    let name: String
    private let fullName: String
    var urlStr: String { "https://github.com/\(fullName)" }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
    }
}
