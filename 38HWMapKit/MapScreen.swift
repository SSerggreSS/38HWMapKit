//
//  ViewController.swift
//  38HWMapKit
//
//  Created by Сергей on 30.03.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//
/*
Итак, друзья, в коротеньких двух уроках мы разобрались с картами. Конечно весь функционал карт вам вряд ли пригодиться, но зато практика никогда не бывает лишней, а особенно практика использования нового фреймворка! Так что готовьтесь к заданию :)

Давайте раз уж мы часто говорим о студентах, то будем играться и с ними.

Ученик.

✅1. Создайте массив из 10 - 30 рандомных студентов, прямо как раньше, только в этот раз пусть у них наряду с именем и фамилией будет еще и координата. Можете использовать структуру координаты, а можете просто два дабла - лонгитюд и латитюд.

✅2. Координату генерируйте так, установите центр например в вашем городе и просто генерируйте небольшие отрицательные либо положительные числа, чтобы рандомно получалась координата от центра в пределах установленного радиуса.

(Ну а если совсем не получается генерировать координату, то просто ставьте им заготовленные координаты - это не главное)

✅3. После того, как вы сгенерировали своих студентов, покажите их всех на карте, причем в титуле пусть будет Имя и Фамилия а в сабтитуле год рождения. Можете для каждого студента создать свою аннотацию, а можете студентов подписать на протокол аннотаций и добавить их на карту напрямую - как хотите :)

Студент.

✅4. Добавьте кнопочку, которая покажет всех студентов на экране.

✅5. Вместо пинов на карте используйте свои кастомные картинки, причем если студент мужского пола, то картинка должна быть одна, а для девушек другая.

✅Мастер

✅6. У каждого колаута (этого облачка над пином) сделайте кнопочку информации справа так, что когда я на нее нажимаю вылазит поповер, в котором в виде статической таблицы находится имя и фамилия студента, год рождения, пол и самое главное адрес.

Супермен

✅8. Создайте аннотацию для места встречи и показывайте его на карте новымой соответствующей картинкой

✅9. Место встречи можно перемещать по карте, а студентов нет

✅10. Когда место встречи бросается на карту, то вокруг него надо рисовать 3 круга, с радиусами 5 км, 10 км и 15 км (используйте оверлеи)

✅11. На какой-то полупрозрачной вьюхе в одном из углов вам надо показать сколько студентов попадают в какой круг. Суть такая, чем дальше студент живет, тем меньше вероятность что он придет на встречу. Расстояние от студента до места встречи рассчитывайте используя функцию для расчета расстояния между точками, поищите ее в фреймворке :)

✅12. Сделайте на навигейшине кнопочку, по нажатию на которую, от рандомных студентов до нее будут проложены маршруты (типо студенты идут на сходку), притом вероятности генератора разные, зависит от круга, в котором они находятся, если он близко, то 90%, а если далеко - то 10%

Сложно, но, надеюсь, интересно :)
 
 наследовать студента от MKAnnotationView
*/
 
import UIKit
import MapKit
import CoreLocation

//MARK: StudentInfoTableViewControllerDelegate
protocol StudentInfoTableViewControllerDelegate {
    
    func get(student: Student?)
    
}

class MapScreen: UIViewController {
    
    //MARK: Properties

    //User Interface
    let mapView = MKMapView()
    var infoStudentTVC: StudentInfoTableViewController?
    var infoView = UIView()
    var exactlyStudLabel = UILabel()
    var possiblyStudLabel = UILabel()
    var unlikelyStudLabel = UILabel()
    var notComeStudLabel = UILabel()
    let mapTypeSegCont = UISegmentedControl()
    
    //Core Location
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    //For culculate coordinate
    var placeMeet = PlaceMeet(latitude: 45.044502, longitude: 41.969065)
    let regionMeters = 10000.0
    let delta = 10000.0
    let offset: CGFloat = 200.0
    
    //Data for app
    var countStudents = (exactly: 0, possibly: 0, unlikely: 0, notCome: 0)
    var textForStudLabel = (exactly: "Exactly:", possibly: "Possibly:", unlikely: "Unlikely:", notCome: "Not Came:")
    var randomStudArray = [Student]()
    
    //For routs
    var directions: MKDirections? = nil
    
    //delegate for communication between controllers
    var delegate: StudentInfoTableViewControllerDelegate? = nil
    
    //MARK: Life Cicle
    
    override func loadView() {
        super.loadView()
        
        mapView.mapType = .standard
        mapTypeSegCont.frame = CGRect(x: 20, y: 10, width: 300, height: 30)
        mapTypeSegCont.selectedSegmentIndex = 0
        mapTypeSegCont.insertSegment(withTitle: "standard", at: 0, animated: true)
        mapTypeSegCont.insertSegment(withTitle: "hybrid", at: 1, animated: true)
        mapTypeSegCont.insertSegment(withTitle: "satellite", at: 2, animated: true)
        
        mapTypeSegCont.addTarget(self,
                                 action: #selector(actionMapTypeSegmentedC(sender:)),
                                 for: .valueChanged)
        
        self.navigationController?.navigationBar.addSubview(mapTypeSegCont)
        
        
        infoView = UIView(frame: CGRect(x: 20,
                                        y: offset / 2,
                                        width: offset, height: offset))
    
        let bounds = infoView.bounds
        exactlyStudLabel = UILabel(frame:
                                   CGRect(x: bounds.origin.x, y: bounds.origin.y,
                                          width: bounds.width, height: bounds.height / 4))
        exactlyStudLabel.backgroundColor = UIColor(red: 100, green: 0, blue: 0, alpha: 0.3)
        exactlyStudLabel.text = textForStudLabel.exactly + " " +
                                String(countStudents.exactly)
     
        infoView.addSubview(exactlyStudLabel)
        
        possiblyStudLabel = UILabel(frame:
                                    CGRect(x: 0, y: exactlyStudLabel.frame.maxY,
                                           width: bounds.width, height: bounds.height / 4))
        possiblyStudLabel.backgroundColor = UIColor(red: 100, green: 100, blue: 0, alpha: 0.3)
        possiblyStudLabel.text = textForStudLabel.possibly + " " +
                                 String(countStudents.possibly)
        infoView.addSubview(possiblyStudLabel)
        
        unlikelyStudLabel = UILabel(frame:
                                    CGRect(x: 0, y: possiblyStudLabel.frame.maxY,
                                           width: bounds.width, height: bounds.height / 4))
        unlikelyStudLabel.backgroundColor = UIColor(red: 0, green: 100, blue: 0, alpha: 0.3)
        unlikelyStudLabel.text = textForStudLabel.unlikely + " " +
                                 String(countStudents.unlikely)
        infoView.addSubview(unlikelyStudLabel)
        
        notComeStudLabel = UILabel(frame:
                                   CGRect(x: 0, y: unlikelyStudLabel.frame.maxY,
                                          width: bounds.width, height: bounds.height / 4))
        notComeStudLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        notComeStudLabel.textColor = .white
        notComeStudLabel.text = textForStudLabel.notCome + " " +
                                String(countStudents.notCome)
        infoView.addSubview(notComeStudLabel)
        mapView.addSubview(infoView)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServies()
        
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth]
        mapView.delegate = self
        view.addSubview(mapView)
        
        let addStudentsButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(actionAddStudets(sender:)))
        
        let showAllAnnotation = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(actionShowAll(sender:)))
        
        let addPlaceMeetButton = UIBarButtonItem(title: "Add Place Meet", style: .plain, target: self, action: #selector(actionAddPlaceMeet(sender:)))
        
        let studentsGoMeetButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(actionStudentsGoMeet(sender:)))
        
        let removeAllButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(actionRemoveAll))
        
        navigationItem.rightBarButtonItems = [addStudentsButton, showAllAnnotation, addPlaceMeetButton,
                                              studentsGoMeetButton, removeAllButton]
    
    }
    
    //MARK: Actions
    
    @objc private func actionRemoveAll() {
        
        directions = nil
        randomStudArray.removeAll()
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        zeroizeCountersStudents()
        zeroizeAllLabels()
        
    }
    
    //стеденты идут на собрание
    @objc func actionStudentsGoMeet(sender: UIBarButtonItem) {
        // берем координаты для маршрута
        calculatePercentsPossibleCome(students: &randomStudArray)
        calculateRoutesFrom(students: randomStudArray, toPlace: placeMeet)
        
    }
    
    // Change map type
    @objc private func actionMapTypeSegmentedC(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            case 0:
                mapView.mapType = .standard
            case 1:
                mapView.mapType = .hybrid
            case 2:
                mapView.mapType = .satellite
            default:
                break
        }
        
    }
    
    // Add place meet students and overlay for circles
    @objc private func actionAddPlaceMeet(sender: UIBarButtonItem) {

        mapView.addAnnotation(placeMeet)
        mapView.addOverlay(placeMeet.largeCircle)
        mapView.addOverlay(placeMeet.middleCircle)
        mapView.addOverlay(placeMeet.smallCircle)
        
    }
    
    // Presentation popover about student
    @objc private func actionInfoStudent(sender: UIButton) {
        
        if geocoder.isGeocoding {
            geocoder.cancelGeocode()
        }
        
        var studet: Student?
        let annottaionView = sender.superAnnotationView()
        if annottaionView?.annotation is Student  {
            studet = annottaionView?.annotation as? Student
            studet?.descriptionStud()
        }
    
        let studCoordinate = studet?.coordinate ?? CLLocationCoordinate2D()
        
        let studentLocation = CLLocation(latitude: studCoordinate.latitude, longitude: studCoordinate.longitude)
       
            geocoder.reverseGeocodeLocation(studentLocation) { (placemarks, error) in
        
                                       if let _ = error {
                                          print(error.debugDescription)
                                       }
                                       
                                       guard let placemark = placemarks?.last else { return }
                                   
                studet?.address.country = "\(placemark.country ?? "NOT found Country")"
                studet?.address.city = "\(placemark.administrativeArea ?? "NOT found Administrative Area")"
                studet?.address.street = " \(placemark.name ?? "NOT found Name")"
    
                self.infoStudentTVC = StudentInfoTableViewController()
                self.infoStudentTVC?.preferredContentSize = CGSize(width: 500, height: 500)
                self.delegate = self.infoStudentTVC
                self.delegate?.get(student: studet)
                self.infoStudentTVC?.modalPresentationStyle = .popover
            
                let popover = self.infoStudentTVC?.popoverPresentationController
                popover?.sourceView = sender
                let unwrapInfoStudentTVC = self.infoStudentTVC ?? StudentInfoTableViewController()
                self.present(unwrapInfoStudentTVC, animated: true, completion: nil)
                
            }
    }
    
    // Create random students with annotation on map
    @objc private func actionAddStudets(sender: UIBarButtonItem) {
        
        var isPlaceMeetOnMap = false

        for annotation in mapView.annotations {
            
            if annotation.isKind(of: PlaceMeet.self) {
                isPlaceMeetOnMap = true
            }
            
        }
        
        guard isPlaceMeetOnMap && randomStudArray.isEmpty else { return }
        //добавляем рандомных студентов в массив и назначаем рандомные координаты относительно координат метки
        let tempRandStud = Student.randomStudents(inCoord: placeMeet.coordinate,
                                                  inRadius: 0.1)
        randomStudArray.append(contentsOf: tempRandStud)
        
        countStudents.exactly = placeMeet.smallCircle.contains(students: randomStudArray,
                                                              outOfRadius: nil)
        exactlyStudLabel.text = textForStudLabel.exactly + " " +
                                String(countStudents.exactly)
        
        countStudents.possibly = placeMeet.middleCircle.contains(students: randomStudArray,
                                                                outOfRadius: placeMeet.smallCircle.radius)
        possiblyStudLabel.text = textForStudLabel.possibly + " " +
                                 String(countStudents.possibly)
        
        countStudents.unlikely = placeMeet.largeCircle.contains(students: randomStudArray,
                                                                outOfRadius: placeMeet.middleCircle.radius)
        unlikelyStudLabel.text = textForStudLabel.unlikely + " " +
                                 String(countStudents.unlikely)
        
        countStudents.notCome = randomStudArray.count - countStudents.exactly -
                                countStudents.possibly - countStudents.unlikely
        
        notComeStudLabel.text = textForStudLabel.notCome + " " +
                                String(countStudents.notCome)
        
        calculatePercentsPossibleCome(students: &randomStudArray)
        
        mapView.addAnnotations(randomStudArray)
        
    }
    
    //Show all AnnotationView in rectangule
    @objc private func actionShowAll(sender: UIBarButtonItem) {
        
        var zoomRect = MKMapRect.null
        
        for annotation in mapView.annotations {
            
            let coordinate = annotation.coordinate
            let point = MKMapPoint(coordinate)
        
            let mapRect = MKMapRect(x: point.x - delta, y: point.y - delta,
                                    width: delta * 2, height: delta * 2)
            zoomRect = zoomRect.union(mapRect)
            
        }
        
        zoomRect = mapView.mapRectThatFits(zoomRect)
        let edgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        mapView.setVisibleMapRect(zoomRect, edgePadding: edgeInsets, animated: true)
        
    }
    
    //MARK: MKMapViewDelegate
    
    // Change overlays by state
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        
        if view is PlaceMeet && newState == .starting {
    
            mapView.removeOverlays(mapView.overlays)
            
        } else if view is PlaceMeet && newState == .ending {
            
            placeMeet.largeCircle = CustomMKCircle(center:
                                          view.annotation?.coordinate ?? CLLocationCoordinate2D(),
                                          radius: placeMeet.largeCircle.radius)
            placeMeet.largeCircle.tag = 0
            placeMeet.middleCircle = CustomMKCircle(center:
                                          view.annotation?.coordinate ?? CLLocationCoordinate2D(),
                                          radius: placeMeet.middleCircle.radius)
            placeMeet.middleCircle.tag = 1
            placeMeet.smallCircle = CustomMKCircle(center:
                                         view.annotation?.coordinate ?? CLLocationCoordinate2D(),
                                         radius: placeMeet.smallCircle.radius)
            placeMeet.smallCircle.tag = 2
            
            let overlaysArray = [placeMeet.largeCircle, placeMeet.middleCircle, placeMeet.smallCircle]
            
            mapView.addOverlays(overlaysArray)
        
            zeroizeCountersStudents()
            
            calculateContainedStudentsAndUpdateLabels()
            
        }
        
    }
    
    // этот метод позволяет отображать разные наложения на карту фигуры маршруты да хоть коня нарисуй
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // to display the route
        if let polyLine = overlay as? MKPolyline {
            let polyLineRenderrer = MKPolylineRenderer(polyline: polyLine)
            polyLineRenderrer.lineWidth = 10
            polyLineRenderrer.strokeColor = .orange
            return polyLineRenderrer
        }
        
        // to display the circles
        guard let customMKCircle = overlay as? CustomMKCircle else { return MKOverlayRenderer() }
        
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        
        switch customMKCircle.tag {
            case 0:
                circleRenderer.fillColor = UIColor(red: 0, green: 255, blue: 0, alpha: 0.2)
            case 1:
                circleRenderer.fillColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.2)
            case 2:
                circleRenderer.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.2)
            default:
                break
        }

        return circleRenderer
    }
    
    // Make view for students and for place meet
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        let identifier = "Studet"
        
        var studetView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? Student
        
        if studetView == nil && annotation.isKind(of: Student.self) {
            
            studetView = Student.init(annotation: annotation, reuseIdentifier: identifier)
            studetView?.image = studetView?.image?.resize(width: 70, height: 50)
            studetView?.canShowCallout = true
            
            let buttonRightCallout = UIButton(type: .detailDisclosure)
            buttonRightCallout.addTarget(self, action: #selector(actionInfoStudent(sender:)),
                                         for: .touchUpInside)
            studetView?.rightCalloutAccessoryView = buttonRightCallout
            
        } else if (annotation.isKind(of: PlaceMeet.self)) {
            
            let image = UIImage(named: "PlaceMeet")
            self.placeMeet.image = image?.resize(width: 100, height: 100)
            placeMeet.isUserInteractionEnabled = true
            placeMeet.canShowCallout = true
            placeMeet.isDraggable = true
            placeMeet.title = "Place Meet Students"
            placeMeet.subtitle = "Latitude: \(Float(placeMeet.coordinate.latitude)), Longitude: \(Float(placeMeet.coordinate.longitude))"
            return placeMeet
            
        }
        
        return studetView
    }
    
    //MARK: Help Function
    
    private func zeroizeAllLabels() {
        
    exactlyStudLabel.text = textForStudLabel.exactly
    possiblyStudLabel.text = textForStudLabel.possibly
    unlikelyStudLabel.text = textForStudLabel.unlikely
    notComeStudLabel.text = textForStudLabel.notCome
        
    }
    
    private func zeroizeCountersStudents() {
        
        countStudents.exactly = 0
        countStudents.possibly = 0
        countStudents.unlikely = 0
        countStudents.notCome = 0
        
    }
    
    
    private func removeAllPolyline() {
    
        guard !mapView.overlays.isEmpty else { return }
        
            for overlay in mapView.overlays where overlay is MKPolyline {
                    mapView.removeOverlay(overlay)
        }
    }
    
    // calculate the percentage of probability that the student will be at the meeting
    // accurate information about the student's presence is calculated inside the Student class, in the calculated property isComing
    
    private func calculatePercentsPossibleCome(students: inout [Student]) {
       
        for stud in students {
            
            stud.percentageOfProbability = 10
            
            if placeMeet.smallCircle.contains(student: stud, outOfRadius: 0) {
                stud.percentageOfProbability = 90
            }
            
            if placeMeet.middleCircle.contains(student: stud, outOfRadius: placeMeet.smallCircle.radius) {
                stud.percentageOfProbability = 60
            }
            
            if placeMeet.largeCircle.contains(student: stud, outOfRadius: placeMeet.middleCircle.radius) {
                stud.percentageOfProbability = 30
            }
            
        }
    }
    
    // Count how many students are in circles
    private func calculateContainedStudentsAndUpdateLabels() {
        
        countStudents.exactly = placeMeet.smallCircle.contains(students: randomStudArray,
                                                              outOfRadius: nil)
        exactlyStudLabel.text = textForStudLabel.exactly + " " +
                                String(countStudents.exactly)
        
        countStudents.possibly = placeMeet.middleCircle.contains(students: randomStudArray,
                                                                outOfRadius:   placeMeet.smallCircle.radius)
        possiblyStudLabel.text = textForStudLabel.possibly + " " +
                                 String(countStudents.possibly)
        
        countStudents.unlikely = placeMeet.largeCircle.contains(students: randomStudArray,
                                                                outOfRadius:   placeMeet.middleCircle.radius)
        unlikelyStudLabel.text = textForStudLabel.unlikely + " " +
                                 String(countStudents.unlikely)
        
        countStudents.notCome = randomStudArray.count - countStudents.exactly -
                                countStudents.possibly -    countStudents.unlikely
        notComeStudLabel.text = textForStudLabel.notCome + " " +
                                String(countStudents.notCome)
        
    }
    
    // To calculate the routes for each student
    private func calculateRoutesFrom(students: [Student], toPlace: PlaceMeet) {
        
         removeAllPolyline()
        
         guard !randomStudArray.isEmpty else { return }
        
         calculatePercentsPossibleCome(students: &randomStudArray)
        
         let placeMeetCoord = placeMeet.coordinate
         let placeMarkPlaceMeet = MKPlacemark(coordinate: placeMeetCoord)
         let destinationMapItem = MKMapItem(placemark: placeMarkPlaceMeet)
         
         for student in randomStudArray {
         
         guard student.isComing else { continue }
             
         let studentCoord = student.coordinate
         
         //берем их метки места
         let placeMarkStudent = MKPlacemark(coordinate: studentCoord)
         
         //создаем точки интереса на карте с помошью их можно создать маршрут
         let sourceMapItem = MKMapItem(placemark: placeMarkStudent)
         
         let directionRequest = MKDirections.Request()
         directionRequest.transportType = .automobile
         directionRequest.source = sourceMapItem
         directionRequest.destination = destinationMapItem
         
         directions = MKDirections(request: directionRequest)
         
         directions?.calculate { (response, error) in
             
             guard let response = response else {
                let alert = UIAlertController(title: "Error",
                                              message: error?.localizedDescription,
                                              preferredStyle: .alert)
                let actionAlert = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
                alert.addAction(actionAlert)
                self.present(alert, animated: true, completion: nil)
                 
                 return
             }
             //берем дорогу из массива дорог
             guard !response.routes.isEmpty else { return }
             
             for route in response.routes {
                 //делаем наложение на карту в виде многих линий по верх дорог
                 self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                 }
             }
         }
    }
    
    //1 проверяем включены ли службы определения местоположения
    private func checkLocationServies() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        }
    }
    
    //2 устанавливаем делегат менеджеру и устанавливаем точность
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
   /*
    private func centerViewOnUserLocation() {
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
            mapView.setRegion(region, animated: true)
        }
    }
   */
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                mapView.showsUserLocation = false
                //centerViewOnUserLocation()
            case .denied:
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                break
            case .authorizedAlways:
                break
            @unknown default:
                break
        }
    }
    
    
}

extension MapScreen: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //centerViewOnUserLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    
}



