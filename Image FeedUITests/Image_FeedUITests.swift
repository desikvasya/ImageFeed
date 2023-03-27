//
//  Image_FeedUITests.swift
//  Image FeedUITests
//
//  Created by Denis on 23.03.2023.
//

@testable import Image_Feed
import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        sleep(10)
        //
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        //
        passwordTextField.tap()
        passwordTextField.typeText("password")
        sleep(5)
        webView.tap()
        webView.swipeUp()
        //
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("desikvasya1@gmail.com")
        app.toolbars.buttons["Done"].tap()


        print(app.debugDescription)
        
        let loginButton = webView.descendants(matching: .button).element
        loginButton.tap()
        sleep(15)
        
        
        let tables = app.tables
        let cell = tables.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.waitForExistence(timeout: 1)
        cell.swipeUp()
        sleep(10)
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons["like button off"].tap()
        sleep(10)
        cellToLike.buttons["like button on"].tap()
        sleep(10)
        cellToLike.tap()
        sleep(10)
        let image = app.scrollViews.images.element(boundBy: 0)
        sleep(40)
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(5)
        // open profile
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        sleep(3)
        
        // check labels
        XCTAssertTrue(app.staticTexts["Denis Korostelev"].exists)
        sleep(2)
        XCTAssertTrue(app.staticTexts["@desikvasya"].exists)
        sleep(2)
        let logoutButton = app.buttons["logoutButton"]
        sleep(5)
        logoutButton.tap()
        
        sleep(3)
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
    
    
}

