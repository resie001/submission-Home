//
//  HomeRouter.swift
//  submission-Home
//
//  Created by Ade Resie on 24/12/22.
//

import UIKit
import submission_Core

public protocol HomeDelegate: AnyObject {
    func cellSelected(id: Float)
}

public class HomeRouter: HomePresenterToRouterProtocol {
    public static func createModule(type: List, delegate: HomeDelegate) -> UIViewController {
        let view = HomeViewController()
        let presenter = HomePresenter()
        let router = HomeRouter()
        let interactor = HomeInteractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        presenter.type = type
        interactor.presenter = presenter
        interactor.repository = Injection.getInstance()
        
        return view
    }
}
