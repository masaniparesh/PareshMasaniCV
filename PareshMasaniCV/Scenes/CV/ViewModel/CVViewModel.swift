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

protocol CVViewModelProtocol {
    var isLoading: Observable<Bool> { get }
    var apiError: PublishSubject<Void> { get }
    var name: Observable<String?> { get }
    var title: Observable<String?> { get }
    var contactInfo: Observable<ContactInfo?> { get }
    var sections: Observable<[CVSectionModel]> { get }
    func getCV()
    func callPhone()
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
            .map { CVModelConverter(model: $0).makeSections() }
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
    
}

private extension CVViewModel {
    func getCVFromStorage() {
        do {
            let cvData = try storage.getData(forKey: Const.storageKey)
            let cv = try JSONDecoder.default.decode(CVModel.self, from: cvData)
            cvBehaviorRelay.accept(cv)
        } catch {
            cvBehaviorRelay.accept(nil)
        }
    }
}

private struct CVModelConverter {
    let model: CVModel
    
    func makeSections() -> [CVSectionModel] {
        var sections: [CVSectionModel] = []
        
        let summarySection = CVSectionModel(items: [.summary(model.summary)])
        sections.append(summarySection)
        sections.append(makeSkillsSection())
        sections.append(makeExperienceSection())
        sections.append(makeEducationSection())
        return sections
    }
    
    private func makeSkillsSection() -> CVSectionModel {
        var items: [CVCellModelType] = []
        items.append(.skill(title: Strings.areaOfExpertise, skills: model.skills.areaOfExpertise))
        items.append(.skill(title: Strings.toolsAndTechnologies, skills: model.skills.toolsAndTechnologies))
        items.append(.skill(title: Strings.other, skills: model.skills.other))
        return CVSectionModel(items: items, headerTitle: Strings.skillSectionTitle)
    }
    
    private func makeExperienceSection() -> CVSectionModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        let items: [CVCellModelType] = model.workExperience.map {
            let startDate = dateFormatter.string(from: $0.startDate)
            let endDate = dateFormatter.string(from: $0.endDate)
            let companyModel = CVCellModelType.CompanyCellModel(
                title: "\($0.companyName)",
                years: "\(startDate) - \(endDate)",
                logo: $0.companyLogo,
                //                logo: "https://g.foolcdn.com/art/companylogos/square/jpm.png",
                role: $0.role,
                accomplishments: $0.accomplishments
            )
            return .company(companyModel)
        }
        return CVSectionModel(items: items, headerTitle: Strings.workExperienceSectionTitle)
    }
    
    private func makeEducationSection() -> CVSectionModel {
        let items: [CVCellModelType] = model.education.map {
            var title = $0.specialty
            if let achievements = $0.achievements {
                title.append(" - \(achievements)")
            }
            let educationModel = CVCellModelType.EducationCellModel(
                title: title,
                dates: "\($0.startYear) - \($0.endYear)",
                schoolName: $0.schoolName
            )
            return .education(educationModel)
        }
        return CVSectionModel(items: items, headerTitle: Strings.educationSectionTitle)
    }
}
