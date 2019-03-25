//
//  BasicControlsViewController.swift
//  UIBinding
//
//  Created by Abel Osorio on 3/24/19.
//  Copyright © 2019 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BasicControlsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var resetBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldLabel: UILabel!
    @IBOutlet weak var textView: TextView!
    @IBOutlet weak var textViewLabel: UILabel!
    @IBOutlet weak var button: Button!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedControlLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var stepperLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerLabel: UILabel!
    @IBOutlet var valueChangedControls: [AnyObject]!

    // MARK: - Properties
    let disposeBag = DisposeBag()
    var skip = 1

    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.rx.text.asDriver()
            .drive(textFieldLabel.rx.text)
            .disposed(by: disposeBag)

        textField.rx.text.asDriver()
            .drive(onNext: { [weak self] _ in
                UIView.animate(withDuration: 0.3) { self?.view.layoutIfNeeded() }
        }).disposed(by: disposeBag)

        textView.rx.text.asDriver()
            .map { return "Character count: \($0?.count ?? 0)"}
            .drive(self.textViewLabel.rx.text)
            .disposed(by: disposeBag)

        button.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.buttonLabel.text! += "Tapped. "
                self?.view.endEditing(true)
                UIView.animate(withDuration: 0.3) { self?.view.layoutIfNeeded() }
            }).disposed(by: disposeBag)

        segmentedControl.rx.value.asDriver()
            .skip(skip)
            .drive(onNext: { [weak self] value in
                self?.segmentedControlLabel.text = "Selected segment: \(value)"
                UIView.animate(withDuration: 0.3) { self?.view.layoutIfNeeded() }
        }).disposed(by: disposeBag)

        slider.rx.value.asDriver()
            .drive(onNext: { [weak self] in
                self?.sliderLabel.text = "Slider value: \($0)"
        }).disposed(by: disposeBag)

        slider.rx.value.asDriver()
            .drive(onNext: { [weak self] in
                self?.progressView.progress = $0
        }).disposed(by: disposeBag)

        `switch`.rx.value.asDriver()
            .map { !$0 }
            .drive(activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)

        `switch`.rx.value.asDriver()
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        stepper.rx.value.asDriver()
            .map { String(Int($0)) }
            .drive(onNext: { [weak self] in
                self?.stepperLabel.text = $0
        }).disposed(by: disposeBag)

        tapGestureRecognizer.rx.event.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.view.endEditing(true)
        }).disposed(by: disposeBag)

        datePicker.rx.date.asDriver()
            .map { [weak self] in
                self?.dateFormatter.string(from: $0) ?? ""
            }
            .drive(onNext: { [weak self] in
                self?.datePickerLabel.text = "Selected date: \($0)"
        }).disposed(by: disposeBag)

        resetBarButtonItem.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.resetUI()
        }).disposed(by: disposeBag)
    }

    // MARK: - Helpers
    private func resetUI() {
        self.textField.rx.text.onNext("")
        self.textView.rx.text.onNext("Text view")
        self.buttonLabel.rx.text.onNext("")
        self.skip = 0
        self.segmentedControl.rx.value.onNext(-1)
        self.segmentedControlLabel.text = ""
        self.slider.rx.value.onNext(0.5)
        self.`switch`.rx.value.onNext(false)
        self.stepper.rx.value.onNext(0.0)
        self.datePicker.setDate(Date(), animated: true)
        self.valueChangedControls.forEach { $0.sendActions(for: .valueChanged) }
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
    }
}
