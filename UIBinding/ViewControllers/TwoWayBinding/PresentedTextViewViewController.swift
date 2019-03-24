//
//  PresentedTextViewViewController.swift
//  UIBinding
//
//  Created by Abel Osorio on 3/24/19.
//  Copyright © 2019 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift

class PresentedTextViewViewController: UIViewController, HasTwoWayBindingViewModel {
    // MARK: - Outlets
    @IBOutlet weak var textView: UITextView!

    // MARK: - Properties
    var viewModel: TwoWayBindingViewModel!
    let disposeBag = DisposeBag()

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.becomeFirstResponder()
        bindViewModel()
    }

    func bindViewModel() {
        (textView.rx.text <-> viewModel.textViewText).disposed(by: disposeBag)
    }
}
