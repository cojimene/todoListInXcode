//
//  ViewController.swift
//  TodoList
//
//  Created by Carlos Jiménez on 5/29/18.
//  Copyright © 2018 Carlos Jiménez. All rights reserved.
//

import UIKit

struct Task: Decodable, Encodable {
    let id: Int
    let name: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var taskField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var taskList: UITableView!
    
    var todoList = [Task]()
    let apiUrl = URL(string: "https://sleepy-earth-85571.herokuapp.com/tasks")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoList.removeAll()
        getTasks(completed: {
            self.taskList.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let task = todoList[indexPath.row]
        cell.textLabel?.text = "\(task.id). \(task.name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let task = todoList[indexPath.row]
            deleteTask(taskId: task.id, completed: {
                self.todoList.remove(at: indexPath.row)
                self.taskList.reloadData()
            })
        }
    }
    
    @IBAction func addTask(_ sender: Any) {
        if taskField.text != "" {
            let lastId = todoList.last?.id ?? 0
            let task = Task(id: lastId + 1, name: taskField.text!)
            addTask(task: task, completed: {
                self.taskList.reloadData()
                self.taskField.text = ""
            })
        }
    }
    
    func getTasks(completed: @escaping () -> ()) {
        URLSession.shared.dataTask(with: apiUrl!) { (data, _, error) in
            if error == nil {
                guard let data = data else { return }
                do {
                    self.todoList = try JSONDecoder().decode([Task].self, from: data)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch let jsonErr {
                    print("Error serializing json: ", jsonErr)
                }
            } else {
                print("Sorry, we had a trouble")
            }
        }.resume()
    }
    
    func addTask(task: Task, completed: @escaping () -> ()) {
        var request = URLRequest(url: apiUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONEncoder().encode(task)
        } catch let jsonErr {
            print("Error serializing json: ", jsonErr)
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error == nil {
                guard let data = data else { return }
                do {
                    let task = try JSONDecoder().decode(Task.self, from: data)
                    self.todoList.append(task)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch let jsonErr {
                    print("Error serializing json: ", jsonErr)
                }
            } else {
                print("Sorry, we had a trouble")
            }
        }.resume()
    }
    
    func deleteTask(taskId: Int, completed: @escaping () -> ()) {
        let deleteUrl = apiUrl?.appendingPathComponent("\(taskId)")
        var request = URLRequest(url: deleteUrl!)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if error == nil {
                DispatchQueue.main.async {
                    completed()
                }
            } else {
                print("Sorry, we had a trouble")
            }
        }.resume()
    }
}

