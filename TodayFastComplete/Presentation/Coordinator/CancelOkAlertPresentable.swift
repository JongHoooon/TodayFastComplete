//
//  CancelOkAlertPresentable.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/15/23.
//

import UIKit

import RxSwift

protocol CancelOkAlertPresentable {
    func presentCancelOkAlert(navigationController: UINavigationController, title: String?, message: String, okTitle: String, okStyle: UIAlertAction.Style, cancelTitle: String) -> Observable<AlertActionType>
}

enum AlertActionType {
    case ok
    case cancel
}

extension CancelOkAlertPresentable {
    func presentCancelOkAlert(
        navigationController: UINavigationController,
        title: String? = nil,
        message: String,
        okTitle: String = Constants.Localization.CONFIRM,
        okStyle: UIAlertAction.Style = .destructive,
        cancelTitle: String = Constants.Localization.CANCEL
    ) -> Observable<AlertActionType> {
        
        return Observable.create { observer in
            let alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            alertController.view.tintColor = .systemGray
            
            let okAction = UIAlertAction(title: okTitle, style: okStyle) { _ in
                observer.onNext(.ok)
                observer.onCompleted()
            }
            let cancelAction = UIAlertAction(
                title: cancelTitle,
                style: .cancel,
                handler: { _ in
                    observer.onNext(.cancel)
                    observer.onCompleted()
            })
            
            [
                cancelAction,
                okAction
            ].forEach { alertController.addAction($0) }
            
            navigationController.present(alertController, animated: true, completion: nil)
            
            return Disposables.create {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
}
