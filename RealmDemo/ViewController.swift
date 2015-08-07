//
//  ViewController.swift
//  RealmDemo
//
//  Created by fengshaobo on 15/7/22.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

import UIKit
import Realm

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // data
    var allBu: RLMResults!

    var personsResult: RLMResults!

    var selectedBU: BUModel!

    var selectedPerson: PersonModel!

    var BUNames = ["门票", "酒店", "机票"]
    
    var persons = NSMutableArray()
    
    // view
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var modifyButton: UIButton!
    @IBOutlet weak var queryButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDefaultBU()
        getDefaultPersons()
        
        println(RLMRealm.defaultRealm().path)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addRealmItem(button: UIButton) {
        
        let realm = RLMRealm.defaultRealm()
        
        realm.beginWriteTransaction()
        let newPeople = PersonModel()
        
        newPeople.name = "冯少波"
        newPeople.age = 28
        newPeople.bu = allBu[0] as! BUModel
        
        realm.addObject(newPeople)
        realm.commitWriteTransaction()
        
        self.personsResult = PersonModel.allObjects()

    }

    @IBAction func deleteRealmItem(button: UIButton) {
        
        let realm = RLMRealm.defaultRealm()
        let peopleToDelete = self.personsResult[0] as! PersonModel
        
        realm.beginWriteTransaction()
        realm.deleteObject(peopleToDelete)
        realm.commitWriteTransaction()
        
        personsResult = PersonModel.allObjects().sortedResultsUsingProperty("name", ascending: true)
    }
    
    @IBAction func modifyRealmItem(button: UIButton) {
        
        self.personsResult = PersonModel.allObjects()

        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        
        let peopleToModify = self.personsResult[0] as! PersonModel
        peopleToModify.name = "库克"
        peopleToModify.age = 50
        
        realm.commitWriteTransaction()
    }
    
    @IBAction func queryRealmItem(button: UIButton) {
        
        var searchStr = "a"
        let predicate = "name BEGINSWITH [c]'\(searchStr)'"
        var searchResults = PersonModel.objectsWhere(predicate)
        println(searchResults)
        self.personsResult = searchResults.sortedResultsUsingProperty("name", ascending: true)

        tableView.reloadData()
    }
    
    // table view delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(personsResult.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var person = personsResult[UInt(indexPath.row)] as! PersonModel
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonCell", forIndexPath: indexPath) as! PersonCell
        cell.nameLabel?.text = person.name
        cell.ageLabel?.text = String(person.age)
        cell.buLabel?.text = person.bu.name
        return cell
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedPerson = self.personsResult[UInt(indexPath.row)] as! PersonModel
        return indexPath
    }

    // realm operation
    private func getDefaultBU() {
        allBu = BUModel.allObjects()
        
        if allBu.count == 0 {
            
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            
            for BUName in self.BUNames {
                let newBUModel = BUModel()
                newBUModel.name = BUName
                realm.addObject(newBUModel)
            }
            
            realm.commitWriteTransaction()
            
            allBu = BUModel.allObjects()
        }
    }
    
    private func getDefaultPersons() {
        personsResult = PersonModel.allObjects()
        
        if personsResult.count == 0 {
            
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            
            for var index = 0; index < 5; index++ {
                
                let newPerson = PersonModel()
                newPerson.name = "冯少波" + String(index)
                newPerson.age = 28 + index
                newPerson.bu = allBu[0] as! BUModel

                realm.addObject(newPerson)
                
            }
            
            realm.commitWriteTransaction()
            
            personsResult = PersonModel.allObjects()
        }
    }
    
    private func initPersonData() {
        var person1 = ["name":"冯少波","age":Int(28),"bu":allBu[0] as! BUModel];
        persons.addObject(person1)

    }
}

