//
//  SearchViewController.swift
//  FlickrDemo
//
//  Created by muralis on 1/23/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    lazy var viewModal: SearchViewModal = SearchViewModal()
    lazy var dataSource: SearchDataSource = SearchDataSource(viewModal)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModal.searchView = self
        self.collectionView.dataSource = self.dataSource
        self.collectionView.delegate = self.dataSource
        self.collectionView.prefetchDataSource = self.dataSource
        // Do any additional setup after loading the view.
        self.collectionView.setCollectionViewLayout(PhotoLayout(), animated: true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchViewController: UISearchBarDelegate {
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.viewModal.query = searchBar.text ?? ""
    }
}

extension SearchViewController: SearchView {
    
    // fetch the cell at index
    func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        return self.collectionView.cellForItem(at:indexPath)
    }
    
    // get all visible indexes
    var indexPathsForVisibleItems: [IndexPath] {
        return self.collectionView.indexPathsForVisibleItems
    }
    
    // reload the collectionview
    func reloadData() {
        self.collectionView.reloadData()
    }
    
    func reloadItems(at indexPaths: [IndexPath]) {
        self.collectionView.reloadItems(at: indexPaths)
    }
    
    // progress
    func update(state: State) {
        if state ==  .progress{
            self.loadingView.startAnimating()
        } else {
            self.loadingView.stopAnimating()
        }
    }
}

