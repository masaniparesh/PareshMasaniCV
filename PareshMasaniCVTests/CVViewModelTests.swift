//
//  CVViewModelTests.swift
//  PareshMasaniCVTests
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation
import RxSwift
import Nimble
import Quick
@testable import PareshMasaniCV

class CVViewModelTests: QuickSpec {
    
    override func spec() {
        describe("view model") {
            context("when there's no data in storage") {
                let storage = StorageMock()
                let service = ServiceMock()
                let viewModel = CVViewModel(service: service, storage: storage)
                
                it("should retrieve and store data") {
                    let disposeBag = DisposeBag()
                    
                    viewModel.getCV()
                    
                    waitUntil { done in
                        viewModel.sections.subscribe(onNext: { sections in
                            done()
                            self.assertSectionModels(sections)
                            
                            // should store data in storage
                            do {
                                let data = try storage.getData(forKey: "myCV")
                                let model = try JSONDecoder.default.decode(CVModel.self, from: data)
                                expect(model.name) == "Paresh Masani"
                            } catch {
                                fail("didn't store data \(error.localizedDescription)")
                            }
                            
                        }).disposed(by: disposeBag)
                        
                    }
                }
            }
        }
    }
    
    private func assertSectionModels(_ sections: [CVSectionModel]) {
        guard sections.count == 4 else {
            fail("Incorrect number of sections")
            return
        }
        
        func assertSummarySection(_ section: CVSectionModel) {
            expect(section.headerTitle).to(beNil())
            guard let item = section.items.first else {
                fail("Incorrect number of items in summary section")
                return
            }
            expect(section.items.count) == 1
            switch item {
            case .summary(let summary):
                expect(summary) == "I am a passionate, dedicated, enthusiast, and inventive technology geek!"
            default:
                fail("incorrect item type in summary section")
            }
        }
        
        assertSummarySection(sections[0])
        
        // TODO: in a similar way we can assert all other sections. Didn't do it due to lack of time.
    }
}

private class StorageMock: StorageProtocol {
    private var dictionary: [String: Data] = [:]
    
    func storeData(_ data: Data, forKey key: String) throws {
        dictionary[key] = data
    }
    
    func removeData(forKey key: String) throws {
        dictionary.removeValue(forKey: key)
    }
    
    func getData(forKey key: String) throws -> Data {
        guard let data = dictionary[key] else {
            throw NSError(domain: "com.PareshMasaniCVTests.CVViewModelTests", code: -1, userInfo: nil)
        }
        return data
    }
    
}

private class ServiceMock: CVServiceProtocol {
    func getCV() -> Observable<DecodableResponse<CVModel>> {
        let data = dataFromJSON(withName: "correct_cv").require()
        let model = (try? JSONDecoder.default.decode(CVModel.self, from: data)).require()
        return Observable.just(DecodableResponse(data: data, model: model))
    }
}
