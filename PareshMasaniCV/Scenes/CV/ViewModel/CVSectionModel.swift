//
//  CVSectionModel.swift
//  PareshMasaniCV
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation
import RxDataSources

/// Represents possible table view cell types.
enum CVCellModelType {
    case summary(String)
    case skill(title: String, skills: [String])
    case company(CompanyCellModel)
    case education(EducationCellModel)
}

extension CVCellModelType {
    struct CompanyCellModel {
        let title: String
        let years: String
        let logo: String?
        let role: String
        let accomplishments: [String]
    }
    
    struct EducationCellModel {
        let title: String
        let dates: String
        let schoolName: String
    }
}

/// Represents table view section
struct CVSectionModel: SectionModelType {
    var headerTitle: String?
    var items: [CVCellModelType]
    
    init(original: CVSectionModel, items: [CVCellModelType]) {
        self = original
        self.items = items
    }
    
    init(items: [CVCellModelType], headerTitle: String? = nil) {
        self.items = items
        self.headerTitle = headerTitle
    }
    
}
