//
//  MainStoriesVC.swift
//  Link-Me
//
//  Created by Al-attar on 19/07/2023.
//

import UIKit
import AnimatedCollectionViewLayout

class MainStoriesVC: BaseWireFrame<MainStoriesViewModel>, UIScrollViewDelegate, UIViewControllerTransitioningDelegate {
    
    //MARK: - @IBOutlet -
    
    @IBOutlet weak var storiesCollView: UICollectionView!
    
    //MARK: - Variables -
    
    
    //MARK: - Bind -
    
    override func bind(viewModel: MainStoriesViewModel) {
        setupView()
        setupStoriesCollV()
    }
    
    
    //MARK: - Private func
    
    private func setupView(){
        let layout = AnimatedCollectionViewLayout()
        layout.animator = CubeAttributesAnimator()
        //CubeAttributesAnimator()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        storiesCollView.collectionViewLayout = layout
    }
    
    private func setupStoriesCollV(){
        storiesCollView.registerNIB(StoryCell.self)
        storiesCollView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.storiesData.bind(to: storiesCollView.rx.items(cellIdentifier: String(describing: StoryCell.self), cellType: StoryCell.self)){ (row,item,cell) in
            if row == 0{
                cell.add_btn.isHidden = false
            }else{
                cell.add_btn.isHidden = true
            }
            
            cell.userImage_iv.image = item.image
            cell.userName_lbl.text = item.name
            
                    
            //cell.configure(item)
        }.disposed(by: disposeBag)
        
        storiesCollView.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self, let indexPath = indexPath.element else {return}
            print("IndexPath: \(indexPath)")
            
            let vc = self.coordinator.Main.viewcontroller(for: .StoryPreview) as! StoryPreviewVC
            let data = self.viewModel.storiesData.value
            vc.stories = data[indexPath.row].stories
            self.present(vc, animated: true)
            
          //  self.coordinator.Main.navigate(for: .StoryPreview, navigtorTypes: .present())
            
            
        }.disposed(by: disposeBag)
    }
    
    
    //MARK: - Actions -
    
    
}


extension MainStoriesVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 66, height: 88)
    }
}

