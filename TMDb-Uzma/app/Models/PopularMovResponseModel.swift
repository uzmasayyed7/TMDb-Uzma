//
//  TMDb_UzmaApp.swift
//  TMDb-Uzma
//
//  Created by Uzma Sayyed on 06/03/24.
//

import Foundation

class PopularMovResponseModel: Decodable {
    let page: Int
    let results: [MovieInfoModel]
    let totalPages: Int
    let totalResults: Int
}
