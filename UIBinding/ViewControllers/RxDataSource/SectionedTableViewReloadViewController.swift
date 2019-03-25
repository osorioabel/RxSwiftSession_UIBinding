//
//  SectionedTableViewReloadViewController.swift
//  UIBinding
//
//  Created by Abel Osorio on 3/24/19.
//  Copyright © 2019 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

enum ReloadDataSource: String, CaseIterable {
    case SampleData1 = "Sample Data 1"
    case SampleData2 = "Sample Data 2"
}

extension ReloadDataSource: IdentifiableType {
    var identity: String { return rawValue }
}

class SectionedTableViewReloadViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!

    // MARK: - Properties
    lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, ReloadDataSource>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ReloadDataSource>>(
            configureCell: { _, tableView, indexPath, dataSourceItem in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = dataSourceItem.rawValue
                return cell
        })

        dataSource.titleForHeaderInSection = {
            $0[$1].model
        }
        return dataSource
    }()

    let data = Variable([SectionModel(model: "Section 1", items: ReloadDataSource.allCases)])

    let disposeBag = DisposeBag()

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        data.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        addBarButtonItem.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.data.value += [SectionModel(model: "Section \(self.data.value.count + 1)",
                    items: ReloadDataSource.allCases)]
            }).disposed(by: disposeBag)
    }

}
