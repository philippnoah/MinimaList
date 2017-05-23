//
//  ListView.swift
//  MinimaList
//
//  Created by Philipp Eibl on 5/21/17.
//  Copyright © 2017 Philipp Eibl. All rights reserved.
//

import UIKit

class ListView: UIView, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newItemButton: UIButton!
    @IBAction func addNewItem(_ sender: UIButton) {
        titleTextField.becomeFirstResponder()
    }
    
    var itemArray = [String]()
    var textField = EditingTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        UINib(nibName: "ListView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        tableView.layer.cornerRadius = 7
        titleTextField.text = "Title..."
        newItemButton.layer.cornerRadius = 37
        tableView.contentInset.top = 10
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        customView.backgroundColor = UIColor.black
        
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: UIControlState.normal)
        cancelButton.frame = CGRect(x: 0, y: 0, width: 80, height: customView.frame.height)
        cancelButton.addTarget(self, action: #selector(self.cancelEditing), for: UIControlEvents.touchUpInside)
        cancelButton.contentHorizontalAlignment = .center
        customView.addSubview(cancelButton)
        
        let addButton = UIButton()
        addButton.setTitle("Add", for: UIControlState.normal)
        addButton.frame = CGRect(x: view.frame.maxX - 60, y: 0, width: 40, height: customView.frame.height)
        addButton.addTarget(self, action: #selector(self.addItem), for: UIControlEvents.touchUpInside)
        customView.addSubview(addButton)
        
        textField.placeholder = "New..."
        textField.frame = CGRect(x: cancelButton.frame.maxX, y: 10, width: addButton.frame.minX - cancelButton.frame.maxX, height: customView.frame.height-20)
        textField.layer.cornerRadius = 20
        textField.backgroundColor = UIColor.white
        textField.delegate = self
        customView.addSubview(textField)
        
        titleTextField.inputAccessoryView = customView
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        UINib(nibName: "ListView", bundle: nil).instantiate(withOwner: self, options: nil)
//        addSubview(view)
//        view.frame = self.bounds
//        tableView.layer.cornerRadius = 10
//        titleTextField.placeholder = "New List..."
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect.zero)
        cell.textLabel?.text = itemArray[indexPath.row]
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func cancelEditing() {
        self.endEditing(true)
    }
    
    func addItem() {
        self.endEditing(true)
        itemArray.insert(textField.text!, at: 0)
        textField.text = ""
        tableView.reloadData()
    }
    
    func keyboardWillShow() {
        textField.becomeFirstResponder()
    }
    
}

class EditingTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: bounds.minY, width: bounds.width, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: bounds.minY, width: bounds.width, height: bounds.height)
    }
}
