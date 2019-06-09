//
//  CVSectionsBuilder.swift
//  PareshMasaniCV
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation

/// Responsible for creating an array of section models from a `CVModel`.
struct CVSectionsBuilder {
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
