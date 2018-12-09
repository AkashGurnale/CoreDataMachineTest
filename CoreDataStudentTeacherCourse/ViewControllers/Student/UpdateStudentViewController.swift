//
//  UpdateStudentViewController.swift
//  CoreDataStudentTeacherCourse
//
//  Created by Akash Gurnale on 06/12/18.
//  Copyright © 2018 Akash Gurnale. All rights reserved.
//

import UIKit

enum ToggleView {
    case hide
    case show

    var isHidden: Bool {
        switch self {
        case .hide: return true
        case .show: return false
        }
    }
}

class UpdateStudentViewController: UIViewController {

    // MARK: Constants

    var student: Dictionary<String, Any>?
    var students: Array<Student>?
    var courses: Array<Course>?
    var teachers: Array<Teacher>?
    let felixApi = FelixAPI.sharedInstance
    var selectedCourse: Course?
    var selectedTeacher: Teacher?
    var studentEntity: Student?

    // MARK: IBOutlets

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var pickerContainer: UIView!
    @IBOutlet weak var coursePickerView: UIPickerView!
    @IBOutlet weak var teacherPickerView: UIPickerView!

    // MARK: Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure view
        configureView()

        // fetch records
        fetchFelixManagementRecords()
    }

    // MARK: Implementation

    private func configureView() {
        guard let student = student else {
            return
        }

        nameTextField.text = student["sname"] as? String
        addressTextView.text = student["address"] as? String
        courseLabel.text = student["cname"] as? String
        teacherLabel.text = student["tname"] as? String
    }

    private func togglePicker(containerView: ToggleView, teacherPicker: ToggleView, coursePicker: ToggleView) {
        pickerContainer.isHidden = containerView.isHidden
        coursePickerView.isHidden = coursePicker.isHidden
        teacherPickerView.isHidden = teacherPicker.isHidden
    }

    func fetchFelixManagementRecords() {
        students = felixApi.fetchStudentData()
        teachers = felixApi.fetchTeachersData()
        courses = felixApi.fetchCoursesData()
    }



    // MARK: IBActions
    
    @IBAction func doneWithPicker(_ sender: UIButton) {
        togglePicker(containerView: .hide, teacherPicker: .hide, coursePicker: .hide)
    }
    
    @IBAction func editCourse(_ sender: UIButton) {
        coursePickerView.delegate = self
        coursePickerView.dataSource = self

        togglePicker(containerView: .show, teacherPicker: .hide, coursePicker: .show)
    }

    @IBAction func editTeacher(_ sender: UIButton) {
        teacherPickerView.delegate = self
        teacherPickerView.dataSource = self
        
        togglePicker(containerView: .show, teacherPicker: .show, coursePicker: .hide)
    }
    
    @IBAction func updateStudentInfo(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext

        studentEntity?.name = nameTextField.text
        studentEntity?.address = addressTextView.text
        studentEntity?.courseId = selectedCourse?.courseId
        studentEntity?.teacherId = selectedTeacher?.teacherId
        // No need to update uuid of student

        do {
            try context?.save()

            navigationController?.popViewController(animated: true)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}


// MARK: Picker Delegate

extension UpdateStudentViewController: UIPickerViewDelegate {

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int) -> String? {

        if pickerView == coursePickerView {
            if let _ = courses {
                let course = courses![row]
                // FIXME
                courseLabel.text = course.courceName
                
                return course.courceName
            }
        } else if pickerView == teacherPickerView {
            if let _ = teachers {
                let teacher = teachers![row]
                // FIXME
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

extension UpdateStudentViewController: UIPickerViewDataSource {

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
