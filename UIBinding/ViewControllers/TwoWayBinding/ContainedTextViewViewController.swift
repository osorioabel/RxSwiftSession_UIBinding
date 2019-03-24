//
//  ContainedTextViewViewController.swift
//  UIBinding
//
//  Created by Abel Osorio on 3/24/19.
//  Copyright © 2019 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift

class ContainedTextViewViewController: UIViewController, HasTwoWayBindingViewModel {
    // MARK: - Outlets
    @IBOutlet weak var expandBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!

    // MARK: - Properties
    var viewModel: TwoWayBindingViewModel!
    let disposeBag = DisposeBag()

    // MARK: - View life cycle
    override func didMove(toParent parent: UIViewController?) {
        guard let controller = parent?.parent as? TwoWayBindingViewController else { return }

        expandBarButtonItem.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                controller.performSegue(withIdentifier: "PresentedTextViewViewController", sender: self?.expandBarButtonItem)
            }).disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    func bindViewModel() {
        textView.rx.text <-> viewModel.textViewText
    }
}
