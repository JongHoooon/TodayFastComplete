//
//  SimpleMessageAlertPresentable.swift
//  TodayFastComplete
//
//  Created by JongHoon on 11/1/23.
//

import UIKit

import RxSwift

protocol SimpleMessageAlertPresentable {
    func presentSimpleAlert(
        navigationController: UINavigationController,
        title: String?,
        message: String?
    ) -> Observable<Void>
}

extension SimpleMessageAlertPresentable {
    func presentSimpleAlert(
        navigationController: UINavigationController,
        title: String? = nil,
        message: String?
    ) -> Observable<Void> {
        return Observable.create { observer in
            let alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            let confirmAction = UIAlertAction(
                title: Constants.Localization.CONFIRM,
                style: .default,
                handler: { _ in observer.onCompleted() }
            )
            alertController.addAction(confirmAction)
            UIImpactFeedbackGenerator(style: .rigid ).impactOccurred()
            navigationController.present(alertController, animated: true)
            return Disposables.create {
                alertController.dismiss(animated: true)
            }
        }
    }
}
