//
//  TMDb_UzmaApp.swift
//  TMDb-Uzma
//
//  Created by Uzma Sayyed on 06/03/24.
//

import Foundation
import CoreData
import SwiftUI

class PopularMoviesViewController: MovieListViewController {
    override init(_ managedObjectContext: NSManagedObjectContext) {
        super.init(managedObjectContext)
        viewModel = PopularMovViewModel(managedObjectContext)
        viewModel.viewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
