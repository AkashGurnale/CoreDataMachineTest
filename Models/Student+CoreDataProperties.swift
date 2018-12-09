//
//  Student+CoreDataProperties.swift
//  CoreDataStudentTeacherCourse
//
//  Created by Akash Gurnale on 20/11/18.
//  Copyright © 2018 Akash Gurnale. All rights reserved.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var name: String?
    @NSManaged public var courseId: UUID?
    @NSManaged public var teacherId: UUID?
    @NSManaged public var address: String?

}
