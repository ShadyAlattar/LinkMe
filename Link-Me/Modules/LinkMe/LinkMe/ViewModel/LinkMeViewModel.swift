//
//  LinkMeViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 10/05/2023.
//

import Foundation
import RxSwift
import RxCocoa

class LinkMeViewModel: BaseViewModel {
    
    // MARK: Properties

    private let linkMeApi: LinkMeAPIProtocol
    private let disposeBag = DisposeBag()

    // MARK: Outputs

    private var topUsersModel = BehaviorRelay<TopUserData?>(value: nil)
    var topUsersModelObservable: Observable<TopUserData?> {
        return topUsersModel.asObservable()
    }
    
    private var topUsers = BehaviorRelay<[User]>(value: [])
    var topUsersObservable: Observable<[User]> {
        return topUsers.asObservable()
    }

    private var errorMessage = PublishSubject<String>()
    var errorMessageObservable: Observable<String> {
        return errorMessage.asObservable()
    }
    
    func getUserModel(_ row: Int) -> User {
        return topUsers.value[row]
    }
    
    func getBeInTopModel() -> BeInTopModel {
        var startsModel: [StarModel] = []
        
        topUsersModel.value?.stars?.forEach({ star in
            startsModel.append(StarModel(id: star.id, diamonds: star.diamonds, titleAr: star.titleAr, titleEn: star.titleEn))
        })
        
        let model = BeInTopModel(numberOfUsers: topUsers.value.count, stars: startsModel)
        return model
    }

    // MARK: Init

    init(linkMeApi: LinkMeAPIProtocol = LinkMeAPI()) {
        self.linkMeApi = linkMeApi
    }
}

// MARK: Fetch top users

extension LinkMeViewModel {
    func fetchTopUsers() {
        linkMeApi.fetchTopUsers().subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                guard let data = model.data, let users = data.users else { return }
                self.topUsersModel.accept(data)
                self.topUsers.accept(users)
                
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.errorMessage.onNext(errorMessage ?? "")
            }
            
        }).disposed(by: disposeBag)
    }
}
