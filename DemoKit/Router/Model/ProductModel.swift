//
//  ProductModel.swift
//
//  Created by 정진채 on 8/17/25.
//

import Foundation

struct Product: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let brand: String
    let price: Int
    let discountPrice: Int
    let discountRate: Int
    let image: String
    let link: String
    let tags: [String]
    let benefits: [String]
    let rating: Double
    let reviewCount: Int

    var imageURL: URL? { URL(string: image) }
    var linkURL: URL? { URL(string: link) }
    var discountAmount: Int { max(0, price - discountPrice) }
}


