//
//  TMDb_UzmaApp.swift
//  TMDb-Uzma
//
//  Created by Uzma Sayyed on 06/03/24.
//
import Foundation
import CoreData

// MARK:- DataModel
class LatestMovDataModel {
    var movieList: [MovieInfoModel]
    
    init() {
        movieList = []
    }
}

// MARK:- ViewModel
public class LatestMovViewModel: MovieListViewModelProtocol {
    weak var viewController: MovieListViewControllerProtocol?
    private let dataModel: LatestMovDataModel
    private let managedObjectContext: NSManagedObjectContext
    private lazy var networkManager: NetworkManager = {
        return NetworkManager()
    }()
    
    init(_ moc: NSManagedObjectContext) {
        dataModel = LatestMovDataModel()
        managedObjectContext = moc
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchLatestMovieList),
                                               name: Notification.Name("LatestMovChanged"),
                                               object: nil)
    }
    
    @objc func fetchLatestMovieList() {
        let movieInfoList: () = networkManager.fetchLatestMovie { moviesList in
            DispatchQueue.main.async { [weak self] in
                self?.dataModel.movieList = []
                self?.addMovieInfoModelToMovieList(moviesList ?? [])
                self?.updateView()
            }
        }
    }

    func addMovieInfoModelToMovieList(_ modelList: [MovieInfoModel]) {
        for movieInfoModel in modelList.reversed() {
            dataModel.movieList.append(movieInfoModel)
        }
    }
    
    func updateView() {
        viewController?.updateView()
    }
    
    // MARK: MovieListViewModelProtocol
    func didTap() {
        // Does nothing
    }
    
    func loadViewInitialData() {
        fetchLatestMovieList()
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
extension LatestMovViewModel {
    func checkAndHandleIfPaginationRequired(at row: Int) {
        // Does nothing
    }
    
    func handlePaginationRequired() {
        // Does nothing
    }
}
