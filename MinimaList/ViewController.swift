//
//  ViewController.swift
//  MinimaList
//
//  Created by Philipp Eibl on 5/21/17.
//  Copyright © 2017 Philipp Eibl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var newListButton: UIButton!

    var listArray = [ListView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        addNewListView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func newListButtonPressed(_ sender: UIButton) {
        addNewListView()
    }

    func addNewListView() {
        let frame = CGRect(origin: CGPoint(x: scrollView.frame.width * CGFloat(listArray.count), y: 0), size: scrollView.bounds.size)
        let listView = ListView(frame: frame)
        listArray.append(listView)
        scrollView.contentSize.width = scrollView.frame.width * CGFloat(listArray.count)
        scrollView.addSubview(listView)
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width * CGFloat(listArray.count - 1), y: 0), animated: true)
    }
}

