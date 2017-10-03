//
//  ViewController.swift
//  Table_View_With_Multiple_Cell
//
//  Created by hieunt52 on 10/2/17.
//  Copyright © 2017 hieunt52. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //
    @IBOutlet weak var tableView: UITableView!
    //
    fileprivate let viewModel = ProfileViewModel()
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView?.dataSource = viewModel
        
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        
        tableView?.register(AboutCell.nib, forCellReuseIdentifier: AboutCell.identifier)
        tableView?.register(NamePictureCell.nib, forCellReuseIdentifier: NamePictureCell.identifier)
        tableView?.register(FriendCell.nib, forCellReuseIdentifier: FriendCell.identifier)
        tableView?.register(AttributeCell.nib, forCellReuseIdentifier: AttributeCell.identifier)
        tableView?.register(EmailCell.nib, forCellReuseIdentifier: EmailCell.identifier)
        //
        let tableviews = view.subviews.flatMap({ $0 as? UITableView })[0]
        tableviews.backgroundColor = UIColor.brown
        print(tableviews)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

