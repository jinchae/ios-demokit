//
//  ProductLoader.swift
//  DemoKit
//
//  Created by 정진채 on 8/17/25.
//
import Foundation

enum JSONLoadError: Error {
    case fileNotFound(String)
    case readFailed(URL)
}

struct ProductLoader {

    static func loadFromBundle(
        fileName: String = "products",
        fileExtension: String = "json",
        bundle: Bundle = .main
    ) throws -> [Product] {
        guard let url = bundle.url(forResource: fileName, withExtension: fileExtension) else {
            throw JSONLoadError.fileNotFound("\(fileName).\(fileExtension)")
        }
        let data = try Data(contentsOf: url)
        return try decode(data)
    }

    static func loadFromURL(_ url: URL) async throws -> [Product] {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decode(data)
    }

    private static func decode(_ data: Data) throws -> [Product] {
        let decoder = JSONDecoder()
        // 키가 이미 camelCase라 별도 설정 불필요. 필요 시: decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([Product].self, from: data)
    }
}
