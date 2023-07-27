//
//  MainStoriesViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 19/07/2023.
//

import Foundation
import RxCocoa
import RxSwift


struct Stories{
    var name: String
    var image: UIImage
    var stories: [UIImage]
}

//MARK: - ViewController -> ViewModel

protocol MainStoriesInputs{
    
}


//MARK: - ViewController <- ViewModel

protocol MainStoriesOutputs{
//    var myAccountStatus: PublishSubject<BaseResponseGen<User>> {get set}

}

class MainStoriesViewModel: BaseViewModel{
    
    //MARK: - Properties -
    
    var storiesData: BehaviorRelay<[Stories]> = .init(value: [
        Stories(name: "Add", image: UIImage(named: "blank")!, stories: []),
        Stories(name: "Shady", image: UIImage(named: "AmrDiab")!, stories: [UIImage(named: "AmrDiab")!]),
        Stories(name: "G3fry", image: UIImage(named: "AmrDiab")!, stories: [UIImage(named: "AmrDiab 1")!]),
        Stories(name: "Ta7", image: UIImage(named: "AmrDiab")!, stories: [UIImage(named: "AmrDiab 2")!]),
        Stories(name: "Fathy", image: UIImage(named: "AmrDiab")!, stories: [UIImage(named: "AmrDiab 3")!]),
        Stories(name: "Elmkyma", image: UIImage(named: "AmrDiab")!, stories: [UIImage(named: "AmrDiab 4")!]),
    ])
         
    
    //MARK: - API Call -

    
}
