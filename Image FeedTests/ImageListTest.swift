//
//  ImageListTest.swift
//  Image FeedTests
//
//  Created by Denis on 23.03.2023.
//

@testable import Image_Feed
import XCTest

final class ImageListViewTests: XCTestCase {
    
    func testPresenterViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)
        
        // Trigger viewDidLoad
        viewController.loadViewIfNeeded()
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }


    
    func testAddPhotos() {
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImageListPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        let imagesListService = presenter.imagesListService
        XCTAssertNotNil(imagesListService.photos)
    }
}

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ImagesListViewControllerProtocol?
    var imagesListService = ImagesListService()
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage() {
        return
    }
}

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    var updateTableViewAnimatedCalled = false
    var photosAdded = false
    
    var photos: [Photo] = []
    
    func updateTableViewAnimated(photos: [Photo]) {
        updateTableViewAnimatedCalled = true
    }
}
