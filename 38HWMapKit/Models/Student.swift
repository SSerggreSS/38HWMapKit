//
//  Studet.swift
//  38HWMapKit
//
//  Created by Сергей on 31.03.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation
import MapKit

//Ученик.
//
//1. Создайте массив из 10 - 30 рандомных студентов, прямо как раньше, только в этот раз пусть у них наряду с именем и фамилией будет еще и координата. Можете использовать структуру координаты, а можете просто два дабла - лонгитюд и латитюд.
//
//2. Координату генерируйте так, установите центр например в вашем городе и просто генерируйте небольшие отрицательные либо положительные числа, чтобы рандомно получалась координата от центра в пределах установленного радиуса.
//
//(Ну а если совсем не получается генерировать координату, то просто ставьте им заготовленные координаты - это не главное)
//
//3. После того, как вы сгенерировали своих студентов, покажите их всех на карте, причем в титуле пусть будет Имя и Фамилия а в сабтитуле год рождения. Можете для каждого студента создать свою аннотацию, а можете студентов подписать на протокол аннотаций и добавить их на карту напрямую - как хотите :)


enum Gender: String {
    
    case male = "Male"
    case female = "Female"
    
    static var randomGender: Gender {
        let randomBool = Bool.random()
        return randomBool ? Gender.male : Gender.female
    }
}

class Student: MKAnnotationView, MKAnnotation {
    
    //MARK: Properties
    let name: String
    let surname: String
    let gender: Gender
    let dateOfBirth: Date
    var address = (country: "", city: "", street: "")
    var location: CLLocation? = nil
    var percentageOfProbability: Int? = nil
    
    
    //MARK: MKAnnotation
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var title: String? = "Hello i am student🙂"
    var subtitle: String? = "I search route place meet classmates"
    
    var isComing: Bool {
        
        let percents = percentageOfProbability ?? 0
        
        if percents == 0 {
            return false
        }
        
        var arrayOfProbabilities = [Bool]()
        
        switch percents {
            case 1...10:
                arrayOfProbabilities = Bool.makeArrayWith(countFalse: 9, countTrue: 1)
                return arrayOfProbabilities.randomElement() ?? false
            case 11...20:
                arrayOfProbabilities = Bool.makeArrayWith(countFalse: 8, countTrue: 2)
                return arrayOfProbabilities.randomElement() ?? false
            case 21...30:
                arrayOfProbabilities = Bool.makeArrayWith(countFalse: 7, countTrue: 3)
                return arrayOfProbabilities.randomElement() ?? false
            case 31...40:
                arrayOfProbabilities = Bool.makeArrayWith(countFalse: 6, countTrue: 4)
                return arrayOfProbabilities.randomElement() ?? false
            case 41...50:
                arrayOfProbabilities = Bool.makeArrayWith(countFalse: 5, countTrue: 5)
                return arrayOfProbabilities.randomElement() ?? false
            case 51...60:
                arrayOfProbabilities = Bool.makeArrayWith(countFalse: 4, countTrue: 6)
                return arrayOfProbabilities.randomElement() ?? false
            case 61...70:
                arrayOfProbabilities = Bool.makeArrayWith(countFalse: 3, countTrue: 7)
                return arrayOfProbabilities.randomElement() ?? false
            case 71...80:
                arrayOfProbabilities = Bool.makeArrayWith(countFalse: 2, countTrue: 8)
                return arrayOfProbabilities.randomElement() ?? false
            case 81...90:
                arrayOfProbabilities = Bool.makeArrayWith(countFalse: 1, countTrue: 9)
                return arrayOfProbabilities.randomElement() ?? false
            default:
                break
        }
        return false
    }
    
    
    
    init(name: String,  surname: String, gender: Gender, dateOfBirth: Date) {
        self.name = name
        self.surname = surname
        self.gender = gender
        self.dateOfBirth = dateOfBirth
        super.init(annotation: nil, reuseIdentifier: nil)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        self.name = Student.randomName
        self.surname = Student.randomSuraname
        self.gender = Gender.randomGender
        self.dateOfBirth = Date.randomDate(from: 1990, before: 2000)
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        image = self.gender == .male ? UIImage(named: "male") : UIImage(named: "female")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var randomName: String {
        let randName = Student.names[Int.random(in: 0...names.count - 1)]
        return randName
    }
    
    static var randomSuraname: String {
        let randSurname = Student.lastNames[Int.random(in: 0...lastNames.count - 1)]
        return randSurname
    }
    
    static let names = ["Mason", "Ethan", "Logan", "Lucas", "Jackson",
                        "Aiden", "Oliver", "Jacob", "Madison", "Liam",
                        "Emma", "Olivia", "Ava", "Sophia", "Isabella",
                        "Mia", "Charlotte", "Amelia", "Emily", "Sofia",
                        "Daniel", "Ellie", "Carter", "Aubrey", "Gabriel",
                        "Scarlett", "Henry", "Zoey", "Matthew","Hannah"]
    
    static let lastNames = ["Johnson", "Williams", "Jones", "Brown", "Davis",
                            "Miller", "Wilson", "Moore", "Taylor", "Anderson",
                            "Thomas", "Jackson", "White", "Harris", "Martin",
                            "Thompson", "Wood", "Lewis", "Scott", "Hill",
                            "Cooper", "King", "Green", "Walker", "Edwards",
                            "Turner", "Morgan", "Baker", "Hill", "Phillips"]
    
    static func randomStudents(inCoord: CLLocationCoordinate2D, inRadius: CLLocationDistance) -> [Student] {
        var students = [Student]()
    
        let randomNumbers = Int.randomNotRepeatNumber(in: 0...names.count - 1)
        
        for i in randomNumbers {
            
            let gender = Bool.random() ? Gender.male : Gender.female
            let date = Date.randomDate(from: 1990, before: 2000)
            let imageStud = gender == .male ? UIImage(named: "male")! : UIImage(named: "female")!
            let student = Student(name: names[i], surname: lastNames[i], gender: gender, dateOfBirth: date)
            student.title = "My name \(student.name)"
            student.image = imageStud
            student.coordinate = inCoord.randCoordIn(radius: inRadius)
            students.append(student)
        }
        
        students.sort { (studentFirst, studentSecond) -> Bool in
            return studentFirst.surname < studentSecond.surname
        }

        return students
    }
    
    func descriptionStud() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let strFromDate = dateFormatter.string(from: dateOfBirth)
        
        print("name: \(name), surname: \(surname), gender: \(gender.rawValue), dateOfBirth: \(strFromDate), view: \(image)")
        
    }
    
}
