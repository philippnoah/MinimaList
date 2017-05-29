//
//  ViewController.swift
//  Minima List
//
//  Created by Philipp Eibl on 5/23/17.
//  Copyright © 2017 Philipp Eibl. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldContainer: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!
    
    var taskArray = [NSManagedObject]()
    var tap = UITapGestureRecognizer()
    
    @IBAction func newTask(_ sender: UIButton) {
        let inset: CGFloat = 75
        UIView.animate(withDuration: 0.1, animations: ({ _ in
            self.tableView.contentInset.top = inset
            self.tableView.contentOffset.y = -inset
            self.textFieldContainer.isHidden = false
            self.textField.becomeFirstResponder()
        }), completion: ({ _ in
        }))
        
        
    }
    @IBAction func longPressed(_ sender: UILongPressGestureRecognizer) {
        if longPressGesture.state == .began && textFieldContainer.isHidden {
            tableView.setEditing(!tableView.isEditing, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchTasks()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.contentInset.bottom = 120
        textField.layer.cornerRadius = 7
        self.hideKeyboardWhenTappedAround()
        longPressGesture.cancelsTouchesInView = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = taskArray[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.font = UIFont(name: "Quicksand-Bold", size: 22)
        cell.textLabel?.text =
            task.value(forKeyPath: "title") as? String
        if (task.value(forKey: "isCompleted") as? Bool) ?? false {
            let line = UIView()
            line.frame = CGRect(x: 5, y: cell.bounds.midY-2.5, width: cell.bounds.width+10, height: 5)
            line.backgroundColor = UIColor.black
            line.layer.cornerRadius = 2.5
            cell.addSubview(line)
        } else {
            cell.textLabel?.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "delete"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        context.delete(taskArray[indexPath.row])
        taskArray.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .none
        }
        return .delete
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceTask = taskArray[sourceIndexPath.row]
        taskArray[sourceIndexPath.row] = taskArray[destinationIndexPath.row]
        taskArray.insert(sourceTask, at: destinationIndexPath.row)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            self.save(title: textField.text!)
            fetchTasks()
            view.endEditing(true)
            textField.text = nil
            textFieldContainer.isHidden = true
            tableView.contentInset.top = 0
            return true
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 23
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = nil
        return true
    }
    
    func fetchTasks() {
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        //3
        do {
            taskArray = try managedContext.fetch(fetchRequest)
            taskArray.reverse()
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func save(title: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Task",
                                       in: managedContext)!
        
        let task = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        // 3
        task.setValue(title, forKeyPath: "title")
        task.setValue(false, forKeyPath: "isCompleted")
        
        // 4
        do {
            try managedContext.save()
            taskArray.append(task)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tapped))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        tableView.addGestureRecognizer(tap)
    }
    
    func tapped() {
        
        if !textFieldContainer.isHidden {
            view.endEditing(true)
            textFieldContainer.isHidden = true
            UIView.animate(withDuration: 0.2, animations: ({ _ in
                self.tableView.contentInset.top = 0
            }))
            return
        }
        
        if let indexPath = tableView.indexPathForRow(at: tap.location(in: tableView)) {
            let bool = taskArray[indexPath.row].value(forKey: "isCompleted")
            taskArray[indexPath.row].setValue(!(bool as! Bool), forKey: "isCompleted")
            let line = UIView()
            line.frame = CGRect(x: 5, y: tableView.cellForRow(at: indexPath)!.bounds.midY-2.5, width: 1, height: 5)
            line.backgroundColor = UIColor.black
            line.layer.cornerRadius = 2.5
            tableView.cellForRow(at: indexPath)!.addSubview(line)
            UIView.animate(withDuration: 0.2, animations: ({ _ in
                line.frame.size.width = self.tableView.cellForRow(at: indexPath)!.bounds.width
            }), completion: ({ _ in
                self.tableView.reloadData()
            }))
        }
        
    }
    
    func delete() {
        
    }
}

class TaskTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: CGFloat(10), dy: CGFloat(10))
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: CGFloat(10), dy: CGFloat(10))
    }
}
