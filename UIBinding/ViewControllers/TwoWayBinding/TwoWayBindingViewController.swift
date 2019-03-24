//
//  TwoWayBindingViewController.swift
//  UIBinding
//
//  Created by Abel Osorio on 3/24/19.
//  Copyright © 2019 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TwoWayBindingViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var resetBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var leftTextField: UITextField!
    @IBOutlet weak var rightTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var containerView: UIView!

    // MARK: - Properties
    let viewModel = TwoWayBindingViewModel()
    let disposeBag = DisposeBag()

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bindViewModel()

        tapGestureRecognizer.rx.event.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
        }).disposed(by: disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = (segue.destination as? UINavigationController)?.topViewController as? HasTwoWayBindingViewModel else { return }
        controller.viewModel = viewModel
    }

    // MARK: - Actions
    @IBAction func unwindToTwoWayBindingViewController(_ segue: UIStoryboardSegue) { }

    // MARK: - Helpers
    func configure() {
        button.layer.cornerRadius = 5.0
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 5.0
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0).cgColor
    }

    func bindViewModel() {
        leftTextField.rx.text <-> viewModel.textFieldText
        rightTextField.rx.text <-> viewModel.textFieldText

        button.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.viewModel.textFieldText.accept("\(Date())")
        }).disposed(by: disposeBag)

        resetBarButtonItem.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.textFieldText.accept( "Hello")
                self?.viewModel.textViewText.accept("Lorem ipsum dolor...")
        }).disposed(by: disposeBag)
    }

}
