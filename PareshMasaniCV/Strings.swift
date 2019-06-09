//
//  Strings.swift
//  PareshMasaniCV
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation

// String constants that are used throughout the app.
// In a real app I use Localizable.strings with swiftgen.
enum Strings {
    static let skillSectionTitle = "Skills"
    static let workExperienceSectionTitle = "Work experience"
    static let educationSectionTitle = "Education"
    static let areaOfExpertise = "Area of Expertise"
    static let toolsAndTechnologies = "Tools & Technologies"
    static let other = "Other"
    
    enum Error {
        static let title = "Error"
        static let message = "Failed to load the CV!"
        static let buttonTitle = "OK"
    }
}
