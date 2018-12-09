//
//  CourseListViewController.swift
//  CoreDataStudentTeacherCourse
//
//  Created by Akash Gurnale on 20/11/18.
//  Copyright © 2018 Akash Gurnale. All rights reserved.
//

import UIKit
import CoreData

class CourseListViewController: UIViewController {

    // MARK: Constants

    var courseList: Array<Course>?
    let felixApi = FelixAPI.sharedInstance

    // MARK: IBOutlets

    @IBOutlet weak var courseTableView: UITableView!

    
    // MARK: Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure view
        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchCourseList()
    }

    // MARK: Helper

    func configureView() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Course List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.add,
            target: self,
            action: #selector(addCourse))

        //courseTableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    func fetchCourseList() {
        courseList = felixApi.fetchCoursesData()

        if let list = courseList,
            list.count > 0 {
            courseTableView.dataSource = self
            courseTableView.delegate = self
            courseTableView.reloadData()
        }
    }

    // MARK: Actions

    @objc func addCourse() {
        let addCourseViewController: AddCourseViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddCourseViewController") as! AddCourseViewController
        navigationController?.pushViewController(addCourseViewController, animated: true)
    }

}

// MARK: Delegate

extension CourseListViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath) {

        if editingStyle == UITableViewCellEditingStyle.delete {
            if let _ = courseList {
                felixApi.deleteCourseData(course: courseList![indexPath.row])
                courseList?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        }
    }
}


// MARK: Data Source

extension CourseListViewController: UITableViewDataSource {

    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return courseList?.count ?? 0
    }

    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseListCell")

        if let list = courseList {
            let course = list[indexPath.row]
            cell?.textLabel?.text = course.courceName
            cell?.detailTextLabel?.text = course.courceDetails
        }

        return cell!
    }

}
