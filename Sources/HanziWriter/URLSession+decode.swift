//
//  URLSession+decode.swift
//  HanziWriter
//
//  Created by Pepe Becker on 6/9/24.
//

import Foundation

extension URLSession {
  internal func decode<T: Decodable>(
    _ type: T.Type = T.self,
    from url: URL,
    keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
    dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .deferredToData,
    dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate
  ) async throws  -> T {
    let (data, _) = try await data(from: url)
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = keyDecodingStrategy
    decoder.dataDecodingStrategy = dataDecodingStrategy
    decoder.dateDecodingStrategy = dateDecodingStrategy
    
    let decoded = try decoder.decode(T.self, from: data)
    return decoded
  }
}
