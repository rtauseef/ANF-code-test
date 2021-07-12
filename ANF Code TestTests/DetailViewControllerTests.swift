//
//  DetailViewControllerTests.swift
//  ANF Code TestTests
//

import XCTest
@testable import ANF_Code_Test

class DetailViewControllerTests: XCTestCase {

    let shopViewModel = ShopViewModel()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    //MARK:- Test api
    func testApiResponse() throws {
        
        // for test api response
        let URL = NSURL(string: API_URL)!
        let exp = self.expectation(description: "GET \(URL)")
        
        // api call
        let session = URLSession.shared
        let task = session.dataTask(with: URL as URL) { data, response, error in
            
            // check data & error
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            // check response
            if let HTTPResponse = response as? HTTPURLResponse,
               let responseURL = HTTPResponse.url
            {
                XCTAssertEqual(responseURL.absoluteString, URL.absoluteString, "HTTP response URL should be equal to original URL")
                XCTAssertEqual(HTTPResponse.statusCode, 200, "HTTP response status code should be 200")
            } else {
                XCTFail("Response was not NSHTTPURLResponse")
            }
            
            exp.fulfill()
        }
        
        task.resume()
        
        waitForExpectations(timeout: task.originalRequest!.timeoutInterval) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task.cancel()
        }
    }
    
    //MARK:- Test shop items
    func testShopItems() throws {

        let URL = NSURL(string: API_URL)!
        let exp = self.expectation(description: "GET \(URL)")
        
        let session = URLSession.shared
        let task = session.dataTask(with: URL as URL) { data, response, error in
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray
                XCTAssertNotNil(jsonResult, "response not in json object")
                
                let result = try JSONDecoder().decode([ShopModel].self, from: data!)
                XCTAssertNotNil(result, "model conversion failed")
                self.shopViewModel.arrData = result
                
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
            
            exp.fulfill()
        }
        
        task.resume()
        
        waitForExpectations(timeout: task.originalRequest!.timeoutInterval) { [self] error in
            task.cancel()
            
            // to check single item
            let model = self.shopViewModel.arrData[0]
            self.checkItem(model: model)
            
            // to check all item
//            for item in self.shopViewModel.arrData {
//                self.checkItem(model: item)
//            }
        }
    }
        
    //MARK:- Check single item
    func checkItem(model: ShopModel) {
        
        XCTAssertNotNil(model.title, "Title is nil")
        XCTAssertNotNil(model.backgroundImage, "Image is nil")
        XCTAssertNotNil(model.promoMessage, "Promo message is nil")
        XCTAssertNotNil(model.topDescription, "Top description is nil")
        XCTAssertNotNil(model.bottomDescription, "Bottom description is nil")
        XCTAssertNotNil(model.content, "Content is nil")
        
        for modelContent in model.content! {
            XCTAssertNotNil(modelContent.title, "Content title is nil")
            XCTAssertNotNil(modelContent.target, "Content target is nil")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
