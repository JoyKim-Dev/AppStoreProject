//
//  iTunesModel.swift
//  AppStoreProject
//
//  Created by Joy Kim on 8/8/24.
//

import Foundation

struct Application: Decodable {
    let resultCount: Int
    let results: [Results]
}

struct Results: Decodable {
    
    let artworkUrl512: String?
    let screenshotUrls: [String]?
    let averageUserRating: Double?
    let trackCensoredName: String?
    let artistID: Int?
    let sellerName: String?
    let version: String?
    let userRatingCount: Int?
    let formattedPrice: String?
    let description: String?
    let releaseNotes: String?
    let primaryGenreName: String?
}
