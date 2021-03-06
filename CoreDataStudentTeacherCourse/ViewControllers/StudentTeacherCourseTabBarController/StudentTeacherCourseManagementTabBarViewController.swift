//
//  StudentTeacherCourseManagementTabBarViewController.swift
//  CoreDataStudentTeacherCourse
//
//  Created by Akash Gurnale on 04/12/18.
//  Copyright © 2018 Akash Gurnale. All rights reserved.
//

import UIKit

class StudentTeacherCourseManagementTabBarViewController: UITabBarController {

    // MARK: Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
    }
}

// MARK: TabBarViewController delegate

extension StudentTeacherCourseManagementTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let navigationController = viewController as? UINavigationController
        navigationController?.popToRootViewController(animated: false)
    }
}
