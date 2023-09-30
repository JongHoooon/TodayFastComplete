//
//  UIViewController+Preview.swift
//  TodayFastComplete
//
//  Created by JongHoon on 9/30/23.
//

enum DeviceType {
    case iPhoneSE2
    case iPhone11Pro
    case iPhone15Pro
    case iPhone15ProMax
    
    func name() -> String {
        switch self {
        case .iPhoneSE2:        return "iPhone SE2"
        case .iPhone11Pro:      return "iPhone 11 Pro"
        case .iPhone15Pro:      return "iPhone 15 Pro"
        case .iPhone15ProMax:   return "iPhone 12 Pro Max"
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

/**
 #if canImport(SwiftUI) && DEBUG
 import SwiftUI

 struct EnglishViewControllerPreview: PreviewProvider {
     static var previews: some View {
         ViewController()
             .showPreview()
             .environment(\.locale, Locale(identifier: "en"))
     }
 }

 struct KoreanViewControllerPreview: PreviewProvider {
     static var previews: some View {
         ViewController()
             .showPreview()
             .environment(\.locale, Locale(identifier: "ko"))
     }
 }
 #endif
 */

extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    }
    
    func showPreview(_ deviceType: DeviceType = .iPhone15Pro) -> some View {
        Preview(viewController: self).previewDevice(PreviewDevice(rawValue: deviceType.name()))
    }
}
#endif
