//
//  LocalJsonDataTests.swift
//  ANF Code TestTests
//

import XCTest
@testable import ANF_Code_Test

class LocalJsonDataTests: XCTestCase {

    override func setUp() {
        
        do {
            try testLocalData()

        } catch let error {
            print(error.localizedDescription)
        }
    }

    //MARK:- Test local data
    func testLocalData() throws {
        
        // check file path exist or not
        guard let filePath = Bundle.main.path(forResource: "exploreData", ofType: "json") else {
            XCTFail("File path not exist!")
            return
        }
        
        // convert file to data
        let url = URL(fileURLWithPath: filePath)
        guard let fileContent = try? Data(contentsOf: url) else {
            XCTFail("Data converting failed")
            return
        }
        
        // decode data to shop model
        guard let result = try? JSONDecoder().decode([ShopModel].self, from: fileContent) else {
            XCTFail("Model converting failed")
            return
        }
        
        print(result)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
