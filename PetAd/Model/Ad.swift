//
//  Ad.swift
//  PetAd
//
//  Created by Dominique Strachan on 2/2/23.
//

import Foundation
import CloudKit

class Ad {
    
    var title: String
    var price: Int
    var category: String
    
    init(title: String, price: Int, category: String) {
        
        self.title = title
        self.price = price
        self.category = category
    }
    
    //ad -> ckRecord - turning ad object into dictionary for CloudKit
    init?(ckRecord: CKRecord) {
        guard let title = ckRecord["title"] as? String,
              let price = ckRecord["price"] as? Int,
              let category = ckRecord["category"] as? String else { return nil}
        
        self.title = title
        self.price = price
        self.category = category
        
    }
}

//ckRecord -> ad
extension CKRecord {
    convenience init(ad: Ad) {
        self.init(recordType: "Ad")
        
        self.setValue(ad.title, forKey: "title")
        self.setValue(ad.price, forKey: "price")
        self.setValue(ad.category, forKey: "category")
            
    }
}



