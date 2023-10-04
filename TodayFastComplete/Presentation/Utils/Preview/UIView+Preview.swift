//
//  UIView+Preview.swift
//  TodayFastComplete
//
//  Created by JongHoon on 9/30/23.
//

#if canImport(SwiftUI) && DEBUG
import SwiftUI

/**
 #if DEBUG
 import SwiftUI

 struct KoreanPreview: PreviewProvider {
     static var previews: some View {
         return MyView()
             .showPreview()
             .environment(\.locale, Locale(identifier: "ko"))
     }
 }

 struct EnglishPreview: PreviewProvider {
     static var previews: some View {
         return MyView()
             .showPreview()
             .environment(\.locale, Locale(identifier: "en"))
     }
 }
 #endif
 */

extension UIView {
    private struct Preview: UIViewRepresentable {
        typealias UIViewType = UIView
        
        let view: UIView
        
        func makeUIView(context: Context) -> UIView {
            return view
        }
        func updateUIView(_ uiView: UIView, context: Context) { }
    }
    
    func showPreview() -> some View {
        Preview(view: self)
    }
}
#endif
