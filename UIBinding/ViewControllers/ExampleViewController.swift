//
//  ExampleViewController.swift
//  UIBinding
//
//  Created by Abel Osorio on 3/24/19.
//  Copyright © 2019 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ExamplesViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    enum DataSource: String {

        case BasicControlsViewController = "Basic Controls"
        case TwoWayBindingViewController = "Two-Way Binding"
        case SectionedTableViewReloadViewController = "Reload Data Source"
        case SectionedTableViewAnimatedViewController = "Animated Data Source"

        static let allValues: [DataSource] = [.BasicControlsViewController,
                                              .TwoWayBindingViewController,
                                              .SectionedTableViewReloadViewController,
                                              .SectionedTableViewAnimatedViewController]

    }

    let dataSource = Observable.just(DataSource.allValues)
    let disposeBag = DisposeBag()

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.bind(to: tableView.rx.items(cellIdentifier: "Cell")) { row, element, cell in
            cell.textLabel?.text = element.rawValue
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)

        tableView.rx.modelSelected(DataSource.self)
            .map { "\($0)" }
            .subscribe(onNext: { [weak self] in
                self?.performSegue(withIdentifier: $0, sender: nil)
        }).disposed(by: disposeBag)
    }
}
