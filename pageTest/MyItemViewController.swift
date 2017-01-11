//
//  MyItemViewController.swift
//  pageTest
//
//  Created by Oleg Naumenko on 12/21/16.
//  Copyright © 2016 Oleg Naumenko. All rights reserved.
//

import UIKit

protocol MyItemViewControllerProtocol {
    
    func viewWillBecomeCurrent(animated:Bool)
    func viewDidBecomeCurrent()
    func viewWillRefuseCurrent(animated:Bool)
    func viewDidRefuseCurrent()
    
}

class MyItemViewController: UIViewController, MyItemViewControllerProtocol {

    var dataLabel: UILabel! = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    var dataObject: String = "placeholder"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var description: String
    {
        return dataObject;
    }
    
    func viewWillBecomeCurrent(animated: Bool) {
        self.dataLabel!.text = dataObject
    }
    
    func viewDidBecomeCurrent() {
        
    }
    
    func viewDidRefuseCurrent() {
        
        
    }
    
    func viewWillRefuseCurrent(animated: Bool) {
        
    }
}
