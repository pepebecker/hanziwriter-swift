//
//  HWErrors.swift
//  HanziWriter
//
//  Created by Pepe Becker on 6/10/24.
//

import Foundation

public enum HWCharDataLoaderError: Error {
  case failedToCreateUrl
  case failedToFetchAndParse
}

public enum HWJSMessageError: Error {
  case failedToParseMessageBody
}
