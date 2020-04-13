//
//  PopoverStudentInfoTableViewController.swift
//  38HWMapKit
//
//  Created by Сергей on 02.04.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import UIKit
import MapKit

class StudentInfoTableViewController: UITableViewController {
    
    var labelNameStudent = UILabel()
    var labelSurnameStudent = UILabel()
    var labelDateOfBirthStudent = UILabel()
    var labelGenderStudent = UILabel()
    var labelCountryStudent = UILabel()
    
    var student: Student? = nil

    //MARK: UITableViewDataSourse
    
    override func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 7
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifierCell = "Cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifierCell)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifierCell)
        }
        
        let frameOfLabelStudent = CGRect(x: (cell?.bounds.maxX ?? 0) / 2, y: (cell?.bounds.minY ?? 0), width: (cell?.bounds.width ?? 0) , height: cell?.bounds.height ?? 0)
        
        switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "Name: "
                labelNameStudent.frame = frameOfLabelStudent
                labelNameStudent.text = student?.name
                cell?.addSubview(labelNameStudent)
            case 1:
                cell?.textLabel?.text = "Surname: "
                labelSurnameStudent.frame = frameOfLabelStudent
                labelSurnameStudent.text = student?.surname
                cell?.addSubview(labelSurnameStudent)
            case 2:
                cell?.textLabel?.text = "Date Of Birth: "
                labelDateOfBirthStudent.frame = frameOfLabelStudent
                labelDateOfBirthStudent.text =
                student?.dateOfBirth.stringFromDateWithString(format: "MM/dd/yyy")
                cell?.addSubview(labelDateOfBirthStudent)
            case 3:
                cell?.textLabel?.text = "Gender: "
                labelGenderStudent.frame = frameOfLabelStudent
                labelGenderStudent.text = student?.gender.rawValue
                cell?.addSubview(labelGenderStudent)
            case 4:
                cell?.textLabel?.text = "Country: "
                labelCountryStudent.frame = frameOfLabelStudent
                labelCountryStudent.numberOfLines = 2
                labelCountryStudent.text = student?.address.country
                cell?.addSubview(labelCountryStudent)
            case 5:
                cell?.textLabel?.text = "City: "
                let labelCityStudent = UILabel(frame: frameOfLabelStudent)
                labelCityStudent.text = student?.address.city
                cell?.addSubview(labelCityStudent)
            case 6:
                cell?.textLabel?.text = "Street: "
                let labelStreetStudent = UILabel(frame: frameOfLabelStudent)
                labelStreetStudent.text = student?.address.street
                cell?.addSubview(labelStreetStudent)
            default:
                    break
        }
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Informaion Of Student"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}


extension StudentInfoTableViewController: StudentInfoTableViewControllerDelegate {
    func get(student: Student?) {
        self.student = student
    }
    
    
}
