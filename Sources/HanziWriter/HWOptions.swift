//
//  HWOptions.swift
//  HanziWriter
//
//  Created by Pepe Becker on 6/9/24.
//

import Foundation

public typealias HWCharDataLoaderCallback = (Result<HWCharData, Error>) -> Void
public typealias HWCharDataLoader = (_ character: String, @escaping HWCharDataLoaderCallback) -> Void
public typealias HWLoadCharDataSuccess = (HWCharData) -> Void
public typealias HWLoadCharDataError = (Any) -> Void

public typealias HWOnResize = (_ size: HWSize) -> Void
public typealias HWOnTouch = (_ touches: [HWTouch]) -> Void

internal struct HWCodableOptions: Codable {
  var showOutline: Bool? = nil
  var showCharacter: Bool? = nil
  var width: Double? = nil
  var height: Double? = nil
  var padding: Double? = nil
  var strokeAnimationSpeed: Double? = nil
  var strokeHighlightSpeed: Double? = nil
  var strokeFadeDuration: Double? = nil
  var delayBetweenStrokes: Double? = nil
  var delayBetweenLoops: Double? = nil
  var strokeColor: String? = nil
  var radicalColor: String? = nil
  var highlightColor: String? = nil
  var outlineColor: String? = nil
  var drawingColor: String? = nil
  var drawingWidth: Double? = nil
  var showHintAfterMisses: Int? = nil
  var markStrokeCorrectAfterMisses: Int? = nil
  var quizStartStrokeNum: Int? = nil
  var acceptBackwardsStrokes: Bool? = nil
  var highlightOnComplete: Bool? = nil
  var highlightCompleteColor: String? = nil
  var autoResize: Bool? = nil
}

public struct HWOptions {
  internal var codableOptions: HWCodableOptions
  public var logAllEvents: Bool? = nil
  public var logHandledEvents: Bool? = nil
  public var logUnhandledEvents: Bool? = nil
  public var charDataLoader: HWCharDataLoader? = nil
  public var onLoadCharDataSuccess: HWLoadCharDataSuccess? = nil
  public var onLoadCharDataError: HWLoadCharDataError? = nil
  public var onResize: HWOnResize? = nil
  public var onTouchStart: HWOnTouch? = nil
  public var onTouchMove: HWOnTouch? = nil
  public var onTouchEnd: HWOnTouch? = nil
  public var onTouchCancel: HWOnTouch? = nil
  
  public init(characterDataLoader: HWCharDataLoader? = nil) {
    self.codableOptions = HWCodableOptions()
    self.charDataLoader = characterDataLoader
  }

  public init(showOutline: Bool? = nil, showCharacter: Bool? = nil, width: Double? = nil, height: Double? = nil, padding: Double? = nil, strokeAnimationSpeed: Double? = nil, strokeHighlightSpeed: Double? = nil, strokeFadeDuration: Double? = nil, delayBetweenStrokes: Double? = nil, delayBetweenLoops: Double? = nil, strokeColor: String? = nil, radicalColor: String? = nil, highlightColor: String? = nil, outlineColor: String? = nil, drawingColor: String? = nil, drawingWidth: Double? = nil, showHintAfterMisses: Int? = nil, markStrokeCorrectAfterMisses: Int? = nil, quizStartStrokeNum: Int? = nil, acceptBackwardsStrokes: Bool? = nil, highlightOnComplete: Bool? = nil, highlightCompleteColor: String? = nil, autoResize: Bool? = nil, logAllEvents: Bool? = nil, logHandledEvents: Bool? = nil, logUnhandledEvents: Bool? = nil, charDataLoader: HWCharDataLoader? = nil, onLoadCharDataSuccess: HWLoadCharDataSuccess? = nil, onLoadCharDataError: HWLoadCharDataError? = nil, onResize: HWOnResize? = nil, onTouchStart: HWOnTouch? = nil, onTouchMove: HWOnTouch? = nil, onTouchEnd: HWOnTouch? = nil, onTouchCancel: HWOnTouch? = nil) {
    self.codableOptions = HWCodableOptions(
      showOutline: showOutline,
      width: width,
      height: height,
      padding: padding,
      strokeAnimationSpeed: strokeAnimationSpeed,
      strokeHighlightSpeed: strokeHighlightSpeed,
      strokeFadeDuration: strokeFadeDuration,
      delayBetweenStrokes: delayBetweenStrokes,
      delayBetweenLoops: delayBetweenLoops,
      strokeColor: strokeColor,
      radicalColor: radicalColor,
      highlightColor: highlightColor,
      outlineColor: outlineColor,
      drawingColor: drawingColor,
      drawingWidth: drawingWidth,
      showHintAfterMisses: showHintAfterMisses,
      markStrokeCorrectAfterMisses: markStrokeCorrectAfterMisses,
      quizStartStrokeNum: quizStartStrokeNum,
      acceptBackwardsStrokes: acceptBackwardsStrokes,
      highlightOnComplete: highlightOnComplete,
      highlightCompleteColor: highlightCompleteColor,
      autoResize: autoResize
    )
    self.logAllEvents = logAllEvents
    self.logHandledEvents = logHandledEvents
    self.logUnhandledEvents = logUnhandledEvents
    self.charDataLoader = charDataLoader
    self.onLoadCharDataSuccess = onLoadCharDataSuccess
    self.onLoadCharDataError = onLoadCharDataError
    self.onResize = onResize
    self.onTouchStart = onTouchStart
    self.onTouchMove = onTouchMove
    self.onTouchEnd = onTouchEnd
    self.onTouchCancel = onTouchCancel
  }
  
  func toJson() throws -> String {
    return try toJsonString(codableOptions)
  }

  public var showOutline: Bool? {
    get { codableOptions.showOutline }
    set { codableOptions.showOutline = newValue }
  }
  
  public var showCharacter: Bool? {
    get { codableOptions.showCharacter }
    set { codableOptions.showCharacter = newValue }
  }
  
  public var width: Double? {
    get { codableOptions.width }
    set { codableOptions.width = newValue }
  }
  
  public var height: Double? {
    get { codableOptions.height }
    set { codableOptions.height = newValue }
  }
  
  public var padding: Double? {
    get { codableOptions.padding }
    set { codableOptions.padding = newValue }
  }
  
  public var strokeAnimationSpeed: Double? {
    get { codableOptions.strokeAnimationSpeed }
    set { codableOptions.strokeAnimationSpeed = newValue }
  }
  
  public var strokeHighlightSpeed: Double? {
    get { codableOptions.strokeHighlightSpeed }
    set { codableOptions.strokeHighlightSpeed = newValue }
  }
  
  public var strokeFadeDuration: Double? {
    get { codableOptions.strokeFadeDuration }
    set { codableOptions.strokeFadeDuration = newValue }
  }
  
  public var delayBetweenStrokes: Double? {
    get { codableOptions.delayBetweenStrokes }
    set { codableOptions.delayBetweenStrokes = newValue }
  }
  
  public var delayBetweenLoops: Double? {
    get { codableOptions.delayBetweenLoops }
    set { codableOptions.delayBetweenLoops = newValue }
  }
  
  public var strokeColor: String? {
    get { codableOptions.strokeColor }
    set { codableOptions.strokeColor = newValue }
  }
  
  public var radicalColor: String? {
    get { codableOptions.radicalColor }
    set { codableOptions.radicalColor = newValue }
  }
  
  public var highlightColor: String? {
    get { codableOptions.highlightColor }
    set { codableOptions.highlightColor = newValue }
  }
  
  public var outlineColor: String? {
    get { codableOptions.outlineColor }
    set { codableOptions.outlineColor = newValue }
  }
  
  public var drawingColor: String? {
    get { codableOptions.drawingColor }
    set { codableOptions.drawingColor = newValue }
  }
  
  public var drawingWidth: Double? {
    get { codableOptions.drawingWidth }
    set { codableOptions.drawingWidth = newValue }
  }
  
  public var showHintAfterMisses: Int? {
    get { codableOptions.showHintAfterMisses }
    set { codableOptions.showHintAfterMisses = newValue }
  }
  
  public var markStrokeCorrectAfterMisses: Int? {
    get { codableOptions.markStrokeCorrectAfterMisses }
    set { codableOptions.markStrokeCorrectAfterMisses = newValue }
  }
  
  public var quizStartStrokeNum: Int? {
    get { codableOptions.quizStartStrokeNum }
    set { codableOptions.quizStartStrokeNum = newValue }
  }
  
  public var acceptBackwardsStrokes: Bool? {
    get { codableOptions.acceptBackwardsStrokes }
    set { codableOptions.acceptBackwardsStrokes = newValue }
  }
  
  public var highlightOnComplete: Bool? {
    get { codableOptions.highlightOnComplete }
    set { codableOptions.highlightOnComplete = newValue }
  }
  
  public var highlightCompleteColor: String? {
    get { codableOptions.highlightCompleteColor }
    set { codableOptions.highlightCompleteColor = newValue }
  }
  
  public var autoResize: Bool? {
    get { codableOptions.autoResize }
    set { codableOptions.autoResize = newValue }
  }
}
