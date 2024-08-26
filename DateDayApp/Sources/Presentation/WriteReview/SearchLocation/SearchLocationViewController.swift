//
//  SearchLocationViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/24/24.
//

import UIKit
import RxSwift
import RxCocoa

struct SelectData {
    let placeName: String
    let categoryName: String
    let placeURL: String
    let longitude: String
    let latitude: String
}

final class SearchLocationViewController: UIViewController {
    // MARK: UI
    private let searchLocationView = SearchLocationView()
    
    // MARK: Properties
    private let viewModel = SearchLocationViewModel()
    private let disposeBag = DisposeBag()
    weak var delegate: SelectDataDelegate?
    
    // MARK: View Life Cycle
    override func loadView() {
        view = searchLocationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    // MARK: Functions
    private func configure() {
        searchLocationView.tableView.register(SearchLocationCell.self, forCellReuseIdentifier: SearchLocationCell.id)
        searchLocationView.tableView.rowHeight = 100
    }
    
    private func bind() {
        let input = SearchLocationViewModel.Input(
            searchButtonTap: searchLocationView.searchBar.rx.searchButtonClicked,
            searchText: searchLocationView.searchBar.rx.text.orEmpty,
            tableViewModelSelected: searchLocationView.tableView.rx.modelSelected(SearchLocationModel.Documents.self))
        
        let output = viewModel.transform(input: input)
        
        output.searchResult
            .bind(to: searchLocationView.tableView.rx.items(cellIdentifier: SearchLocationCell.id, cellType: SearchLocationCell.self)) { (row, element, cell) in
                cell.addressLabel.text = element.addressName
                cell.categoryLabel.text = element.categoryName
                cell.placeNameLabel.text = element.placeName
            }
            .disposed(by: disposeBag)

        output.tableViewModelSelected
            .bind(with: self) { owner, value in
                
                let selectData = SelectData(
                    placeName: owner.removeSpacing(placeName: value.placeName),
                    categoryName: value.categoryName,
                    placeURL: value.placeURL,
                    longitude: value.x,
                    latitude: value.y)
                
                owner.delegate?.sendSelectedData(selectedData: selectData)
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func removeSpacing(placeName: String) -> String {
        let removeSpacing = placeName
            .components(separatedBy: " ")
            .joined()
        return removeSpacing
    }
}

protocol SelectDataDelegate: AnyObject {
    func sendSelectedData(selectedData: SelectData)
}
