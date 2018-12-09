//
//  AddStudentViewController.swift
//  CoreDataStudentTeacherCourse
//
//  Created by Akash Gurnale on 26/11/18.
//  Copyright © 2018 Akash Gurnale. All rights reserved.
//

import UIKit
import CoreData

class AddStudentViewController: UIViewController {

    // MARK: Constants

    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var addCourseButton: UIButton!
    @IBOutlet weak var addTeacherButton: UIButton!
    @IBOutlet weak var pickerContainer: UIView!
    @IBOutlet weak var teacherPickerView: UIPickerView!
    @IBOutlet weak var coursePickerView: UIPickerView!
    @IBOutlet weak var donePickerButton: UIButton!

    var appDelegate: AppDelegate?
    var teachers: [Teacher]?
    var courses: [Course]?
    var selectedCourse: Course?
    var selectedTeacher: Teacher?



    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.shared.delegate as? AppDelegate

        // Configure view
        configurePickerView()

        // Fetch Courses
        fetchCourses()

        // Fetch Teachers
        fetchTeachers()
    }

    // MARK: Actions

    @IBAction func addCourseAndTeacher(_ sender: UIButton) {
        if sender == addCourseButton {
            coursePickerView.delegate = self
            coursePickerView.dataSource = self

            pickerContainer.isHidden = false
            coursePickerView.isHidden = false
            teacherPickerView.isHidden = true
        } else if sender == addTeacherButton {
            teacherPickerView.delegate = self
            teacherPickerView.dataSource = self

            pickerContainer.isHidden = false
            coursePickerView.isHidden = true
            teacherPickerView.isHidden = false
        }
    }

    @IBAction func saveStudentInfo(_ sender: UIButton) {
        nameTxtField.resignFirstResponder()
        addressTextView.resignFirstResponder()

        if nameTxtField.text == "" && addressTextView.text == "" {

        } else {

            if let context = appDelegate?.persistentContainer.viewContext {
                let student = Student(context: context)
                student.name = nameTxtField.text
                student.address = addressTextView.text

                if let _ = selectedCourse,
                    let _ = selectedTeacher {
                    student.courseId = selectedCourse!.courseId
                    student.teacherId = selectedTeacher?.teacherId
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

    @IBAction func doneWithChangingPickerValue(_ sender: UIButton) {
        pickerContainer.isHidden = true
        coursePickerView.isHidden = true
        teacherPickerView.isHidden = true
    }

    // MARK: Helpers

    func fetchCourses() {
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Course")

        do {
            courses = try context?.fetch(fetchRequest) as? Array<Course>
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func fetchTeachers() {
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Teacher")

        do {
            teachers = try context?.fetch(fetchRequest) as? Array<Teacher>
        } catch let error {
            print(error.localizedDescription)
        }

    }

    func configurePickerView() {
        // border radius
        pickerContainer.layer.cornerRadius = 30

        // border
        pickerContainer.layer.borderColor = UIColor.black.cgColor
        pickerContainer.layer.borderWidth = 1

        // drop shadow
        pickerContainer.layer.shadowColor = UIColor.black.cgColor
        pickerContainer.layer.opacity = 0.8
        pickerContainer.layer.shadowRadius = 3.0
        pickerContainer.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        pickerContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
    }
}


// MARK: Picker Delegate

extension AddStudentViewController: UIPickerViewDelegate {

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int) -> String? {

        if pickerView == coursePickerView {
            if let _ = courses {
                let course = courses![row]
                courseLabel.text = course.courceName

                return course.courceName
            }
        } else if pickerView == teacherPickerView {
            if let _ = teachers {
                let teacher = teachers![row]
                teacherLabel.text = teacher.teacherName

                return teacher.teacherName
            }
        }

        return "None Added"
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int) {
        if pickerView == coursePickerView {
            selectedCourse = courses?[row]
        } else if pickerView == teacherPickerView {
            selectedTeacher = teachers?[row]
        }
    }

}

// MARK: Picker Data source

extension AddStudentViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int) -> Int {
        if pickerView == coursePickerView {
            return courses?.count ?? 0
        } else {
            return teachers?.count ?? 0
        }
    }

}

