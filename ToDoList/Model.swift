//
//  Model.swift
//  ToDoList
//
//  Created by Кристина Пастухова on 07.08.2023.
//

import Foundation

//var listItems : [[String: Any]] = [["Name": "Помыть посуду","isCompleted": true],["Name": "Написать приложенее","isCompleted": false],["Name": "Организовать ДР","isCompleted": false]]
var listItems : [[String: Any]] {
    set{
        UserDefaults.standard.set(newValue, forKey: "ToDoList")
        UserDefaults.standard.synchronize()
    }
    get{
        if let array = UserDefaults.standard.value(forKey: "ToDoList") as? [[String: Any]] {
            return array
        }
        else
        {
            return []
        }
    }
}

func addItem(task: String, isCompleted: Bool = false) {
    listItems.append(["Name": task, "isCompleted": isCompleted])

}
func removeItem(at row: Int){
    listItems.remove(at: row)

}
func changeAccess(at item: Int)-> Bool{
    listItems[item]["isCompleted"] = !(listItems[item]["isCompleted"] as! Bool)
    return listItems[item]["isCompleted"] as! Bool
}

func moveTask(from: Int, to: Int){
    let task = listItems.remove(at: from)
    listItems.insert(task, at: to)

}


