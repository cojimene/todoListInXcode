//
//  ViewController.swift
//  TodoList
//
//  Created by Carlos Jiménez on 5/29/18.
//  Copyright © 2018 Carlos Jiménez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var taskField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var taskList: UITableView!
    
    var todoList = ["Study swift", "Practice Xcode"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(todoList.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = todoList[indexPath.row]
        return(cell)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            todoList.remove(at: indexPath.row)
            taskList.reloadData()
        }
    }
    
    @IBAction func addTask(_ sender: Any) {
        if taskField.text != "" {
            todoList.append(taskField.text!)
            taskList.reloadData()
            taskField.text = ""
        }
    }
    
}

