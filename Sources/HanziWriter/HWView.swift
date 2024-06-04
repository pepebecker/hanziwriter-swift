//
//  HanziWriterView.swift
//  HanziWriter
//
//  Created by Pepe Becker on 6/5/24.
//

import SwiftUI

public struct HWView: UIViewRepresentable {
  
  var options: HWOptions? = nil
  var onMount: ((HanziWriter) -> Void)? = nil
  @Binding var characterBinding: String?
  
  public init(options: HWOptions? = nil, character: Binding<String?>, onMount: ((HanziWriter) -> Void)? = nil) {
    self.options = options
    self._characterBinding = character
    self.onMount = onMount
  }
  
  public init(options: HWOptions? = nil, character: String? = nil, onMount: ((HanziWriter) -> Void)? = nil) {
    self.init(options: options, character: Binding(get: { character }, set: { _ in }), onMount: onMount)
  }
  
  public class Coordinator: NSObject {
    var parent: HWView
    var writer: HanziWriter
    init(_ parent: HWView) {
      self.parent = parent
      self.writer = HanziWriter(options: parent.options ?? HWOptions()) { writer in
        if let character = parent.characterBinding {
          writer.setCharacter(character)
        }
        if let onMount = parent.onMount {
          onMount(writer)
        }
      }
    }
  }
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  public func makeUIView(context: Context) -> UIView {
    return context.coordinator.writer.view
  }
  
  public func updateUIView(_ uiView: UIView, context: Context) {
    if let character = context.coordinator.parent.characterBinding {
      context.coordinator.writer.setCharacter(character)
    }
  }
  
}
