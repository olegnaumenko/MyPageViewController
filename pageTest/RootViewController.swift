//
//  RootViewController.swift
//  pageTest
//
//  Created by Oleg Naumenko on 12/20/16.
//  Copyright © 2016 Oleg Naumenko. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    var pageViewController: MyPageViewController?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Configure the page view controller and add it as a child view controller.
        self.pageViewController = MyPageViewController.init()
        //        self.pageViewController!.delegate = self
        
        self.pageViewController!.dataSource = self.modelController

        let startingViewController: UIViewController = self.modelController.viewControllerAtIndex(11, storyboard: self.storyboard!)!
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(vcs: viewControllers, animated: false)
        self.pageViewController!.reload(animated: false)
//        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })

        
        

        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)

        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        var pageViewRect = self.view.bounds
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageViewRect = pageViewRect.insetBy(dx: 40.0, dy: 40.0)
        }
        self.pageViewController!.view.frame = pageViewRect

        self.pageViewController!.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var modelController: ModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = ModelController()
        }
        return _modelController!
    }

    var _modelController: ModelController? = nil


}

