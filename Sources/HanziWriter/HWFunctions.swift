//
//  HWFunctions.swift
//  HanziWriter
//
//  Created by Pepe Becker on 6/10/24.
//

import Foundation

public func HWCharacterDataUrl(character: String) -> URL? {
  URL(string: "https://cdn.jsdelivr.net/npm/hanzi-writer-data@2.0/\(character).json")
}

public func HWDefaultCharDataLoader(character: String, onComplete: @escaping HWCharDataLoaderCallback) {
  guard let url = HWCharacterDataUrl(character: character) else {
    onComplete(.failure(HWCharDataLoaderError.failedToCreateUrl))
    return
  }
  Task {
    do {
      let charData = try await URLSession.shared.decode(HWCharData.self, from: url)
      DispatchQueue.main.async {
        onComplete(.success(charData))
      }
    } catch {
      onComplete(.failure(HWCharDataLoaderError.failedToFetchAndParse))
    }
  }
}

internal func parseJson<T: Decodable>(from jsonString: String, to type: T.Type) throws -> T {
    let data = Data(jsonString.utf8)
    let decoder = JSONDecoder()
    do {
        let decodedObject = try decoder.decode(T.self, from: data)
        return decodedObject
    } catch {
        throw error
    }
}

internal func toJsonString<T: Encodable>(_ object: T) throws -> String {
    let encoder = JSONEncoder()
    do {
        let data = try encoder.encode(object)
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw EncodingError.invalidValue(object, EncodingError.Context(codingPath: [], debugDescription: "Unable to convert data to string"))
        }
        return jsonString
    } catch {
        throw error
    }
}
