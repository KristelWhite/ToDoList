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
            let newTask = alertController.textFields![0].text
            guard let corectTask = self.checkTaskName(name: newTask) else {return}
            insertTask(task: corectTask)
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
        // убираем лишний интерфейс строк
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.systemGroupedBackground
        self.title = "ToDoList"
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
        //убираем отступ перед хэдэром в каждой секции
        tableView.sectionHeaderTopPadding = 0
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return listItems.actual.count
        }
        else if section == 1 {
            return listItems.completed.count
        }
        return 0
    }
    // MARK: - footers and headers in sections
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "actual"
        case 1:
            return "completed"
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
        
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//           let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80))
//        view.backgroundColor = UIColor.lightGray
//
//           let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 35))
//           lbl.font = UIFont.systemFont(ofSize: 20)
//           lbl.text = "Section 1"
//           view.addSubview(lbl)
//           return view
//         }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.section == 0{
            let data = listItems.actual[indexPath.row]
            cell.textLabel?.text = data["Name"] as? String
            cell.imageView?.image = UIImage(systemName: "circle")
        }
        else if indexPath.section == 1{
            let data = listItems.completed[indexPath.row]
            cell.textLabel?.text = data["Name"] as? String
            cell.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        changeState(at: indexPath)
        
    }
    func changeState(at indexPath: IndexPath){
        changeAccess(at: indexPath)
        let isCheck = indexPath.section == 0 ? true : false
        tableView.cellForRow(at: indexPath)?.imageView?.image = UIImage(systemName: isCheck ? "checkmark.circle.fill" : "circle")
        // moving row
        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: isCheck ? 1 : 0))
    }
    func checkTaskName(name: String?) -> String? {
        guard let name = name else { return nil }
        guard name != "" else { return nil }
        return name
    }
      
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            removeItem(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        moveTask(from: fromIndexPath, to: to)
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        switch (sourceIndexPath.section, proposedDestinationIndexPath.section){
        case (0,1):
            let destinationRow = tableView.numberOfRows(inSection: 0) - 1
            return IndexPath(row: destinationRow, section: 0)
        case (1,0):
            return IndexPath(row: 0, section: 1)
        default:
            break
        }
        return proposedDestinationIndexPath
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
