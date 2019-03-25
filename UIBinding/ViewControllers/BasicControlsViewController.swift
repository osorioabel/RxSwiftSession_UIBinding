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

        // TODO: - Bind textField to textFieldLabel text


        // TODO: - layoutIfNeeded to show the label


        // TODO: - bind textView text to textViewLabel to show character count


        // TODO: - bind tap action and update buttonLabel


        // TODO: - bind segmentedControl to segmentedControlLabel to see the selectedValue


        // TODO: - bind slider to sliderLabel to see the value


        // TODO: - bind slider to progressView to see the value
        // TODO: - demostrate differences with asObservable()



        // TODO: - bind switch with activityIndicator is hidden

        // TODO: - bind switch with activityIndicator is isAnimating

        // TODO: - bind stepper with stepperLabel is text


        // TODO: - bind tapGestureRecognizer with endEditing


        // TODO: - bind datePicker datePickerLabel


        // TODO: - bind resetBarButtonItem tap with funcion
        
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
