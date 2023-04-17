//
//  SwiftUIView.swift
//
//
//  Created by morse on 16/1/2023.
//

import KeyboardKit
import SwiftUI

@available(iOS 14, *)
struct HamsterAutocompleteToolbar: View {
  weak var ivc: HamsterKeyboardViewController?

  @EnvironmentObject
  private var keyboardContext: KeyboardContext

  @EnvironmentObject
  private var appSettings: HamsterAppSettings

  @EnvironmentObject
  private var rimeEngine: RimeEngine

  var style: AutocompleteToolbarStyle

  init(ivc: HamsterKeyboardViewController?) {
    weak var keyboardViewController = ivc
    self.ivc = keyboardViewController
    self.style = AutocompleteToolbarStyle(
      item: AutocompleteToolbarItemStyle(
        titleFont: .system(
          size: CGFloat(ivc?.appSettings.rimeCandidateTitleFontSize ?? 20)
        ),
        titleColor: .primary,
        subtitleFont: .system(
          size: CGFloat(ivc?.appSettings.rimeCandidateTitleFontSize ?? 12)
        ),
        subtitleColor: .primary
      )
    )
  }

  var hamsterColor: ColorSchema {
    rimeEngine.currentColorSchema
  }

  var body: some View {
    GeometryReader { proxy in
      VStack(alignment: .leading, spacing: 0) {
        // 拼写区域
        HStack {
          Text(rimeEngine.userInputKey)
            .font(style.item.subtitleFont)
            .foregroundColor(hamsterColor.hilitedTextColor)
            .padding(2)
            .minimumScaleFactor(0.5)
          Spacer()
        }
        .padding(.leading, 5)
        .frame(height: 10)

        // 候选区
        CandidateHStackView(style: style, hamsterColor: hamsterColor, suggestions: $rimeEngine.suggestions) { [weak ivc] item in
          guard let ivc = ivc else { return }
          ivc.selectCandidateIndex(index: item.index)
        }
        .frame(height: proxy.size.height - 10)
        .frame(minWidth: 0, maxWidth: .infinity)
        
        // TODO: 使用 ScrollView + LazyHStack 存在误触问题
//        ScrollView(.horizontal, showsIndicators: false) {
//          LazyHStack(spacing: 0, pinnedViews: .sectionFooters) {
//            ForEach(rimeEngine.suggestions) { item in
//              Button { [weak ivc] in
//                guard let ivc = ivc else { return }
//                // TODO: 点击候选项处理
//                ivc.selectCandidateIndex(index: item.index)
//              } label: {
//                HStack(spacing: 0) {
//                  Text(item.text)
//                    .font(style.item.titleFont)
//                    .foregroundColor(
//                      item.isAutocomplete
//                        ? hamsterColor.hilitedCandidateTextColor
//                        : hamsterColor.candidateTextColor
//                    )
//                  if let comment = item.comment {
//                    Text(comment)
//                      .font(style.item.subtitleFont)
//                      .foregroundColor(
//                        item.isAutocomplete
//                          ? hamsterColor.hilitedCommentTextColor
//                          : hamsterColor.commentTextColor
//                      )
//                  }
//                }
//                .padding(.all, 5)
//                .background(item.isAutocomplete ? hamsterColor.hilitedCandidateBackColor : Color.clearInteractable)
//                .cornerRadius(style.autocompleteBackground.cornerRadius)
//                .contentShape(Rectangle())
//              }
//              .buttonStyle(.plain)
//            }
//          }
//        }
//        .frame(height: proxy.size.height - 10)
//        .frame(minWidth: 0, maxWidth: .infinity)
//        .padding(.leading, 2)
      }
    }
    .frame(minWidth: 0, maxWidth: .infinity)
    .background(hamsterColor.backColor)
  }
}

struct AutocompleteToolbar_Previews: PreviewProvider {
  static var previews: some View {
    VStack {}
//    HamsterAutocompleteToolbar()
//      .preferredColorScheme(.dark)
//      .environmentObject(KeyboardContext.preview)
//      .environmentObject(RimeEngine.shared)
//      .environmentObject(AutocompleteContext())
//      .environmentObject(ActionCalloutContext.preview)
//      .environmentObject(InputCalloutContext.preview)
  }
}
