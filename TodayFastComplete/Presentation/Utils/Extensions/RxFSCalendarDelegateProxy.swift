//
//  RxFSCalendarDelegateProxy.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/17/23.
//

import FSCalendar
import RxCocoa
import RxSwift

extension FSCalendar: HasDelegate {
    public typealias Delegate = FSCalendarDelegate
}

class RxFSCalendarDelegateProxy: DelegateProxy<FSCalendar, FSCalendarDelegate>,
                                 DelegateProxyType, 
                                 FSCalendarDelegate {
    
    weak private(set) var fsCelendar: FSCalendar?
    
    init(fsCelendar: FSCalendar) {
        self.fsCelendar = fsCelendar
        super.init(
            parentObject: fsCelendar,
            delegateProxy: RxFSCalendarDelegateProxy.self
        )
    }
    
    static func registerKnownImplementations() {
        register { RxFSCalendarDelegateProxy(fsCelendar: $0) }
    }
}

extension Reactive where Base: FSCalendar {
    var delegate: DelegateProxy<FSCalendar, FSCalendarDelegate> {
        return RxFSCalendarDelegateProxy.proxy(for: base)
    }
    
    var boundingRectWillChange: Observable<CGRect> {
        return delegate.methodInvoked(#selector(FSCalendarDelegate.calendar(_:boundingRectWillChange:animated:)))
            .map { parameters in
                return parameters[1] as! CGRect
            }
    }
    
    var willDisplay: Observable<(cell: FSCalendarCell, date: Date)> {
        return delegate.methodInvoked(#selector(FSCalendarDelegate.calendar(_:willDisplay:for:at:)))
            .map { parameters in
                let cell = parameters[1] as! FSCalendarCell
                let date = parameters[2] as! Date
                return (cell, date)
            }
    }
    
    var didSelect: Observable<Date> {
        return delegate.methodInvoked(#selector(FSCalendarDelegate.calendar(_:didSelect:at:)))
            .map { parameters in
                return parameters[1] as! Date
            }
    }
}
