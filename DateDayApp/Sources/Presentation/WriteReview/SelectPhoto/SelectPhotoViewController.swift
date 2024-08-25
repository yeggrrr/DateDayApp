//
//  SelectPhotoViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class SelectPhotoViewController: UIViewController {
    // MARK: UI
    let selectPhotoView = SelectPhotoView()
    
    // MARK: Properties
    private var selections = [String : PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    var selectedImages = PublishSubject<[UIImage]>()
    var selectedImageList: [UIImage] = []
    let viewModel = SelectPhotoViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = selectPhotoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    private func configure() {
        // navigation
        navigationItem.rightBarButtonItem = rightBarButtonItem()
        navigationItem.title = "사진 선택"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        
        // collectionView
        selectPhotoView.collectionView.register(SelectPhotoCell.self, forCellWithReuseIdentifier: SelectPhotoCell.id)
        selectPhotoView.collectionView.showsHorizontalScrollIndicator = false
        selectPhotoView.collectionView.isPagingEnabled = true
    }
    
    private func bind() {
        let input = SelectPhotoViewModel.Input(addImageButtonTap: selectPhotoView.AddImageButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.addImageButtonTap
            .bind(with: self) { owner, _ in
                owner.presentPicker()
            }
            .disposed(by: disposeBag)
        
        selectedImages
            .bind(to: selectPhotoView.collectionView.rx.items(cellIdentifier: SelectPhotoCell.id, cellType: SelectPhotoCell.self)) { (row, element, cell) in
                cell.selectedImageView.image = element
            }
            .disposed(by: disposeBag)
    }
    
    private func rightBarButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        button.rx.tap
            .bind(with: self) { owner, _ in
                let vc = WriteViewController()
                vc.selectedImageList = owner.selectedImageList
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: button)
    }
    
    private func presentPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = PHPickerFilter.any(of: [.images])
        config.selectionLimit = 5
        config.selection = .ordered
        config.preferredAssetRepresentationMode = .current
        config.preselectedAssetIdentifiers = selectedAssetIdentifiers
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    private func displayImage() {
        let dispatchGroup = DispatchGroup()
        
        var imagesDict = [String : UIImage]()
        var imageList: [UIImage] = []
        
        for (identifier, result) in selections {
            
            dispatchGroup.enter()
            
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    guard let image = image as? UIImage else { return }
                    imagesDict[identifier] = image
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            
            for identifier in self.selectedAssetIdentifiers  {
                guard let image = imagesDict[identifier] else { return }
                imageList.append(image)
                selectedImageList.removeAll()
                selectedImageList.append(contentsOf: imageList)
                selectedImages.onNext(imageList)
            }
        }
    }
}

// MARK: PHPickerViewControllerDelegate
extension SelectPhotoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        dismiss(animated: true)
        
        var newSelections = [String : PHPickerResult]()
        
        for result in results {
            guard let identifier = result.assetIdentifier else { return }
            newSelections[identifier] = selections[identifier] ?? result
        }
        
        selections = newSelections
        selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
        
        if selections.isEmpty {
            selectedImages.onNext([])
        } else {
            displayImage()
        }
    }
}
