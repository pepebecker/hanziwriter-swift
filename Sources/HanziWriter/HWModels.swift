//
//  HWModels.swift
//  HanziWriter
//
//  Created by Pepe Becker on 6/9/24.
//

import Foundation

public enum HWColorName: String, Codable {
  case strokeColor
  case radicalColor
  case outlineColor
  case highlightColor
  case drawingColor
}

public struct HWCharData: Codable {
  public let strokes: [String]
  public let medians: [[[Double]]]
}

public struct HWSize: Codable {
  public let width: Double
  public let height: Double
}

public struct HWTouch: Codable {
  public let id: Int
  public let x: Double
  public let y: Double
  public let radiusX: Double
  public let radiusY: Double
}

extension HWSize {
  public var cgSize: CGSize {
    get {
      CGSize(width: width, height: height)
    }
  }
}
