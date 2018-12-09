//
//  AddTeacherViewController.swift
//  CoreDataStudentTeacherCourse
//
//  Created by Akash Gurnale on 21/11/18.
//  Copyright © 2018 Akash Gurnale. All rights reserved.
//

import UIKit
import CoreData

class AddTeacherViewController: UIViewController {

    // MARK: Constant

    var appDelegate: AppDelegate?
    var teachers: [Teacher]?
    var courses: [Course]?
    var selectedCourse: Course?

    // MARK: IBOutlets

    @IBOutlet weak var teacherNameField: UITextField!
    @IBOutlet weak var teacherCoursePicker: UIPickerView!
    @IBOutlet weak var teacherAddress: UITextView!
    @IBOutlet weak var saveTeacherInfo: UIButton!


    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.shared.delegate as? AppDelegate

        fetchCourseInfo()
        selectedCourse = courses?.first
    }

    // MARK: Actions
    
    @IBAction func saveTeacherInformation(_ sender: UIButton) {
        teacherNameField.resignFirstResponder()
        teacherAddress.resignFirstResponder()

        if teacherNameField.text == "" && teacherAddress.text == "" {

        } else {

            if let context = appDelegate?.persistentContainer.viewContext {
                let teacher = Teacher(context: context)
                teacher.teacherName = teacherNameField.text
                teacher.teacherAddress = teacherNameField.text
                teacher.teacherId = Utility.generateUUID()

                if let _ = selectedCourse {
                    teacher.courseId = selectedCourse!.courseId
                }

                do {
                    try context.save()
                    navigationController?.popViewController(animated: true)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func fetchCourseInfo() {
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Course")

        do {
            courses = try context?.fetch(fetchRequest) as? Array<Course>

            if let courses = courses,
                courses.count > 0 {
                teacherCoursePicker.delegate = self
                teacherCoursePicker.dataSource = self
            }

        } catch let error {
            print(error.localizedDescription)
        }
    }

}



// MARK: Picker Delegate

extension AddTeacherViewController: UIPickerViewDelegate {

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int) -> String? {

        if let _ = courses {
            let course = courses![row]
            return course.courceName
        }

        return "None Added"
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int) {
        if let _ = courses {
            selectedCourse = courses?[row]
        }
    }

}

// MARK: Picker Data source

extension AddTeacherViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int) -> Int {
        return courses?.count ?? 0
    }

}

