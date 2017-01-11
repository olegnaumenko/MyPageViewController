//
//  MyPageViewController.swift
//  pageTest
//
//  Created by Oleg Naumenko on 12/20/16.
//  Copyright © 2016 Oleg Naumenko. All rights reserved.
//

import Foundation
import UIKit

class MyPageViewController:UIViewController, UIScrollViewDelegate
{
    
    let scrollView:UIScrollView = UIScrollView.init(frame: .zero)
    var viewControllers: [UIViewController?]? = []
    weak var dataSource: MyPageViewControllerDatasource?
    var contentOffsetX:CGFloat = 0.0
    var dragStartOffsetX:CGFloat = 0.0
    var direction:Int = 0
    var dragging:Bool = false
    var decelerating:Bool = false
    
    var allowScrolledDelegation:Bool = true;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        
        
    }
    
    override func viewDidLoad() {
        
        var rect = (self.view?.bounds)!
        rect.origin.x = 0
        rect.origin.y = 0
        
        var size:CGSize = rect.size
        let pageWidth = size.width
        
        self.scrollView.frame = rect
        self.scrollView.backgroundColor = UIColor.orange
        self.scrollView.isPagingEnabled = true
        
        size.width *= 3
        self.scrollView.contentSize = size
        self.scrollView.contentOffset = CGPoint(x:0.0, y:0.0)
        self.scrollView.isDirectionalLockEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.alwaysBounceHorizontal = true
//        self.scrollView.bounces 
        self.view!.addSubview(self.scrollView)
        self.scrollView.delegate = self
    }
        
    func layoutVCs()
    {
        let rect = (self.view?.bounds)!
        var size:CGSize = rect.size
        let pageWidth = size.width
        let pageHeight = size.height
        
        if let count = self.viewControllers?.count
        {
            size.width *= CGFloat(count)
            
            let xCoords = [pageWidth, 0.0, 2.0*pageWidth]
            var i:Int = 0
            for vc in self.viewControllers! {
                
                if let availVC = vc {
                    
                    if let availView = availVC.view {
                        
                        let frame = CGRect(x: xCoords[i], y: 0, width: pageWidth, height: pageHeight)
                        
                        availView.frame = frame
                        
                        if (availView.superview) == nil {
                            self.scrollView.addSubview(availView);
                        }
                    }
                    
                }
                i = i + 1
            }
            if self.viewControllers?.count == 3 {
                print("vcs: \(self.viewControllers?[1]) - \(self.viewControllers?[0]) - \(self.viewControllers?[2])")
//                print("coords: \(self.viewControllers?[1]?.view.frame.origin.x) - \(self.viewControllers?[0]?.view.frame.origin.x) - \(self.viewControllers?[2]?.view.frame.origin.x)")
//                print("content Offset: \(self.scrollView.contentOffset.x)")
//            }
                
                var insets = UIEdgeInsets()
                
                if self.viewControllers?[1] == nil {
                    insets.left = -pageWidth;
                }
                
                if self.viewControllers?[2] == nil {
                    insets.right = -pageWidth
                }
                self.scrollView.contentInset = insets
            }
        
        } else {
            assert(false)
        }
    }
    
    func setViewControllers(vcs:[UIViewController?], animated:Bool)
    {
        self.viewControllers = vcs
        self.layoutVCs()
    }
    
    func reload(animated:Bool)
    {
        if let current = self.dataSource?.currentControllerForPageViewController(pageViewController: self) {
            let previous = self.dataSource?.pageViewController(pageViewController: self, beforeViewController: current)
            let next = self.dataSource?.pageViewController(pageViewController: self, afterViewController: current)
            self.setViewControllers(vcs: [current, previous, next], animated: animated)
            
            self.allowScrolledDelegation = false
            self.scrollView.contentOffset = CGPoint(x:(self.view?.bounds.size.width)!, y:0)
            self.allowScrolledDelegation = true
            
            
            assert(self.viewControllers?.count == 3)
        }
    }
    
    
    func moveLeft()
    {
        print("MOVE LEFT<<<<")
        
        self.allowScrolledDelegation = false;
        
        var oldArray = self.viewControllers!
        
        if let oldRight = oldArray[2] {
            
            let rightVC = self.dataSource?.pageViewController(pageViewController: self, afterViewController:oldRight)
            let newArray = [oldArray[2], oldArray[0], rightVC]
            
            
            if let vcToAdd = rightVC, let viewToAdd = rightVC?.view {
                self.scrollView.addSubview(viewToAdd)
            }
            if let vcToDelete = oldArray[1] {
                vcToDelete.view?.removeFromSuperview()
            }
//            print("newarray left: \(newArray[1]) - \(newArray[0]) - \(newArray[2])")
            
            self.setViewControllers(vcs: newArray, animated: false)
            
            let rect = (self.view?.bounds)!
            let size:CGSize = rect.size
            let pageWidth = size.width
            
            self.scrollView.contentOffset = CGPoint(x:self.scrollView.contentOffset.x - pageWidth, y:0)
            

            
        } else {
            print("Fail LEFT")
        }
        self.allowScrolledDelegation = true
    }
    
    func moveRight()
    {
        print("MOVE RIGHT>>>")
        
        self.allowScrolledDelegation = false;
        
        var oldArray = self.viewControllers!
        
        if let oldLeft = oldArray[1] {
            
            let leftVC = self.dataSource?.pageViewController(pageViewController: self, beforeViewController:oldLeft)
            
            let newArray = [oldArray[1], leftVC, oldArray[0]]
            
            
            if let vcToAdd = leftVC, let viewToAdd = leftVC?.view {
                self.scrollView.addSubview(viewToAdd)
            }
            
            if let vcToDelete = oldArray[2] {
                vcToDelete.view?.removeFromSuperview()
            }
//            print("newarray right: \(newArray[1]) - \(newArray[0]) - \(newArray[2])")
            
            self.setViewControllers(vcs: newArray, animated: false)
            
            let rect = (self.view?.bounds)!
            let size:CGSize = rect.size
            let pageWidth = size.width
            self.scrollView.contentOffset = CGPoint(x:self.scrollView.contentOffset.x + pageWidth, y:0)
            
        } else {
            
            print("Fail RIGHT")
        }
        self.allowScrolledDelegation = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let newOffsetX = scrollView.contentOffset.x
        
//        print("Offset: \(newOffsetX), left inset: \(scrollView.contentInset.left)")
//        print("c Offset: \(self.contentOffsetX)")
        
        if self.contentOffsetX == newOffsetX {
            return
        }
        
        if newOffsetX < 0 || newOffsetX > 2*self.view.bounds.size.width  {
            return
        }
        
        let newDirection = newOffsetX < self.contentOffsetX ? -1 : 1
        
        if self.allowScrolledDelegation && !self.decelerating {
        
            if self.direction != newDirection {
                self.direction = newDirection
                if newDirection == -1, scrollView.contentInset.right == 0 {
                    self.moveRight()
                } else if newDirection == 1, scrollView.contentInset.left == 0 {
                    self.moveLeft()
                }
                
            }
            self.contentOffsetX = scrollView.contentOffset.x
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("drag begin")
        self.contentOffsetX = scrollView.contentOffset.x
        self.dragStartOffsetX = scrollView.contentOffset.x
        self.direction = 0
        self.dragging = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("drag end, will dec = \(decelerate)")
        self.dragging = false
        if decelerate == false {
            self.direction = 0
            let newOffsetX = scrollView.contentOffset.x
            
            if newOffsetX != self.view.bounds.size.width {
                if newOffsetX == 2 * self.view.bounds.size.width {
                    self.moveLeft()
                } else if newOffsetX == 0 {
                    self.moveRight()
                }
                self.allowScrolledDelegation = false
                scrollView.contentOffset = CGPoint(x:self.view.bounds.size.width, y:0);
                self.allowScrolledDelegation = true
            }
        }
        self.contentOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        print("drag will end \(targetContentOffset.pointee as CGPoint)")
//        var point = targetContentOffset.pointee as CGPoint
//        point.x = self.view.bounds.size.width
//        targetContentOffset.pointee = point
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        print("decelerate end: \(scrollView.contentOffset.x)")
        
        let newOffsetX = scrollView.contentOffset.x
        
        if newOffsetX != self.view.bounds.size.width {
            if newOffsetX == 2 * self.view.bounds.size.width {
                self.moveLeft()
            } else if newOffsetX == 0 {
                self.moveRight()
            }
            self.allowScrolledDelegation = false
            scrollView.contentOffset = CGPoint(x:self.view.bounds.size.width, y:0);
            self.allowScrolledDelegation = true
        }
        
        self.contentOffsetX = scrollView.contentOffset.x
        
        self.decelerating = false
        
        print("content Offset: \(self.scrollView.contentOffset.x)")
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        print("decelerate begin")
        self.decelerating = true
        self.contentOffsetX = scrollView.contentOffset.x
    }
}

protocol MyPageViewControllerDatasource: class {
    
    func currentControllerForPageViewController(pageViewController:MyPageViewController) -> UIViewController
    
    func pageViewController(pageViewController:MyPageViewController, beforeViewController:UIViewController) -> UIViewController?

    func pageViewController(pageViewController:MyPageViewController, afterViewController:UIViewController) -> UIViewController?
    
//    func pageViewControllerWillStartSwipe(pageViewController:MyPageViewController)
//    
//    func pageViewControllerDidSwipe(pageViewController:MyPageViewController, completed:Bool, cancelled:Bool)
}
