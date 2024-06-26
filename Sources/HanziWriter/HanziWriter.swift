//
//  HanziWriter.swift
//  HanziWriter
//
//  Created by Pepe Becker on 6/5/24.
//

import Foundation
import WebKit

public typealias HWCompletionHandler = () -> Void

public class HanziWriter: NSObject {
  
  public static var bundle: Bundle { Bundle.module }
  
  private let options: HWOptions
  private let webView: WKWebView
  private let onLoaded: (_ writer: HanziWriter) -> Void
  
  private var _finishedLoading = false
  private var _character: String?
  
  private var _showCharacterOnComplete: HWCompletionHandler? = nil
  private var _hideCharacterOnComplete: HWCompletionHandler? = nil
  private var _showOutlineOnComplete: HWCompletionHandler? = nil
  private var _hideOutlineOnComplete: HWCompletionHandler? = nil
  private var _updateColorOnComplete: HWCompletionHandler? = nil
  private var _animateCharacterOnComplete: HWCompletionHandler? = nil
  private var _animateStrokeOnComplete: HWCompletionHandler? = nil
  private var _highlightStrokeOnComplete: HWCompletionHandler? = nil
  
  private var _quizOnComplete: HWQuizOnComplete? = nil
  private var _quizOnCorrectStroke: HWQuizOnCorrectStroke? = nil
  private var _quizOnMistake: HWQuizOnMistake? = nil
  
  public var view: WKWebView {
    get { return webView }
  }
  
  public var isReady: Bool {
    get { return _finishedLoading }
  }
  
  public init(options: HWOptions, onLoaded: @escaping (_ writer: HanziWriter) -> Void) {
    let config = WKWebViewConfiguration()
    config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
    config.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
    
    webView = WKWebView()
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.isOpaque = false
    webView.backgroundColor = UIColor.clear
    webView.scrollView.backgroundColor = UIColor.clear
    webView.scrollView.isScrollEnabled = false
    webView.scrollView.zoomScale = 1
    webView.scrollView.maximumZoomScale = 1
    webView.scrollView.minimumZoomScale = 1
    
    let url = HanziWriter.bundle.url(forResource: "index", withExtension: "html", subdirectory: "Resources")
    if let url = url {
      webView.loadFileURL(url, allowingReadAccessTo: url)
      webView.load(URLRequest(url: url))
    }
    
    self.options = options
    self.onLoaded = onLoaded
    super.init()
    webView.navigationDelegate = self
    injectJavaScriptFunctionHandlers()
  }
  
  func injectJavaScriptFunctionHandlers() {
    webView.configuration.userContentController.add(self, name: "console.log")
    webView.configuration.userContentController.add(self, name: "console.warn")
    webView.configuration.userContentController.add(self, name: "console.error")
    
    webView.configuration.userContentController.add(self, name: "charDataLoader")
    webView.configuration.userContentController.add(self, name: "onLoadCharDataSuccess")
    webView.configuration.userContentController.add(self, name: "onLoadCharDataError")

    webView.configuration.userContentController.add(self, name: "event.resize")
    webView.configuration.userContentController.add(self, name: "event.touchstart")
    webView.configuration.userContentController.add(self, name: "event.touchmove")
    webView.configuration.userContentController.add(self, name: "event.touchend")
    webView.configuration.userContentController.add(self, name: "event.touchcancel")
    
    webView.configuration.userContentController.add(self, name: "showCharacter.onComplete")
    webView.configuration.userContentController.add(self, name: "hideCharacter.onComplete")
    webView.configuration.userContentController.add(self, name: "showOutline.onComplete")
    webView.configuration.userContentController.add(self, name: "hideOutline.onComplete")
    webView.configuration.userContentController.add(self, name: "updateColor.onComplete")
    webView.configuration.userContentController.add(self, name: "animateCharacter.onComplete")
    webView.configuration.userContentController.add(self, name: "animateStroke.onComplete")
    webView.configuration.userContentController.add(self, name: "highlightStroke.onComplete")
    
    webView.configuration.userContentController.add(self, name: "quiz.onComplete")
    webView.configuration.userContentController.add(self, name: "quiz.onCorrectStroke")
    webView.configuration.userContentController.add(self, name: "quiz.onMistake")
  }
  
  func initHanziWriter(completionHandler: ((Any?, (any Error)?) -> Void)? = nil) {
    guard let json = try? options.toJson() else { return }
    webView.evaluateJavaScript("initHanziWriter(\(json))", completionHandler: completionHandler)
  }
  
  func initWebView() -> WKWebView {
    let config = WKWebViewConfiguration()
    config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
    config.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
    
    let view = WKWebView(frame: .zero, configuration: config)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.scrollView.isScrollEnabled = false
    view.scrollView.zoomScale = 1
    view.scrollView.maximumZoomScale = 1
    view.scrollView.minimumZoomScale = 1
    
    let url = HanziWriter.bundle.url(forResource: "index", withExtension: "html", subdirectory: "Resources")
    if let url = url {
      view.loadFileURL(url, allowingReadAccessTo: url)
      view.load(URLRequest(url: url))
    }
    
    return view
  }
  
  public func showCharacter(duration: Double? = nil, onComplete: HWCompletionHandler? = nil) {
    _showCharacterOnComplete = onComplete
    webView.evaluateJavaScript("showCharacter(\(duration ?? 0))")
  }
  
  public func hideCharacter(duration: Double? = nil, onComplete: HWCompletionHandler? = nil) {
    _hideCharacterOnComplete = onComplete
    webView.evaluateJavaScript("hideCharacter(\(duration ?? 0))")
  }
  
  public func showOutline(duration: Double? = nil, onComplete: HWCompletionHandler? = nil) {
    _showOutlineOnComplete = onComplete
    webView.evaluateJavaScript("showOutline(\(duration ?? 0))")
  }
  
  public func hideOutline(duration: Double? = nil, onComplete: HWCompletionHandler? = nil) {
    _hideOutlineOnComplete = onComplete
    webView.evaluateJavaScript("hideOutline(\(duration ?? 0))")
  }
  
  public func updateDimensions(width: Double? = nil, height: Double? = nil, padding: Double? = nil) {
    let w = width?.description ?? "undefined"
    let h = height?.description ?? "undefined"
    let p = padding?.description ?? "undefined"
    webView.evaluateJavaScript("updateDimensions(\(w), \(h), \(p))")
  }
  
  public func updateColor(colorName: HWColorName, colorVal: String, duration: Double? = nil, onComplete: HWCompletionHandler? = nil) {
    _updateColorOnComplete = onComplete
    let d = duration?.description ?? "undefined"
    webView.evaluateJavaScript("updateColor('\(colorName)', '\(colorVal)', \(d))")
  }
  
  public func animateCharacter(onComplete: HWCompletionHandler? = nil) {
    _animateCharacterOnComplete = onComplete
    webView.evaluateJavaScript("animateCharacter()")
  }
  
  public func animateStroke(strokeNum: Int, onComplete: HWCompletionHandler? = nil) {
    _animateStrokeOnComplete = onComplete
    webView.evaluateJavaScript("animateStroke(\(strokeNum))")
  }
  
  public func highlightStroke(strokeNum: Int, onComplete: HWCompletionHandler? = nil) {
    _highlightStrokeOnComplete = onComplete
    webView.evaluateJavaScript("highlightStroke(\(strokeNum))")
  }
  
  public func loopCharacterAnimation() {
    webView.evaluateJavaScript("loopCharacterAnimation()")
  }
  
  public func pauseAnimation() {
    webView.evaluateJavaScript("pauseAnimation()")
  }
  
  public func resumeAnimation() {
    webView.evaluateJavaScript("resumeAnimation()")
  }
  
  public func setCharacter(_ character: String) {
    if !_finishedLoading { return }
    if _character == character { return }
    webView.evaluateJavaScript("setCharacter('\(character)')")
    _character = character
  }
  
  public func quiz(options: HWQuizOptions = HWQuizOptions()) {
    _quizOnComplete = options.onComplete
    _quizOnCorrectStroke = options.onCorrectStroke
    _quizOnMistake = options.onMistake
    guard let jsonString = try? options.toJson() else { return }
    webView.evaluateJavaScript("quiz(\(jsonString))")
  }
  
  public func quiz(showHintAfterMisses: Int? = nil,
                   markStrokeCorrectAfterMisses: Int? = nil,
                   quizStartStrokeNum: Int? = nil,
                   acceptBackwardsStrokes: Bool? = nil,
                   leniency: Double? = nil,
                   highlightOnComplete: Bool? = nil,
                   onComplete: HWQuizOnComplete? = nil,
                   onCorrectStroke: HWQuizOnCorrectStroke? = nil,
                   onMistake: HWQuizOnMistake? = nil) {
    quiz(options: HWQuizOptions(showHintAfterMisses: showHintAfterMisses,
                                markStrokeCorrectAfterMisses: markStrokeCorrectAfterMisses,
                                acceptBackwardsStrokes: acceptBackwardsStrokes,
                                leniency: leniency,
                                highlightOnComplete: highlightOnComplete,
                                onComplete: onComplete,
                                onCorrectStroke: onCorrectStroke,
                                onMistake: onMistake))
  }
  
  public func cancelQuiz() {
    webView.evaluateJavaScript("cancelQuiz()")
  }
  
  internal func charDataLoader(character: String, onComplete: @escaping HWCharDataLoaderCallback) {
    if let charDataLoader = options.charDataLoader {
      charDataLoader(character, onComplete)
    } else {
      HWDefaultCharDataLoader(character: character, onComplete: onComplete)
    }
  }
}

extension HanziWriter: WKNavigationDelegate {
  public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    if _finishedLoading { return }
    _finishedLoading = true
    initHanziWriter()
    onLoaded(self)
  }
}

extension HanziWriter: WKScriptMessageHandler {
  public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    // Console
    if message.name == "console.log" {
      print("ℹ️ \(message.body)")
      return
    }
    if message.name == "console.warn" {
      print("⚠️ \(message.body)")
      return
    }
    if message.name == "console.error" {
      print("❌ \(message.body)")
      return
    }

    var eventHandled = false
    
    // Loading character
    if message.name == "charDataLoader" {
      if let character = message.body as? String {
        charDataLoader(character: character) { result in
          switch result {
          case .success(let charData):
            if let charDataJson = try? toJsonString(charData) {
              self.webView.evaluateJavaScript("callCharDataLoaderCompletionHandler(\(charDataJson))")
            } else {
              print("❌ [msg:charDataLoader] failed to stringify charData: \(String(describing: charData))")
            }
          case .failure(let error):
            print("❌ [charDataLoader] \(error)")
          }
        }
      } else {
        print("❌ [msg:charDataLoader] invalid character: \(message.body)")
      }
      eventHandled = true
    }
    if message.name == "onLoadCharDataSuccess" {
      if let onLoadCharDataSuccess = options.onLoadCharDataSuccess {
        if let json = message.body as? String, let result = try? parseJson(from: json, to: HWCharData.self) {
          onLoadCharDataSuccess(result)
        } else {
          print("❌ [msg:onLoadCharDataSuccess] failed to parse result to HWCharData")
          print("❌ [msg:onLoadCharDataSuccess] result: \(message.body)")
        }
      } else {
        print("✅ [msg:onLoadCharDataSuccess] \(message.body)")
      }
      eventHandled = true
    }
    if message.name == "onLoadCharDataError" {
      if let onLoadCharDataError = options.onLoadCharDataError {
        onLoadCharDataError(message.body)
      } else {
        print("❌ [msg:onLoadCharDataError] \(message.body)")
      }
      eventHandled = true
    }

    // Resize Event
    if message.name == "event.resize", let resize = options.onResize {
      if let json = message.body as? String, let size = try? parseJson(from: json, to: HWSize.self) {
        resize(size)
      } else {
        print("❌ [msg:event(resize)] failed to parse size: \(message.body)")
      }
      eventHandled = true
    }

    // Touch Events
    if message.name == "event.touchstart", let touchStart = options.onTouchStart {
      if let json = message.body as? String, let touches = try? parseJson(from: json, to: [HWTouch].self) {
        touchStart(touches)
      } else {
        print("❌ [msg:event(touchstart)] failed to parse touches: \(message.body)")
      }
      eventHandled = true
    }
    if message.name == "event.touchmove", let touchMove = options.onTouchMove {
      if let json = message.body as? String, let touches = try? parseJson(from: json, to: [HWTouch].self) {
        touchMove(touches)
      } else {
        print("❌ [msg:event(touchmove)] failed to parse touches: \(message.body)")
      }
      eventHandled = true
    }
    if message.name == "event.touchend", let touchEnd = options.onTouchEnd {
      if let json = message.body as? String, let touches = try? parseJson(from: json, to: [HWTouch].self) {
        touchEnd(touches)
      } else {
        print("❌ [msg:event(touchend)] failed to parse touches: \(message.body)")
      }
      eventHandled = true
    }
    if message.name == "event.touchcancel", let touchCancel = options.onTouchCancel {
      if let json = message.body as? String, let touches = try? parseJson(from: json, to: [HWTouch].self) {
        touchCancel(touches)
      } else {
        print("❌ [msg:event(touchcancel)] failed to parse touches: \(message.body)")
      }
      eventHandled = true
    }
    
    // Writer
    if message.name == "showCharacter.onComplete", let onComplete = _showCharacterOnComplete {
      onComplete()
      eventHandled = true
    }
    if message.name == "hideCharacter.onComplete", let onComplete = _hideCharacterOnComplete {
      onComplete()
      eventHandled = true
    }
    if message.name == "showOutline.onComplete", let onComplete = _showOutlineOnComplete {
      onComplete()
      eventHandled = true
    }
    if message.name == "hideOutline.onComplete", let onComplete = _hideOutlineOnComplete {
      onComplete()
      eventHandled = true
    }
    if message.name == "updateColor.onComplete", let onComplete = _updateColorOnComplete {
      onComplete()
      eventHandled = true
    }
    if message.name == "animateCharacter.onComplete", let onComplete = _animateCharacterOnComplete {
      onComplete()
      eventHandled = true
    }
    if message.name == "animateStroke.onComplete", let onComplete = _animateStrokeOnComplete {
      onComplete()
      eventHandled = true
    }
    if message.name == "highlightStroke.onComplete", let onComplete = _highlightStrokeOnComplete {
      onComplete()
      eventHandled = true
    }
    
    // Quiz
    if message.name == "quiz.onComplete",  let onComplete = _quizOnComplete {
      if let json = message.body as? String, let result = try? HWQuizCompletionResult(json: json) {
        onComplete(.success(result))
      } else {
        onComplete(.failure(HWJSMessageError.failedToParseMessageBody))
      }
      eventHandled = true
    }
    if message.name == "quiz.onCorrectStroke",  let onComplete = _quizOnCorrectStroke {
      if let json = message.body as? String, let result = try? HWQuizResult(json: json) {
        onComplete(.success(result))
      } else {
        onComplete(.failure(HWJSMessageError.failedToParseMessageBody))
      }
      eventHandled = true
    }
    if message.name == "quiz.onMistake",  let onComplete = _quizOnMistake {
      if let json = message.body as? String, let result = try? HWQuizResult(json: json) {
        onComplete(.success(result))
      } else {
        onComplete(.failure(HWJSMessageError.failedToParseMessageBody))
      }
      eventHandled = true
    }

    if eventHandled {
      if options.logAllEvents ?? false || options.logHandledEvents ?? false {
        print("Handled HW Event: \(message.name)")
      }
      return
    }

    if options.logAllEvents ?? false || options.logUnhandledEvents ?? false {
      print("Unhandled HW Event: \(message.name)")
    }
  }
}
