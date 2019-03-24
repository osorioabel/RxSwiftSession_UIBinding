//
//  TwoWayBindingViewModel.swift
//  UIBinding
//
//  Created by Abel Osorio on 3/24/19.
//  Copyright © 2019 Abel Osorio. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

infix operator <->

@discardableResult func <-><T>(property: ControlProperty<T>, variable: BehaviorRelay<T>) -> Disposable {
    let variableToProperty = variable.asObservable()
        .bind(to: property)

    let propertyToVariable = property
        .subscribe(
            onNext: { variable.accept($0) },
            onCompleted: { variableToProperty.dispose() }
    )

    return Disposables.create(variableToProperty, propertyToVariable)
}

class TwoWayBindingViewModel {
    var textFieldText: BehaviorRelay<String?> = BehaviorRelay<String?>(value: "Hello")
    var textViewText: BehaviorRelay<String?> = BehaviorRelay<String?>(value: "Lorem ipsum dolor...")

}

protocol HasTwoWayBindingViewModel: AnyObject {
    var viewModel: TwoWayBindingViewModel! { get set }
}
