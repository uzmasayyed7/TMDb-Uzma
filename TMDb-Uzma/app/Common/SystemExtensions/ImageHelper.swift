//
//  TMDb_UzmaApp.swift
//  TMDb-Uzma
//
//  Created by Uzma Sayyed on 06/03/24.
//

import Foundation
import SwiftUI
import Nuke

class ImageHelper {
    static func setupImageForView(_ imageView: UIImageView, url: String?) {
        let moviePosterPath = url ?? ""
        let request = ImageRequest(url: URL(string: "https://image.tmdb.org/t/p/w500\(moviePosterPath)")!, processors: [
            ImageProcessors.RoundedCorners(radius: 16)
        ])
        
        let options = ImageLoadingOptions(placeholder: UIImage(named: "cup"),
                                          transition: .fadeIn(duration: 0.33),
                                          failureImage: UIImage(named: "cup"),
                                          contentModes: .init(success: .scaleAspectFit, failure: .scaleAspectFit, placeholder: .scaleAspectFit))
        
        Nuke.loadImage(with: request, options: options, into: imageView)
    }
}
