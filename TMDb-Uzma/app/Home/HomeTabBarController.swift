//
//  HomeTabBarController.swift
//  TMDb-Uzma
//
//  Created by Uzma Sayyed on 07/03/24.
//

import Foundation
import CoreData
import SwiftUI

class HomeTabBarController: UITabBarController {
    init(_ viewContext: NSManagedObjectContext) {
        super.init(nibName: nil, bundle: nil)
        
        let popularMovVC = PopularMoviesViewController(viewContext)
        let latestMovVC = LatestMovViewController(viewContext)

        let popularMovTabBarItem = UITabBarItem(title: "Popular Movies", image: UIImage(systemName: "flame.fill"), tag: 0)
        let latestMovTabBarItem = UITabBarItem(title: "Latest Movies", image: UIImage(systemName: "clock.fill"), tag: 1)

        popularMovVC.tabBarItem = popularMovTabBarItem
        latestMovVC.tabBarItem = latestMovTabBarItem
        self.viewControllers = [popularMovVC, latestMovVC]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
