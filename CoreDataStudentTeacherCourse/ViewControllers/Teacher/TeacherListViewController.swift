//
//  TeacherListViewController.swift
//  CoreDataStudentTeacherCourse
//
//  Created by Akash Gurnale on 21/11/18.
//  Copyright © 2018 Akash Gurnale. All rights reserved.
//

import UIKit
import CoreData

class TeacherListViewController: UIViewController {

    // MARK: Constant

    var teachersInfo: Array<Teacher>?
    var courseInfo: Array<Course>?
    var teacherCourseInfo: Array<Dictionary<String, Any>>?
    let felixApi = FelixAPI.sharedInstance

    // MARK: IBOutlets

    @IBOutlet weak var teacherTableView: UITableView!


    // MARK: Life cycle method

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        // Core Data
        fetchTeachersData()
        fetchCoursesData()
        formRelationShip()
    }

    // MARK: Helper

    func configureView() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Teacher List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.add,
            target: self,
            action: #selector(addTeacher))

        //teacherTableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    // MARK: Actions

    @objc func addTeacher() {
        let addTeacherViewController: AddTeacherViewController = storyboard?.instantiateViewController(withIdentifier: "AddTeacherViewController") as! AddTeacherViewController

        navigationController?.pushViewController(addTeacherViewController, animated: true)
    }

    func fetchTeachersData() {
        teachersInfo = felixApi.fetchTeachersData()
    }

    func fetchCoursesData() {
        courseInfo = felixApi.fetchCoursesData()
    }

    func formRelationShip() {

        if let _ = teachersInfo,
            let _ = courseInfo {

            teacherCourseInfo = Array<Dictionary<String, Any>>()

            for teacher in teachersInfo! {

                for course in courseInfo! {
                    if course.courseId == teacher.courseId {
                        var dict = Dictionary<String, Any>()
                        dict["cname"] = course.courceName
                        dict["tname"] = teacher.teacherName
                        teacherCourseInfo?.append(dict)
                        //print(teacherCourseInfo?.count)
                    }
                }
            }

            if let _ = teacherCourseInfo,
                teacherCourseInfo!.count > 0 {
                teacherTableView.delegate = self
                teacherTableView.dataSource = self
                teacherTableView.reloadData()
            }
        }
    }
}


// MARK: Delegate

extension TeacherListViewController: UITableViewDelegate {
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
            if let _ = teacherCourseInfo,
                let _ = teachersInfo {
                felixApi.deleteTeacherData(teacher: teachersInfo![indexPath.row])
                teacherCourseInfo?.remove(at: indexPath.row)
                teachersInfo?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        }
    }
}


// MARK: Data Source

extension TeacherListViewController: UITableViewDataSource {

    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return teacherCourseInfo?.count ?? 0
    }

    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherListCell")

        if let _ = teacherCourseInfo {
            let teacherAndCourseDict = teacherCourseInfo![indexPath.row]
            cell?.textLabel?.text = teacherAndCourseDict["tname"] as? String
            cell?.detailTextLabel?.text = teacherAndCourseDict["cname"] as? String
        }

        return cell!
    }

}
