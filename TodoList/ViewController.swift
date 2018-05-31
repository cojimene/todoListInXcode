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
    @IBOutlet weak var getTaskButton: UIButton!
    
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
    @IBAction func getTaskList(_ sender: Any) {
        todoList.removeAll()
        let url = URL(string: "https://sleepy-earth-85571.herokuapp.com/tasks")
        let apiCall = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Sorry, we had a trouble")
                self.todoList.append("Sorry, we had a trouble")
            } else {
                if let content = data {
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        print(jsonData)
                        if let parsedData = jsonData as? NSArray {
                            print(parsedData)
                            self.mapDataAPIToList(data: parsedData)
                        }
                    } catch {
                        print("Error on parsing JSON")
                    }
                }
            }
        }
        apiCall.resume()
    }
    
    func mapDataAPIToList(data: NSArray) {
        for dataField in data {
            print(dataField)
            if let task = dataField as? NSDictionary {
                print(task)
                if let taskName = task["name"] as? String {
                    print(taskName)
                    todoList.append(taskName)
                }
            }
        }
        print(todoList)
    }
}

