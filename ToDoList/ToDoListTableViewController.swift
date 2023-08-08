//
//  ToDoListTableViewController.swift
//  ToDoList
//
//  Created by Кристина Пастухова on 24.07.2023.
//

import UIKit

class ToDoListTableViewController: UITableViewController {
    
    @IBAction func pushAddButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Add task", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField)
            in
            textField.placeholder = "write new task"
        })
        let alertAction1 = UIAlertAction(title: "Create", style: .cancel)
        { (action) in
            let newTask = alertController.textFields![0].text ?? "new task"
            addItem(task: newTask)
            self.tableView.reloadData()
        }
        let alertAction2 = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        present(alertController, animated: true)
    }
    
    @IBAction func pushEditButton(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //         self.navigationItem.rightBarButtonItem = self.editButtonItem
        //
        //        navigationItem.prompt = "prompt"
        //        self.title = "title"
        //        navigationItem.title = "no title"
        //
        //
        //        let navBarAppearance = UINavigationBarAppearance() // 4
        //        navBarAppearance.configureWithOpaqueBackground() // 5
        //        //
        //        navBarAppearance.titleTextAttributes = [ // 6
        //            .font: UIFont(name: "Apple SD Gothic Neo Bold", size: 19) ?? UIFont.systemFont(ofSize: 19),
        //            .foregroundColor: UIColor.red
        //        ]
        //        navBarAppearance.backgroundColor = UIColor( // 8
        //            red: 97/255,
        //            green: 210/255,
        //            blue: 255/255,
        //            alpha: 255/255
        //        )
        //        navigationController?.navigationBar.standardAppearance = navBarAppearance
        //        self.navigationItem.standardAppearance = navBarAppearance
        
        // MARK: - новый код
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let currentCell = listItems[indexPath.row]
        cell.textLabel?.text = currentCell["Name"] as? String
        cell.accessoryType = currentCell["isCompleted"] as! Bool ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        changeState(at: indexPath)
        
    }
    func changeState(at indexPath: IndexPath){
        tableView.cellForRow(at: indexPath)?.accessoryType = changeAccess(at: indexPath.row) ? .checkmark : .none
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        moveTask(from: fromIndexPath.row, to: to.row)
        tableView.reloadData()
    }
    
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
