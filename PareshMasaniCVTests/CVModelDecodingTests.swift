//
//  CVModelDecodingTests.swift
//  PareshMasaniCVTests
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation
import Nimble
import Quick
@testable import PareshMasaniCV

class CVModelDecodingTests: QuickSpec {
    
    override func spec() {
        describe("CVModel") {
            let jsonDecoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM yyyy"
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            context("when decoded from correct JSON") {
                let jsonData = dataFromJSON(withName: "correct_cv")!
                it("should be decoded correctly") {
                    do {
                        let model = try jsonDecoder.decode(CVModel.self, from: jsonData)
                        self.assertCVModelFields(model)
                    } catch {
                        fail("Could not decode: \(error)")
                    }
                }
            }
            context("when decoded from incorrect JSON") {
                let jsonData = dataFromJSON(withName: "incorrect_cv")!
                it("should throw error") {
                    expect { try jsonDecoder.decode(CVModel.self, from: jsonData) }.to(throwError())
                }
            }
        }
    }
    
    private func assertCVModelFields(_ model: CVModel) {
        expect(model.name) == "Paresh Masani"
        expect(model.summary) == "I am a passionate, dedicated, enthusiast, and inventive technology geek!"
        
        // contact info
        expect(model.contactInfo.address.readableName) == "14 Elthorne Road, London, NW9 8BJ"
        expect(model.contactInfo.address.latitude) == 51.5775298
        expect(model.contactInfo.address.longitude) == -0.2614758
        expect(model.contactInfo.phone) == "07411621887"
        expect(model.contactInfo.email) == "paresh.masani@gmail.com"
        
        // skills
        expect(model.skills.areaOfExpertise) == ["iOS Development", "Communication", "Agile Methodologies"]
        expect(model.skills.toolsAndTechnologies) == ["Swift", "Objective-C", "ReactiveSwift / RxSwift", "Java"]
        expect(model.skills.other) == ["Enterprise Development", "Cloud Platforms"]
        
        // work experience
        guard model.workExperience.count == 2 else {
            fail("incorrect number of companies")
            return
        }
        
        expect(model.workExperience[0].companyName) == "JPMorgan Chase & Co."
        expect(model.workExperience[0].companyLogo) == "https://logoeps.com/wp-content/uploads/2012/05/jpmorgan-chase-logo-vector-01.png"
        expect(self.stringFromDate(model.workExperience[0].startDate)) == "Dec 2018"
        expect(self.stringFromDate(model.workExperience[0].endDate)) == "Apr 2019"
        expect(model.workExperience[0].role) == "iOS Contractor"
        expect(model.workExperience[0].accomplishments) == [
            "Developed enterprise App JPMorgan Chase Loan App",
            "Co-developed JPMorgan Chase Pay iOS App"
        ]
        
        expect(model.workExperience[1].companyName) == "Hi Mum! Said Dad"
        expect(model.workExperience[1].companyLogo).to(beNil())
        expect(self.stringFromDate(model.workExperience[1].startDate)) == "Aug 2018"
        expect(self.stringFromDate(model.workExperience[1].endDate)) == "Oct 2018"
        expect(model.workExperience[1].role) == "iOS Contractor"
        expect(model.workExperience[1].accomplishments).to(beEmpty())
    }
    
}

private extension CVModelDecodingTests {
    func stringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: date)
    }
}
