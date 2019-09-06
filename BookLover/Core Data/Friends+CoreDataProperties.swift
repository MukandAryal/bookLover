//
//  Friends+CoreDataProperties.swift
//  
//
//  Created by ios 7 on 15/06/18.
//
//

import Foundation
import CoreData


extension Friends {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friends> {
        return NSFetchRequest<Friends>(entityName: "Friends")
    }

    @NSManaged public var age: Int16
    @NSManaged public var categories: [[String:Any]]?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var ffriend_id: Int16
    @NSManaged public var firstname: String?
    @NSManaged public var gender: String?
    @NSManaged public var id: Int16
    @NSManaged public var lastname: String?
    @NSManaged public var state: String?
    @NSManaged public var user_image: String?
    @NSManaged public var weightage: Int16

}
