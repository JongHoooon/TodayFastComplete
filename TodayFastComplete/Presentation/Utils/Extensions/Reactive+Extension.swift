//
//  Reactive+Extension.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/4/23.
//

import UIKit

import RxCocoa
import RxSwift

// MARK: - UIViewController
extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = Observable.just(Void())
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewDidDisappear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewDidDismissed: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear))
            .filter { [weak base] _ in base?.navigationController?.isBeingDismissed == true }
            .map { _ in Void() }
         return ControlEvent(events: source)
    }
}

extension ObservableType {
    func withPrevious(startWith first: Element) -> Observable<(Element, Element)> {
        return scan((first, first)) { ($0.1, $1) }.skip(1)
    }
}
