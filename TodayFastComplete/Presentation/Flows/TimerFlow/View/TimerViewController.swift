//
//  TimerViewController.swift
//  TodayFastComplete
//
//  Created by JongHoon on 9/30/23.
//

import UIKit

import SnapKit

final class TimerViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        super.configure()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = Constants.Localization.TIMER_TITLE
    }
    
    override func configureLayout() {
        
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct KoreanViewControllerPreview: PreviewProvider {
    static var previews: some View {
        TimerViewController()
            .showPreview()
            .environment(\.locale, .init(identifier: "ko"))
    }
}

struct EnglishViewControllerPreview: PreviewProvider {
    static var previews: some View {
        TimerViewController()
            .showPreview(.iPhoneSE2)
            .environment(\.locale, .init(identifier: "en"))
    }
}
#endif
