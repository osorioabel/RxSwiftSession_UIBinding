//
//  SectionedTableViewAnimatedViewController.swift
//  UIBinding
//
//  Created by Abel Osorio on 3/24/19.
//  Copyright © 2019 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

struct AnimatedSectionModel {
    let title: String
    var dataSourceItems: [String]
}

extension AnimatedSectionModel: AnimatableSectionModelType {
    typealias Item = String
    typealias Identity = String

    var identity: Identity { return title }
    var items: [Item] { return dataSourceItems }

    init(original: AnimatedSectionModel, items: [String]) {
        self = original
        dataSourceItems = items
    }
}

class SectionedTableViewAnimatedViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!

    // MARK: - Properties
    lazy var dataSource: RxTableViewSectionedAnimatedDataSource<AnimatedSectionModel> = {
        let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatedSectionModel>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = item
                return cell
        })

        dataSource.titleForHeaderInSection = {
            $0[$1].title
        }

        return dataSource
    }()

    let data = Variable([AnimatedSectionModel(title: "Section 1",
                                              dataSourceItems: ["Sample Data 1-1", "Sample Data 1-2"])])

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
                let index = self.data.value.count + 1
                self.data.value += [AnimatedSectionModel(title: "Section \(index)", dataSourceItems: ["Sample Data \(index)-1", "Sample Data \(index)-2"])]
        }).disposed(by: disposeBag)
    }

}
