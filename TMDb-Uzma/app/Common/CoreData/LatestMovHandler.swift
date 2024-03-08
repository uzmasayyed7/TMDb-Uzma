//
//  TMDb_UzmaApp.swift
//  TMDb-Uzma
//
//  Created by Uzma Sayyed on 06/03/24.
//
import Foundation
import CoreData

class LatestMovHandler {
    static func clearLatestMov(moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PopularMov")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc.execute(batchDeleteRequest)
        } catch {
            print("Could not delete LatestMov entity records. \(error)")
        }
    }
    
    static func saveCurrentMovieList(_ movieInfoList: [MovieInfoModel], moc: NSManagedObjectContext) {
        LatestMovHandler.clearLatestMov(moc: moc)
        if let entity = NSEntityDescription.entity(forEntityName: "PopularMov", in: moc) {
            let latestMov = NSManagedObject(entity: entity, insertInto: moc)
            let movieListData = try? JSONEncoder().encode(movieInfoList)
            latestMov.setValue(movieListData, forKeyPath: "movieListData")
            latestMov.setValue(Date(), forKey: "timeStamp")
            
            do {
                try moc.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    static func fetchSavedLatestMovieList(in moc: NSManagedObjectContext) -> [MovieInfoModel] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PopularMov")
        do {
            let latestMov = try moc.fetch(fetchRequest)
            if latestMov.count > 0,
               let loadedMovieListData = latestMov[0].value(forKey: "movieListData") as? Data {
                if let loadedMovieList = try? JSONDecoder().decode([MovieInfoModel].self, from: loadedMovieListData) {
                    return loadedMovieList
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
}
