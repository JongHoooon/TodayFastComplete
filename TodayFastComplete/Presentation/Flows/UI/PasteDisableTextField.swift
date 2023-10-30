//
//  PasteDisableTextField.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/30/23.
//

import UIKit

final class PasteDisableTextField: UITextField {
    
    private var _isPasteBlocked: Bool = false
    
    var isPasteBlocked: Bool {
        get {
            self._isPasteBlocked
        }
        set {
            self._isPasteBlocked = newValue
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) { return false }
        return super.canPerformAction(action, withSender: sender)    }
}
