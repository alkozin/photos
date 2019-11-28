//
//  RootViewController.swift
//  Photos
//
//  Created by Alex Kozin on 19.06.16.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import UIKit

import SwipeCellKit

class MainViewController: PrefetchingCollectionItemsController<Photo> {

    enum State {
        case Default, Search
    }

    var state = State.Default {
        didSet {
            switchToState()
        }
    }

    var api: PagedAPI!

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
        loadPhotos()
    }

    func prepareUI() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
    }


    func loadPhotos() {
        collectionView.scrollToTop(true)

        api = PhotosAPI { [weak self] photos in
            self?.show(photos, for: .Default)
        }
    }

    func searchPhotos(by query: String) {
        collectionView.scrollToTop(true)

        api = SearchPhotosAPI(query) { [weak self] photos in
            self?.show(photos, for: .Search)
        }
    }

    func show(_ photos: [Photo], for state: State) {
        if self.state != state {
            items.removeAll()
        }

        items = items + photos

        DispatchQueue.main.async {
            self.state = state
            self.reloadView()
        }

    }

    func switchToState() {
        switch state {
            case .Default:
                switchToDefault()
            case .Search:
                switchToSearch()
        }
    }

    func switchToDefault() {
        let cellWidth = view.frame.width / 3

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)

        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.hidesBarsOnSwipe = true
    }

    func switchToSearch() {
        let cellWidth = view.frame.width

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)

        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.hidesBarsOnSwipe = false
    }

    override func requestItem(at indexPath: IndexPath) {
        //Collection view always requests at maximum last item in collection
        //So add half of the page to request
        //And compare that index with items we already have
        //Request more if we don't have enough
        if items.count - 1 - 5 < indexPath.row {
            api.requestNextPage()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! PhotoCell
        cell.delegate = self
        return cell
    }

}

extension MainViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text, query.count > 3 else {
            if state == .Search {
                loadPhotos()
            }
            return
        }

        searchPhotos(by: query)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadPhotos()
    }

}

extension MainViewController: SwipeCollectionViewCellDelegate {

    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructiveAfterFill

        return options
    }

    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        guard state == .Search else {
            return nil
        }

        let action = SwipeAction(style: .default, title: "Удалить") { [weak self] action, indexPath in
            self?.deleteItem(at: indexPath)
        }
        action.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        action.backgroundColor = UIColor.red
        action.hidesWhenSelected = true

        return [action]
    }

    func deleteItem(at indexPath: IndexPath) {
        var items = self.items
        items.remove(at: indexPath.row)
        self.items = items
    }
    
}
