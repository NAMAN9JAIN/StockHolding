//
//  StockHoldingTests.swift
//  StockHoldingTests
//
//  Created by Naman Jain on 01/11/24.
//

import XCTest
@testable import StockHolding

final class StockHoldingTests: XCTestCase {
    var viewModel: ViewModel!
    var usecase: UsecaseMock!
    var spy: StockHoldingTestsSpy!

    override func setUpWithError() throws {
        usecase = UsecaseMock()
        spy = StockHoldingTestsSpy()
        viewModel = DefaultViewModel(usecase: usecase, delegate: spy)
    }

    override func tearDownWithError() throws {
        usecase = nil
        spy = nil
        viewModel = nil
    }

    func testSuccessApiResponse() throws {
        let expectation = expectation(description: "get success with some holdings")
        
        spy.gotResponse = {
            expectation.fulfill()
        }
        
        viewModel.input.getHoldingData()
        
        waitForExpectations(timeout: 2)
        XCTAssertTrue(!viewModel.data.sectionData.isEmpty)
        XCTAssertNotNil(viewModel.data.holdingSummaryData)
        viewModel.data.holdingSummaryData?.data.forEach({ points in
            if points.key == .totalInvestment {
                XCTAssert(points.value != 0)
            }
        })
    }
    
    func testNoHoldingResponse() {
        usecase.response = .success(holdingPresent: false)
        let expectation = expectation(description: "get success with no holdings")
        
        spy.gotResponse = {
            expectation.fulfill()
        }
        
        viewModel.input.getHoldingData()
        
        waitForExpectations(timeout: 2)
        XCTAssertTrue(viewModel.data.sectionData.isEmpty)
        viewModel.data.holdingSummaryData?.data.forEach({ points in
            XCTAssert(points.value == 0)
        })
    }
    
    func testApiFailedResponse() {
        usecase.response = .apiFailed
        let expectation = expectation(description: "get success with no holdings")
        
        spy.gotResponse = {
            expectation.fulfill()
        }
        
        viewModel.input.getHoldingData()
        waitForExpectations(timeout: 2)
        XCTAssertTrue(viewModel.data.sectionData.isEmpty)
        viewModel.data.holdingSummaryData?.data.forEach({ points in
            XCTAssert(points.value == 0)
        })
    }
}

class StockHoldingTestsSpy: ViewModelOutput {
    var gotResponse: (() -> Void)?
    var message: String = ""
    
    func updateHoldingsDataFetchFail(message: String) {
        self.message = message
        gotResponse?()
    }

    func updateHoldings() {
        gotResponse?()
    }
}
