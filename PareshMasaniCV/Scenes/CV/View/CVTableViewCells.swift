//
//  CVTableViewCells.swift
//  PareshMasaniCV
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

final class CVSummaryTableViewCell: UITableViewCell {
    
    @IBOutlet private var summaryLabel: UILabel!
    
    var summary: String? {
        didSet {
            summaryLabel.text = summary
        }
    }
    
}

final class CVSkillTableViewCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var skillsLabel: UILabel!
    
    func populate(withTitle title: String, skills: [String]) {
        titleLabel.text = title
        skillsLabel.text = skills.map { "• \($0)" }.joined(separator: "\n")
    }
}

final class CVCompanyTableViewCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var yearsLabel: UILabel!
    @IBOutlet private var logoImageView: UIImageView!
    @IBOutlet private var roleLabel: UILabel!
    @IBOutlet private var accomplishmentsLabel: UILabel!
    
    func populate(withModel model: CVCellModelType.CompanyCellModel) {
        titleLabel.text = model.title
        yearsLabel.text = model.years
        logoImageView.af_cancelImageRequest()
        if let logoURL = (model.logo.flatMap { URL(string: $0) }) {
            logoImageView.af_setImage(withURL: logoURL)
            logoImageView.isHidden = false
        } else {
            logoImageView.image = nil
            logoImageView.isHidden = true
        }
        roleLabel.text = model.role
        accomplishmentsLabel.text = model.accomplishments.map { "• \($0)"}.joined(separator: "\n")
    }
}

final class CVEducationTableViewCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var datesLabel: UILabel!
    @IBOutlet private var schoolNameLabel: UILabel!
    
    func populate(withModel model: CVCellModelType.EducationCellModel) {
        titleLabel.text = model.title
        datesLabel.text = model.dates
        schoolNameLabel.text = model.schoolName
    }
}
