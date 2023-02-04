//
//  AdController.swift
//  PetAd
//
//  Created by Dominique Strachan on 2/2/23.
//

import Foundation
import CloudKit

class AdController {
    
    static let shared = AdController()
    
    static let adsUpdatedToNotification = Notification.Name("adsWereUpdatedTo")
    
    //MARK: - Properties
    var puppyAds: [Ad] = [] {
        //property observer posting to notification center which will be called in TV controller to reload after receiving saved adds
        didSet {
            NotificationCenter.default.post(name: AdController.adsUpdatedToNotification, object: nil)
        }
    }
    
    var kittenAds: [Ad] = [] {
        //property observer posting to notification center which will be called in TV controller to reload after receiving saved adds
        didSet {
            NotificationCenter.default.post(name: AdController.adsUpdatedToNotification, object: nil)
        }
    }
    
    //public because ads are being shared between users
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //save will be called in pop up/alert action to create an ad
    func saveRecordAdToCloudKit(title: String, price: Int, category: String) {
        
        //initializing instance of ad object
        let ad = Ad(title: title, price: price, category: category)
        
        //initializing instance of ckrecord ad because can not save ad object into cloud kit without record conversion
        let record = CKRecord(ad: ad)
        
        //completion closure results in record or error
        publicDB.save(record) { record, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            //inside of closure requires self
            if category == "Puppies" {
                //appending ad object to puppysAd and kittenAd
                self.puppyAds.append(ad)
            } else {
                self.kittenAds.append(ad)
                //ads are added to source of truth, but do not appear on table view yet...create notification
            }
        }
    }
    
    func fetchRecordAdsFromCloudKit(category: String) {
        
        let predicate = NSPredicate(format: "category == %@", category)
        
        let query = CKQuery(recordType: "Ad", predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let records = records else { return }
            
            let ads = records.compactMap( { Ad(ckRecord: $0) })
            
            if category == "Puppies" {
                self.puppyAds = ads
            } else {
                self.kittenAds = ads
            }
        }
    }
    
    func subscribeToPuppyAds() {
        
        let predicate = NSPredicate(format: "category == %@", "Puppies")
        
        let subscription = CKQuerySubscription(recordType: "Ad", predicate: predicate, options: .firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "Yay!"
        notificationInfo.alertBody = "There is a new puppy ad."
        notificationInfo.soundName = "default"
        
        subscription.notificationInfo = notificationInfo
        
        publicDB.save(subscription) { _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("success")
        }
    }
    
    func subscribeToKittenAds() {
        
        let predicate = NSPredicate(format: "category == %@", "Kittens")
        
        let subscription = CKQuerySubscription(recordType: "Ad", predicate: predicate, options: .firesOnRecordUpdate)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "Yay!"
        notificationInfo.alertBody = "There is a new kitten ad."
        notificationInfo.soundName = "default"
        
        subscription.notificationInfo = notificationInfo
        
        publicDB.save(subscription) { _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("success")
        }
    }
    
}
