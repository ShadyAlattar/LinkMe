//
//  MainStoriesVC.swift
//  Link-Me
//
//  Created by Al-attar on 19/07/2023.
//

import UIKit
import AnimatedCollectionViewLayout
import MobileCoreServices

class MainStoriesVC: BaseWireFrame<MainStoriesViewModel>, UIScrollViewDelegate, UIViewControllerTransitioningDelegate {
    
    //MARK: - @IBOutlet -
    
    @IBOutlet weak var storiesCollView: UICollectionView!
    @IBOutlet private weak var othersStoriesCollectionView: UICollectionView!
    
    //MARK: - Variables -
    
    //MARK: - Lifecycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchStories()
        viewModel.ViewDidLoad()
    }
    
    //MARK: - Bind -
    
    override func bind(viewModel: MainStoriesViewModel) {
        setupView()
        setupStoriesCollV()
        configureOthersStoriesCollectionView()
        subscribeToErrorMessage()
    }
    
    
    //MARK: - Private func
    
    private func setupView(){
        //        let layout = AnimatedCollectionViewLayout()
        //        layout.animator = CubeAttributesAnimator()
        //        //CubeAttributesAnimator()
        //        layout.scrollDirection = .horizontal
        //        layout.minimumLineSpacing = 0.0
        //        layout.minimumInteritemSpacing = 0.0
        //        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        //        storiesCollView.collectionViewLayout = layout
    }
    
    private func setupStoriesCollV(){
        storiesCollView.registerNIB(StoryCell.self)
        storiesCollView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.storiesData.bind(to: storiesCollView.rx.items(cellIdentifier: String(describing: StoryCell.self), cellType: StoryCell.self)){ (row,item,cell) in
            if row == 0{
                cell.add_btn.isHidden = false
                cell.circleView.backgroundColor = .white
            }else{
                cell.add_btn.isHidden = true
                cell.circleView.backgroundColor = .clear
            }
            
            cell.update(item)
            
        }.disposed(by: disposeBag)
        
        storiesCollView.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self, let indexPath = indexPath.element else {return}
            
            let vc = self.coordinator.Main.viewcontroller(for: .StoryPreview) as! StoryPreviewVC
            
            if indexPath.row == 0{
                print("Add Store")
                
                if UDHelper.fetchUserData?.canAddStory == 0{
                    self.coordinator.Main.navigate(for: .FeaturesPremium,navigtorTypes: .present())
                }else{
                    self.getMedia()
                }
            }else{
                vc.indexPath = indexPath.row
                vc.myStoriesDate = self.viewModel.storiesData
                self.present(vc, animated: true)
            }
            
        }.disposed(by: disposeBag)
    }
    
    private func getMedia(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Actions -
    
    
}


extension MainStoriesVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == storiesCollView {
            return CGSize(width: 66, height: 88)
        } else {
            return indexPath.row == 0 ? CGSize(width: self.view.frame.width, height: 0) : CGSize(width: 110, height: 180)
        }
    }
}


extension MainStoriesVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let mediaType = info[.mediaType] as? String {
               if mediaType == kUTTypeImage as String {
                   // Handle selected image
                   if let image = info[.originalImage] as? UIImage {
                       // Do something with the selected image
                       self.coordinator.Main.navigate(for: .MediaPreview(mediaType: .image,image: image))
                   }
               } else if mediaType == kUTTypeMovie as String {
                   // Handle selected video
                   if let videoURL = info[.mediaURL] as? URL {
                       // Do something with the selected video URL
                       self.coordinator.Main.navigate(for: .MediaPreview(mediaType: .video,video: videoURL))

                   }
               }
           }
           picker.dismiss(animated: true, completion: nil)
       }

       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
       }
}
 
// MARK: Configure others stories

extension MainStoriesVC {
    private func configureOthersStoriesCollectionView() {
        othersStoriesCollectionView.registerNIB(StoryCollectionViewCell.self)
        othersStoriesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        subscribeToStoriesDate()
        didSelectOtherStories()
    }
    
    private func subscribeToStoriesDate() {
        viewModel.storiesData.bind(to: othersStoriesCollectionView.rx.items(cellIdentifier: String(describing: StoryCollectionViewCell.self), cellType: StoryCollectionViewCell.self)) { (row, item, cell) in

            if row != 0 {
                cell.update(item)
            }

        }.disposed(by: disposeBag)
    }

    private func didSelectOtherStories() {
        othersStoriesCollectionView.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self else {return}

            let vc = self.coordinator.Main.viewcontroller(for: .StoryPreview) as! StoryPreviewVC
            vc.indexPath = indexPath.row
            vc.myStoriesDate = self.viewModel.storiesData
            self.present(vc, animated: true)

        }.disposed(by: disposeBag)
    }
}

// MARK: Private Handlers

extension MainStoriesVC {
    private func subscribeToErrorMessage() {
        viewModel.errorMessageObservable.subscribe { [weak self] errorMessage in
            guard let self = self else { return }
            ToastManager.shared.showToast(message: errorMessage, view: self.view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
        }.disposed(by: disposeBag)
    }
}
