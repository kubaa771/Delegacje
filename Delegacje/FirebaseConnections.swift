//
//  FirebaseConnections.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 20/12/2020.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseConnections {
    static let shared = FirebaseConnections()
    var db = Firestore.firestore()
    
    func registerNewUser(userEmail: String, userPassword: String, fullName: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { (authDataResult, error) in
            if error != nil {
                completion(false)
            } else {
                if let userId = authDataResult?.user.uid {
                    self.db.collection("users").document(userId).setData(["fullName" : fullName, "email" : userEmail], merge: false) { (err) in
                        if error != nil {
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func loginUserWithCredentials(userEmail: String, userPassword: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { (authDataResult, error) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func getUserData(userId: String, completion: @escaping (User) -> Void) {
        db.collection("users").document(userId).getDocument { (snapshot, error) in
            if let documentData = snapshot?.data() {
                let fullName = documentData["fullName"] as! String
                let email = documentData["email"] as! String
                let user = User(id: userId, fullName: fullName, email: email)
                completion(user)
            }
        }
    }
    
    func addNewCar(carBrand: String, carModel: String, carCapacity: Float, carProductionYear: Int, carRyczalt: Float, carStawka: Float, completion: @escaping (Bool) -> Void) {
        let newCarData: [String: Any] = ["brand" : carBrand, "model" : carModel, "capacity" : carCapacity, "productionYear" : carProductionYear, "ryczalt" : carRyczalt, "stawka" : carStawka]
        db.collection("cars").addDocument(data: newCarData) { (error) in
            if error != nil {
                print(error!.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func getAllCars(completion: @escaping ([Car]?) -> Void) {
        //TODO: zmodyfikowac zeby sprawdzalo czy auto jest obecnie uzywane
        var cars: [Car] = []
        let group = DispatchGroup()
        let currentDate = Timestamp(date: Date())
        var delegationCarIds: [String] = []
        
        group.enter()
        db.collection("delegations").whereField("arrivalDate", isGreaterThanOrEqualTo: currentDate).getDocuments { (snapshot, error) in
            if let delegationDocuments = snapshot?.documents {
                for delegation in delegationDocuments {
                    let data = delegation.data()
                    let delegationCarID = data["carID"] as! String
                    delegationCarIds.append(delegationCarID)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.db.collection("cars").getDocuments { (snapshot, error) in
                if error != nil {
                    completion(nil)
                }
                if let documents = snapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        let carID = document.documentID
                        guard let brand = data["brand"] as? String, let model = data["model"] as? String, let capacity = data["capacity"] as? Float, let productionYear = data["productionYear"] as? Int, let ryczalt = data["ryczalt"] as? Float, let stawka = data["stawka"] as? Float else { completion(nil)
                            continue }
                        let newCar = Car(id: document.documentID, brand: brand, model: model, capacity: capacity, productionYear: productionYear, ryczalt: ryczalt, stawka: stawka)
                        if delegationCarIds.contains(carID) {
                            newCar.inUse = true
                        } else {
                            newCar.inUse = false
                        }
                        cars.append(newCar)
                    }
                    completion(cars)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func getAvailableCars(completion: @escaping ([Car]?) -> Void) {
        let currentDate = Timestamp(date: Date())
        var cars: [Car] = []
        let group = DispatchGroup()
        
        var delegationCarIds: [String] = []
        group.enter()
        db.collection("delegations").whereField("arrivalDate", isGreaterThanOrEqualTo: currentDate).getDocuments { (snapshot, error) in
            if let delegationDocuments = snapshot?.documents {
                for delegation in delegationDocuments {
                    let data = delegation.data()
                    let delegationCarID = data["carID"] as! String
                    delegationCarIds.append(delegationCarID)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            print(delegationCarIds)
            self.db.collection("cars").getDocuments { (snapshot, error) in
                if error != nil {
                    completion(nil)
                }
                
                if let carsDocuments = snapshot?.documents {
                    for document in carsDocuments {
                        let car = document.data()
                        let carID = document.documentID
                        if delegationCarIds.contains(carID) {
                            //do nothing
                        } else {
                            guard let brand = car["brand"] as? String, let model = car["model"] as? String, let capacity = car["capacity"] as? Float, let productionYear = car["productionYear"] as? Int, let ryczalt = car["ryczalt"] as? Float, let stawka = car["stawka"] as? Float else { //completion nil
                                continue }
                            let newCar = Car(id: document.documentID, brand: brand, model: model, capacity: capacity, productionYear: productionYear, ryczalt: ryczalt, stawka: stawka)
                            cars.append(newCar)
                            print(newCar.brand + " " + newCar.model + " " + newCar.id)
                        }
                    }
                    completion(cars)
                } else {
                    completion(nil)
                }
            }
        }
       
    }
    
    func addNewDelegation(userId: String, departureDate: Date, arrivalDate: Date, car: Car, distance: Float, departurePlace: String, arrivalPlace: String, completion: @escaping (Bool) -> Void) {
        //TODO: Dodawanie delegacji z currentUserem - mail albo id
        let departureTimestamp: Timestamp = Timestamp(date: departureDate)
        let arrivalTimestamp = Timestamp(date: arrivalDate)
        let delegation: [String: Any] = ["userId" : userId, "departureDate" : departureTimestamp, "arrivalDate" : arrivalTimestamp, "carID" : car.id, "distance" : distance, "departurePlace" : departurePlace, "arrivalPlace" : arrivalPlace]
        db.collection("delegations").addDocument(data: delegation) { (error) in
            if error != nil {
                print(error!.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func getCurrentDelegations(currentUserId: String, completion: @escaping ([Delegation]) -> Void) {
        //TODO: Powiazac z userem
        let currentDate = Timestamp(date: Date())
        var delegations: [Delegation] = []
        let group = DispatchGroup()
        
        db.collection("delegations").whereField("arrivalDate", isGreaterThanOrEqualTo: currentDate).getDocuments { (snapshot, error) in
            if let documents = snapshot?.documents {
                for document in documents {
                    let delegationData = document.data()
                    
                    guard let userId = delegationData["userId"] as? String, let arrivalTimestamp = delegationData["arrivalDate"] as? Timestamp, let arrivalPlace = delegationData["arrivalPlace"] as? String, let carID = delegationData["carID"] as? String, let departureTimestamp = delegationData["departureDate"] as? Timestamp, let departurePlace = delegationData["departurePlace"] as? String, let distance = delegationData["distance"] as? Float else { continue }
                    
                    guard userId == currentUserId else { continue }
                    
                    let arrivalDate = arrivalTimestamp.dateValue()
                    let departureDate = departureTimestamp.dateValue()
                    let delegation = Delegation(departureDate: departureDate, arrivalDate: arrivalDate, distance: distance, departurePlace: departurePlace, arrivalPlace: arrivalPlace)
                    group.enter()
                    self.db.collection("cars").document(carID).getDocument { (carSnapshot, err) in
                        guard let dictionary = carSnapshot?.data() else { return }
                        let car = Car(id: carID, brand: dictionary["brand"] as! String, model: dictionary["model"] as! String, capacity: dictionary["capacity"] as! Float, productionYear: dictionary["productionYear"] as! Int, ryczalt: dictionary["ryczalt"] as! Float, stawka: dictionary["stawka"] as! Float)
                        
                        delegation.car = car
                        
                        delegations.append(delegation)
                        group.leave()
                    }
                }
                print("smth")
                group.notify(queue: .main) {
                    delegations.sort { (del1, del2) -> Bool in
                        let date1 = del1.departureDate.timeIntervalSince1970
                        let date2 = del2.departureDate.timeIntervalSince1970
                        return date1 > date2
                    }
                    completion(delegations)
                }
            }
        }
        
    }
    
    func getHistoryDelegations(currentUserId: String, completion: @escaping ([Delegation]) -> Void) {
        var delegations: [Delegation] = []
        let currentDate = Timestamp(date: Date())
        let group = DispatchGroup()
        
        db.collection("delegations").whereField("arrivalDate", isLessThanOrEqualTo: currentDate).getDocuments { (snapshot, error) in
            if let documents = snapshot?.documents {
                for document in documents {
                    let delegationData = document.data()
                    
                    guard let userId = delegationData["userId"] as? String, let arrivalTimestamp = delegationData["arrivalDate"] as? Timestamp, let arrivalPlace = delegationData["arrivalPlace"] as? String, let carID = delegationData["carID"] as? String, let departureTimestamp = delegationData["departureDate"] as? Timestamp, let departurePlace = delegationData["departurePlace"] as? String, let distance = delegationData["distance"] as? Float else { continue }
                    
                    guard userId == currentUserId else { continue }
                    
                    let arrivalDate = arrivalTimestamp.dateValue()
                    let departureDate = departureTimestamp.dateValue()
                    let delegation = Delegation(departureDate: departureDate, arrivalDate: arrivalDate, distance: distance, departurePlace: departurePlace, arrivalPlace: arrivalPlace)
                    group.enter()
                    self.db.collection("cars").document(carID).getDocument { (carSnapshot, err) in
                        guard let dictionary = carSnapshot?.data() else { return }
                        let car = Car(id: carID, brand: dictionary["brand"] as! String, model: dictionary["model"] as! String, capacity: dictionary["capacity"] as! Float, productionYear: dictionary["productionYear"] as! Int, ryczalt: dictionary["ryczalt"] as! Float, stawka: dictionary["stawka"] as! Float)
                        
                        delegation.car = car
                        
                        delegations.append(delegation)
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    delegations.sort { (del1, del2) -> Bool in
                        let date1 = del1.departureDate.timeIntervalSince1970
                        let date2 = del2.departureDate.timeIntervalSince1970
                        return date1 > date2
                    }
                    completion(delegations)
                }
            }
        }
    }
    
    func checkIfCurrentUserIsAdmin() -> Bool{
        if Auth.auth().currentUser?.uid == "lNN3CBKb9NaAWqgrqyFAeETsKc13" {
            return true
        } else {
            return false
        }
    }
    
    func getAllUsers(completion: @escaping ([User]) -> Void) {
        var users: [User] = []
        let group = DispatchGroup()
        db.collection("users").getDocuments { (snapshot, error) in
            if let documents = snapshot?.documents {
                for document in documents {
                    let userData = document.data()
                    guard let fullName = userData["fullName"] as? String, let email = userData["email"] as? String else { continue }
                    var numberOfDelegations = 0
                    group.enter()
                    self.db.collection("delegations").whereField("userId", isEqualTo: document.documentID).getDocuments { (delegationSnapshot, err) in
                        if let delDocuments = delegationSnapshot?.documents {
                            numberOfDelegations = delDocuments.count
                            group.leave()
                        } else {
                            group.leave()
                        }
                        let user = User(id: document.documentID, fullName: fullName, email: email)
                        user.numberOfDelegations = numberOfDelegations
                        users.append(user)
                    }
                }
                group.notify(queue: .main) {
                    completion(users)
                }
            }
        }
    }
    
    func getAllDelegations(completion: @escaping ([Delegation]) -> Void) {
        var delegations: [Delegation] = []
        let insideGroup = DispatchGroup()
        let outsideGroup = DispatchGroup()
        db.collection("delegations").getDocuments { (delegationSnapshot, err) in
            if let delegationDocuments = delegationSnapshot?.documents {
                for delegationDocument in delegationDocuments  {
                    let delegationData = delegationDocument.data()
                    guard let carId = delegationData["carID"] as? String, let userId = delegationData["userId"] as? String else { continue }
                    guard let arrivalTimestamp = delegationData["arrivalDate"] as? Timestamp, let arrivalPlace = delegationData["arrivalPlace"] as? String, let departureTimestamp = delegationData["departureDate"] as? Timestamp, let departurePlace = delegationData["departurePlace"] as? String, let distance = delegationData["distance"] as? Float else { continue }
                    let departureDate = departureTimestamp.dateValue()
                    let arrivalDate = arrivalTimestamp.dateValue()
                    let delegation = Delegation(departureDate: departureDate, arrivalDate: arrivalDate, distance: distance, departurePlace: departurePlace, arrivalPlace: arrivalPlace)
                    outsideGroup.enter()
                    insideGroup.enter()
                    self.db.collection("cars").document(carId).getDocument { (carSnapshot, error) in
                        if let carData = carSnapshot?.data() {
                            guard let brand = carData["brand"] as? String, let model = carData["model"] as? String, let capacity = carData["capacity"] as? Float, let productionYear = carData["productionYear"] as? Int, let ryczalt = carData["ryczalt"] as? Float, let stawka = carData["stawka"] as? Float else { return }
                            let car = Car(id: carId, brand: brand, model: model, capacity: capacity, productionYear: productionYear, ryczalt: ryczalt, stawka: stawka)
                            delegation.car = car
                            insideGroup.leave()
                        }
                    }
                    insideGroup.enter()
                    self.db.collection("users").document(userId).getDocument { (userSnapshot, error) in
                        if let userData = userSnapshot?.data() {
                            guard let fullName = userData["fullName"] as? String, let email = userData["email"] as? String else { return }
                            let user = User(id: userId, fullName: fullName, email: email)
                            delegation.user = user
                            insideGroup.leave()
                        }
                    }
                    insideGroup.notify(queue: .main) {
                        delegations.append(delegation)
                        outsideGroup.leave()
                    }
                }
                outsideGroup.notify(queue: .main) {
                    completion(delegations)
                }
            }
        }
    }
    
    func getRaportFromDates(firstDate: Date, secondDate: Date, completion: @escaping (Raport) -> Void) {
        let firstDateTimestamp = Timestamp(date: firstDate)
        let secondDateTimestamp = Timestamp(date: secondDate)
        let group = DispatchGroup()
        var totalDelegations: Int = 0
        var totalDistance: Float = 0
        var averageDistance: Float = 0
        var totalPrice: Float = 0
        var distanceArray: [Float] = []
        
        self.db.collection("delegations").whereField("departureDate", isGreaterThanOrEqualTo: firstDateTimestamp).getDocuments { (delegationSnapshot, error) in
            if let delegationDocuments = delegationSnapshot?.documents {
                
                for delegation in delegationDocuments {
                    guard let arrivalDateTimestamp = delegation.data()["arrivalDate"] as? Timestamp else { continue }
                    let arrivalDate = arrivalDateTimestamp.dateValue()
                    guard arrivalDate.timeIntervalSince1970 < secondDate.timeIntervalSince1970 else { continue }
                    
                    totalDelegations += 1
                    guard let distance = delegation.data()["distance"] as? Float else { continue }
                    distanceArray.append(distance)
                    totalDistance += distance
                    guard let carId = delegation.data()["carID"] as? String else { continue }
                    group.enter()
                    self.db.collection("cars").document(carId).getDocument { (carSnapshot, err) in
                        if let carData = carSnapshot?.data() {
                            let ryczalt = carData["ryczalt"] as! Float
                            totalPrice += round(distance * ryczalt * 100)/100
                            group.leave()
                        }
                    }
                }
                averageDistance = totalDistance / Float(totalDelegations)
                group.notify(queue: .main) {
                    //TODO: zmienic z ?? 0 na cos innego - blad
                    let raportInfo = Raport(fromDate: firstDate, toDate: secondDate, numberOfDelegations: totalDelegations, totalDistance: totalDistance, totalPrice: totalPrice, averageDistance: averageDistance, maxDistance: distanceArray.max() ?? 0, minDistance: distanceArray.min() ?? 0)
                    completion(raportInfo)
                }
            }
        }
    }
    
}
