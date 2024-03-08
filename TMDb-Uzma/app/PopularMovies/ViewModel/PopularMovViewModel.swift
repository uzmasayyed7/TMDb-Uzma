//
//  TMDb_UzmaApp.swift
//  TMDb-Uzma
//
//  Created by Uzma Sayyed on 06/03/24.
//

import Foundation
import CoreData

// MARK:- DataModel
class PopularMovViewDataModel {
    var movieList: [MovieInfoModel]
    var currentPageNumber: Int
    var totalPages: Int
    
    init() {
        movieList = []
        currentPageNumber = 0
        totalPages = 100 // default upper limit
    }
}

// MARK:- ViewModel
public class PopularMovViewModel: MovieListViewModelProtocol {
    weak var viewController: MovieListViewControllerProtocol?
    private var isLoading: Bool
    private let dataModel: PopularMovViewDataModel
    private let managedObjectContext: NSManagedObjectContext
    private lazy var networkManager: NetworkManager = {
        return NetworkManager()
    }()
    
    init(_ moc: NSManagedObjectContext) {
        dataModel = PopularMovViewDataModel()
        managedObjectContext = moc
        isLoading = true
    }

    func fetchPopularMovData() {
        networkManager.fetchPopularMov(page: 1) { (popularMovResponseModel) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let popularMovModel = popularMovResponseModel else {
                    self.updateViewWithCachedMovieList()
                    return
                }
                self.handleLatestMovResult(latestMovModel: popularMovModel)
            }
        }
    }

    func fetchNextfetchPopularMovData() {
        networkManager.fetchPopularMov(page: dataModel.currentPageNumber+1) { (latestMovResponseModel) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let latestMovModel = latestMovResponseModel else {
                    self.isLoading = false
                    return
                }
                self.handleLatestMovResult(latestMovModel: latestMovModel)
            }
        }
    }

    func handleLatestMovResult(latestMovModel: PopularMovResponseModel) {
        handlePageDetails(latestMovModel: latestMovModel)
        addMovieInfoModelToMovieList(latestMovModel.results)
        
        updateView()
        LatestMovHandler.saveCurrentMovieList(dataModel.movieList, moc: managedObjectContext)
    }
    
    func handlePageDetails(latestMovModel: PopularMovResponseModel) {
        updateLastFetchedPageNumber(latestMovModel)
    }
    
    func addMovieInfoModelToMovieList(_ modelList: [MovieInfoModel]) {
        for movieInfoModel in modelList {
            dataModel.movieList.append(movieInfoModel)
        }
    }
    
    func updateLastFetchedPageNumber(_ latestMovModel: PopularMovResponseModel) {
        dataModel.currentPageNumber = latestMovModel.page
        dataModel.totalPages = latestMovModel.totalPages
        print("\(dataModel.currentPageNumber) out of \(dataModel.totalPages)")
    }
    
    func updateViewWithCachedMovieList() {
        let movieModelList = LatestMovHandler.fetchSavedLatestMovieList(in: managedObjectContext)
        addMovieInfoModelToMovieList(movieModelList)
        updateView()
    }
    
    func updateView() {
        isLoading = false
        viewController?.updateView()
    }
    
    // MARK: MovieListViewModelProtocol
    func didTap() {
        // Does nothing
    }
    
    func loadViewInitialData() {
        fetchPopularMovData()
    }
    
    func moviesCount() -> Int {
        return dataModel.movieList.count
    }
    
    func movieInfoModel(at index: Int) -> MovieInfoModel? {
        return dataModel.movieList[index]
    }
    
    func currentMOC() -> NSManagedObjectContext {
        return managedObjectContext
    }
}

// MARK:- Pagination
extension PopularMovViewModel {
    func checkAndHandleIfPaginationRequired(at row: Int) {
        if (row + 1 == dataModel.movieList.count) && (dataModel.currentPageNumber != dataModel.totalPages) {
            handlePaginationRequired()
        }
    }
    
    func handlePaginationRequired() {
        if !isLoading && dataModel.currentPageNumber != 0 {
            isLoading = true
            fetchNextfetchPopularMovData()
        }
    }
}
