//
//  TMDb_UzmaApp.swift
//  TMDb-Uzma
//
//  Created by Uzma Sayyed on 06/03/24.
//

import Foundation
import CoreData

class LatestMovMOHandler {
    static func clearLatestMovMO(moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LatestMovMO")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc.execute(batchDeleteRequest)
            NotificationCenter.default.post(name: Notification.Name("LatestMovChanged"), object: nil)
        } catch {
            print("Could not delete LatestMovMO entity records. \(error)")
        }
    }
    
    static func removeMovieInfoObjectFromLatestMov(_ movieInfo: MovieInfoModel, moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LatestMovMO")
        fetchRequest.predicate = NSPredicate(format: "movieId == \(movieInfo.id)")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc.execute(batchDeleteRequest)
            NotificationCenter.default.post(name: Notification.Name("LatestMovChanged"), object: nil)
        } catch {
            print("Could not delete LatestMovMO entity record for id: \(movieInfo.id) \(error)")
        }
    }
    
    static func addMovieInfoObjectToLatestMov(_ movieInfo: MovieInfoModel, moc: NSManagedObjectContext) {
        if checkMovieInfoExistsInLatestMov(movieInfo, moc: moc) { return }
        if let entity = NSEntityDescription.entity(forEntityName: "LatestMovMO", in: moc) {
            let latestMovMO = NSManagedObject(entity: entity, insertInto: moc)
            let movieInfoData = try? JSONEncoder().encode(movieInfo)
            latestMovMO.setValue(movieInfoData, forKeyPath: "movieInfoData")
            latestMovMO.setValue(Date(), forKey: "timeStamp")
            latestMovMO.setValue(movieInfo.id, forKey: "movieId")
            
            do {
                try moc.save()
                NotificationCenter.default.post(name: Notification.Name("LatestMovChanged"), object: nil)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    static func checkMovieInfoExistsInLatestMov(_ movieInfo: MovieInfoModel, moc: NSManagedObjectContext) -> Bool {
        let latestMov = fetchLatestMovieInfoList(moc: moc)
        for item in latestMov {
            if item.id == movieInfo.id {
                return true
            }
        }
        return false
    }
    
    static func fetchLatestMovieInfoList(moc: NSManagedObjectContext) -> [MovieInfoModel] {
        var fetchedMovieInfoList: [MovieInfoModel] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LatestMovMO")
        do {
            let latestMovMOResult = try moc.fetch(fetchRequest)
            for loadedLatestMovObject in latestMovMOResult {
                if let loadedMovieInfoData = loadedLatestMovObject.value(forKey: "movieInfoData") as? Data,
                   let loadedMovieInfoModel = try? JSONDecoder().decode(MovieInfoModel.self, from: loadedMovieInfoData) {
                    fetchedMovieInfoList.append(loadedMovieInfoModel)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return fetchedMovieInfoList
    }
}
