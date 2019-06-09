//
//  CVViewController.swift
//  PareshMasaniCV
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

/// Displays user's CV.
final class CVViewController: UIViewController, StoryboardIdentifiable {
    
    var viewModel: CVViewModelProtocol!
    
    @IBOutlet private var phoneButtonItem: UIBarButtonItem!
    @IBOutlet private var mailButtonItem: UIBarButtonItem!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var headerView: CVTableHeaderView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
        viewModel.getCV()
    }
}

// -------------------------------------
// MARK: - Bindings
// -------------------------------------
private extension CVViewController {
    func setupBindings() {
        setupContactInfoBindings()
        setupHeaderBindings()
        setupTableViewBindings()
        
        viewModel.apiError.subscribe(onNext: { [weak self] _ in
            self?.showError()
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.bind(to: rx.showsActivityView)
            .disposed(by: disposeBag)
    }
    
    func setupContactInfoBindings() {
        // only enable bar button items if the contact info exists
        viewModel.contactInfo
            .map { $0 != nil }
            .bind(to: phoneButtonItem.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.contactInfo
            .map { $0 != nil }
            .bind(to: mailButtonItem.rx.isEnabled)
            .disposed(by: disposeBag)
        
        phoneButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.callPhone()
            }).disposed(by: disposeBag)
        
        mailButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.sendEmail()
            }).disposed(by: disposeBag)
    }
    
    func setupHeaderBindings() {
        viewModel.name
            .bind(to: headerView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.title
            .bind(to: headerView.titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setupTableViewBindings() {
        tableView.refreshControl?.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.refreshControl?.endRefreshing()
                self?.viewModel.getCV()
            })
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<CVSectionModel>.init(configureCell: { (_, tableView, _, cellModelType) -> UITableViewCell in
            return tableView.dequeueCell(forType: cellModelType)
        }, titleForHeaderInSection: { (dataSource, index) -> String? in
            return dataSource.sectionModels[index].headerTitle?.uppercased()
        })
        viewModel.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// -------------------------------------
// MARK: - Helpers
// -------------------------------------
private extension CVViewController {
    func setupTableView() {
        tableView.tableHeaderView = headerView
        tableView.refreshControl = UIRefreshControl()
    }
    
    func showError() {
        let alert = UIAlertController(title: Strings.Error.title, message: Strings.Error.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.Error.buttonTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func dequeueCell(forType type: CVCellModelType) -> UITableViewCell {
        switch type {
        case .summary(let summary):
            let cell = tableView.dequeueReusableCell(className: CVSummaryTableViewCell.self)
            cell.summary = summary
            return cell
        case .skill(let title, let skills):
            let cell = tableView.dequeueReusableCell(className: CVSkillTableViewCell.self)
            cell.populate(withTitle: title, skills: skills)
            return cell
        case .company(let company):
            let cell = tableView.dequeueReusableCell(className: CVCompanyTableViewCell.self)
            cell.populate(withModel: company)
            return cell
        case .education(let education):
            let cell = tableView.dequeueReusableCell(className: CVEducationTableViewCell.self)
            cell.populate(withModel: education)
            return cell
        }
    }
}

private extension UITableView {
    func dequeueCell(forType type: CVCellModelType) -> UITableViewCell {
        switch type {
        case .summary(let summary):
            let cell = dequeueReusableCell(className: CVSummaryTableViewCell.self)
            cell.summary = summary
            return cell
        case .skill(let title, let skills):
            let cell = dequeueReusableCell(className: CVSkillTableViewCell.self)
            cell.populate(withTitle: title, skills: skills)
            return cell
        case .company(let company):
            let cell = dequeueReusableCell(className: CVCompanyTableViewCell.self)
            cell.populate(withModel: company)
            return cell
        case .education(let education):
            let cell = dequeueReusableCell(className: CVEducationTableViewCell.self)
            cell.populate(withModel: education)
            return cell
        }
    }
}
