//
//  HWQuizOptions.swift
//  HanziWriter
//
//  Created by Pepe Becker on 6/9/24.
//

import Foundation

public typealias HWQuizOnComplete = (Result<HWQuizCompletionResult, Error>) -> Void
public typealias HWQuizOnCorrectStroke = (Result<HWQuizResult, Error>) -> Void
public typealias HWQuizOnMistake = (Result<HWQuizResult, Error>) -> Void

internal struct HWCodableQuizOptions: Codable {
  public var showHintAfterMisses: Int? = nil
  public var markStrokeCorrectAfterMisses: Int? = nil
  public var quizStartStrokeNum: Int? = nil
  public var acceptBackwardsStrokes: Bool? = nil
  public var leniency: Double? = nil
  public var highlightOnComplete: Bool? = nil
}

public struct HWQuizOptions {
  internal var codableQuizOptions: HWCodableQuizOptions
  public var onComplete: HWQuizOnComplete? = nil
  public var onCorrectStroke: HWQuizOnCorrectStroke? = nil
  public var onMistake: HWQuizOnMistake? = nil
  
  public init(showHintAfterMisses: Int? = nil, markStrokeCorrectAfterMisses: Int? = nil, quizStartStrokeNum: Int? = nil, acceptBackwardsStrokes: Bool? = nil, leniency: Double? = nil, highlightOnComplete: Bool? = nil, onComplete: HWQuizOnComplete? = nil, onCorrectStroke: HWQuizOnCorrectStroke? = nil, onMistake: HWQuizOnMistake? = nil) {
    self.codableQuizOptions = HWCodableQuizOptions(
      showHintAfterMisses: showHintAfterMisses,
      markStrokeCorrectAfterMisses: markStrokeCorrectAfterMisses,
      quizStartStrokeNum: quizStartStrokeNum,
      acceptBackwardsStrokes: acceptBackwardsStrokes,
      leniency: leniency,
      highlightOnComplete: highlightOnComplete
    )
    self.onComplete = onComplete
    self.onCorrectStroke = onCorrectStroke
    self.onMistake = onMistake
  }
  
  func toJson() throws -> String {
    return try toJsonString(codableQuizOptions)
  }
  
  public var showHintAfterMisses: Int? {
    get { codableQuizOptions.showHintAfterMisses }
    set { codableQuizOptions.showHintAfterMisses = newValue }
  }

  public var markStrokeCorrectAfterMisses: Int? {
    get { codableQuizOptions.markStrokeCorrectAfterMisses }
    set { codableQuizOptions.markStrokeCorrectAfterMisses = newValue }
  }

  public var quizStartStrokeNum: Int? {
    get { codableQuizOptions.quizStartStrokeNum }
    set { codableQuizOptions.quizStartStrokeNum = newValue }
  }

  public var acceptBackwardsStrokes: Bool? {
    get { codableQuizOptions.acceptBackwardsStrokes }
    set { codableQuizOptions.acceptBackwardsStrokes = newValue }
  }

  public var leniency: Double? {
    get { codableQuizOptions.leniency }
    set { codableQuizOptions.leniency = newValue }
  }

  public var highlightOnComplete: Bool? {
    get { codableQuizOptions.highlightOnComplete }
    set { codableQuizOptions.highlightOnComplete = newValue }
  }
}

public struct HWQuizResult: Codable {
  public let character: String
  public let totalMistakes: Int
  public let strokeNum: Int
  public let mistakesOnStroke: Int
  public let strokesRemaining: Int
  public let isBackwards: Bool

  public init(json: String) throws {
    self = try parseJson(from: json, to: Self.self)
  }
}

public struct HWQuizCompletionResult: Codable {
  public let character: String
  public let totalMistakes: Int

  public init(json: String) throws {
    self = try parseJson(from: json, to: Self.self)
  }
}
