//
//  Model.swift
//  ToDoList
//
//  Created by Кристина Пастухова on 07.08.2023.
//

import Foundation
import UserNotifications
import UIKit

//var listItems : [[String: Any]] = [["Name": "Помыть посуду","isCompleted": true],["Name": "Написать приложенее","isCompleted": false],["Name": "Организовать ДР","isCompleted": false]]
typealias ListItems = [[String:Any]]
struct ListofTask{
    var actual: ListItems
    var completed: ListItems
}
var listItems : ListofTask {
    set{
        UserDefaults.standard.set(newValue.actual, forKey: "ActualToDoList")
        UserDefaults.standard.set(newValue.completed, forKey: "CompletedToDoList")
        UserDefaults.standard.synchronize()
    }
    get{
        var tasks = ListofTask(actual: [], completed: [])
        if let actualList = UserDefaults.standard.value(forKey: "ActualToDoList") as? ListItems {
            tasks.actual = actualList
        }
        if let completedList = UserDefaults.standard.value(forKey: "CompletedToDoList") as? ListItems {
            tasks.completed = completedList
        }
        return tasks
    }
}

func removeItem(at index: IndexPath)-> String{
    let task: [String:Any]
    if index.section == 0{
        task = listItems.actual.remove(at: index.row)
        setBadge()
    }
    else {
        task = listItems.completed.remove(at: index.row)
    }
    return task["Name"] as! String

}
func changeAccess(at item: IndexPath){
    let taskName = removeItem(at: item)
    insertTask(task: taskName,at: IndexPath(row: 0, section: item.section == 0 ? 1 : 0))
    setBadge()
}
func insertTask(task: String, at to: IndexPath = IndexPath(row: 0, section: 0)){
    if to.section == 0{
        listItems.actual.insert(["Name" : task, "isCompleted" : false], at: to.row)
        setBadge()
    }
    else {
        listItems.completed.insert(["Name" : task, "isCompleted" : true], at: to.row)
    }
}
func moveTask(from: IndexPath, to: IndexPath){
    let taskName = removeItem(at: from)
    insertTask(task: taskName, at: to)
}
func requestForNotifications(){
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.requestAuthorization(options: [.badge]){
        granted, error in
        guard granted else {return}
        notificationCenter.getNotificationSettings{
            settings in
            print(settings)
            guard settings.authorizationStatus == .authorized else { return }
        }
    }
   
}
func setBadge(){
    UIApplication.shared.applicationIconBadgeNumber = listItems.actual.count
    
}
                                                            


