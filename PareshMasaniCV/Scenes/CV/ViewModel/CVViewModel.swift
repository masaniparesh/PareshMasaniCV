//
//  CVViewModel.swift
//  PareshMasaniCV
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

typealias ContactInfo = (phone: String, email: String)

/// View model is injected into a view controller under a protocol.
protocol CVViewModelProtocol {
    /// Whether view should display a loading indicator
    var isLoading: Observable<Bool> { get }
    
    /// Whether view should display an error
    var apiError: PublishSubject<Void> { get }
    
    /// Candidate's name
    var name: Observable<String?> { get }
    
    /// Candidate's job title
    var title: Observable<String?> { get }
    
    /// Candidate's contact info
    var contactInfo: Observable<ContactInfo?> { get }
    
    /// Table view section models
    var sections: Observable<[CVSectionModel]> { get }
    
    /// Load CV from server
    func getCV()
    
    /// Call candidate's phone number
    func callPhone()
    
    /// Send email to the candidate
    func sendEmail()
}

final class CVViewModel: CVViewModelProtocol {
    private enum Const {
        static let storageKey = "myCV"
    }
    
    private let service: CVServiceProtocol
    private let storage: StorageProtocol
    private let cvBehaviorRelay = BehaviorRelay<CVModel?>(value: nil)
    private let isLoadingRelay = BehaviorRelay(value: false)
    private let disposeBag = DisposeBag()
    
    var isLoading: Observable<Bool> {
        return isLoadingRelay.asObservable().distinctUntilChanged()
    }
    
    let apiError = PublishSubject<Void>()
    
    var name: Observable<String?> {
        return cvBehaviorRelay.map { $0?.name }
    }
    
    var title: Observable<String?> {
        return cvBehaviorRelay.map { $0?.title }
    }
    
    var contactInfo: Observable<ContactInfo?> {
        return cvBehaviorRelay.map { cvModel in
            guard let cvModel = cvModel else { return nil }
            return ContactInfo(phone: cvModel.contactInfo.phone, email: cvModel.contactInfo.email)
        }
    }
    
    var sections: Observable<[CVSectionModel]> {
        return cvBehaviorRelay
            .compactMap { $0 }
            .map { CVSectionsBuilder(model: $0).makeSections() }
    }
    
    init(service: CVServiceProtocol, storage: StorageProtocol) {
        self.service = service
        self.storage = storage
        getCVFromStorage()
    }
    
    func getCV() {
        // show loading indicator only if there's no data yet
        if cvBehaviorRelay.value == nil {
            isLoadingRelay.accept(true)
        }
        service.getCV().subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            try? self.storage.storeData(response.data, forKey: Const.storageKey)
            self.cvBehaviorRelay.accept(response.model)
            self.isLoadingRelay.accept(false)
            }, onError: { error in
                self.isLoadingRelay.accept(false)
                self.apiError.onNext(())
        })
            .disposed(by: disposeBag)
    }
    
    func callPhone() {
        // note: doesn't work on a simulator
        guard let phone = cvBehaviorRelay.value?.contactInfo.phone else { return }
        UIApplication.shared.callPhone(phone)
    }
    
    func sendEmail() {
        // note: doesn't work on a simulator
        guard let email = cvBehaviorRelay.value?.contactInfo.email else { return }
        UIApplication.shared.sendEmail(to: email)
    }
    
    private func getCVFromStorage() {
        do {
            let cvData = try storage.getData(forKey: Const.storageKey)
            let cv = try JSONDecoder.default.decode(CVModel.self, from: cvData)
            cvBehaviorRelay.accept(cv)
        } catch {
            cvBehaviorRelay.accept(nil)
        }
    }
    
}
