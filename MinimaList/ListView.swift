//
//  ListView.swift
//  MinimaList
//
//  Created by Philipp Eibl on 5/21/17.
//  Copyright © 2017 Philipp Eibl. All rights reserved.
//

import UIKit

class ListView: UIView, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newItemButton: UIButton!
    @IBAction func addNewItem(_ sender: UIButton) {
        titleTextField.inputAccessoryView = customView
        titleTextField.becomeFirstResponder()
    }
    @IBAction func tapped(_ sender: UITapGestureRecognizer) {
    }
    
    var itemArray = [Task]()
    var textField = EditingTextField()
    var customView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        UINib(nibName: "ListView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOpacity = 0.5
//        view.layer.shadowOffset = CGSize.zero
//        view.layer.shadowRadius = 10
        tableView.layer.cornerRadius = 7
        titleTextField.attributedPlaceholder =
            NSAttributedString(string: "Title...", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        newItemButton.layer.cornerRadius = 37
        tableView.contentInset.top = 10
        
        customView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        customView.backgroundColor = UIColor(white: 1, alpha: 1)
        customView.layer.shadowColor = UIColor.black.cgColor
        customView.layer.shadowOpacity = 0.3
        customView.layer.shadowOffset = CGSize.zero
        customView.layer.shadowRadius = 10
        
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont(name: "Quicksand-Regular", size: 18)
        cancelButton.setTitleColor(UIColor.gray, for: .normal)
        cancelButton.frame = CGRect(x: 0, y: 0, width: 80, height: customView.frame.height)
        cancelButton.addTarget(self, action: #selector(self.cancelEditing), for: UIControlEvents.touchUpInside)
        cancelButton.contentHorizontalAlignment = .center
        customView.addSubview(cancelButton)
        
        let addButton = UIButton()
        addButton.setTitle("Add", for: UIControlState.normal)
        addButton.titleLabel?.font = UIFont(name: "Quicksand-Bold", size: 18)
        addButton.setTitleColor(UIColor.black, for: .normal)
        addButton.frame = CGRect(x: view.frame.maxX - 60, y: 0, width: 60, height: customView.frame.height)
        addButton.addTarget(self, action: #selector(self.addItem), for: UIControlEvents.touchUpInside)
        customView.addSubview(addButton)
        
        textField.placeholder = "New..."
        textField.frame = CGRect(x: cancelButton.frame.maxX, y: 10, width: addButton.frame.minX - cancelButton.frame.maxX, height: customView.frame.height-20)
        textField.layer.cornerRadius = 12
        textField.delegate = self
        textField.font = UIFont(name: "Quicksand-Medium", size: 18)
        customView.addSubview(textField)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.textLabel?.font = UIFont(name: "Quicksand-Bold", size: 22)
        cell.selectionStyle = .none
        
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
        itemArray.insert(Task(title: textField.text!), at: 0)
        textField.text = ""
        tableView.reloadData()
    }
    
    func keyboardWillShow() {
        textField.becomeFirstResponder()
    }
    
    func keyboardWillHide() {
        titleTextField.inputAccessoryView = nil
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.endEditing(true)
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let line = UIView()
        line.frame = CGRect(x: self.view.bounds.minX + 10, y: tableView.cellForRow(at: indexPath)!.frame.midY - 5, width: 10, height: 10)
        line.backgroundColor = UIColor.black
        line.clipsToBounds = true
        line.layer.cornerRadius = 5
        tableView.addSubview(line)
        UIView.animate(withDuration: 0.5, animations: ({ _ in
            line.frame.size.width = self.tableView.bounds.width - 20
        }), completion: ({ _ in
            tableView.reloadData()
        }))

    }
    
}

class EditingTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 10, y: bounds.minY, width: bounds.width-10, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 10, y: bounds.minY, width: bounds.width-10, height: bounds.height)
    }
}
