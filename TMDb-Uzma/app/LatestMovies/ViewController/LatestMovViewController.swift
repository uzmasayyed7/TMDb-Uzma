//
//  TMDb_UzmaApp.swift
//  TMDb-Uzma
//
//  Created by Uzma Sayyed on 06/03/24.
//

import Foundation
import CoreData

class LatestMovViewController: MovieListViewController {
    override init(_ managedObjectContext: NSManagedObjectContext) {
        super.init(managedObjectContext)
        viewModel = LatestMovViewModel(managedObjectContext)
        viewModel.viewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
