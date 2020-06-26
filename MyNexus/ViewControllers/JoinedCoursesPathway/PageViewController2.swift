 //
 //  PageViewController.swift
 //  Calendar
 //
 //  Created by Jeffrey Bennet on 5/18/20.
 //  Copyright © 2020 Jeffrey Bennet. All rights reserved.
 //

 import UIKit

 class PageViewController2: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
     // MARK: Data source functions.
     var finalName = ""
     var code = ""
    var classColor = ""
    var pageControl = UIPageControl()
     lazy var orderedViewControllers: [UIViewController] = {
        for s in Constants.joinedClassVisits{
            if s == code{
                Constants.firstTimeAtJoinedAssignments = false
            }
            else{
                Constants.firstTimeAtJoinedAssignments = true
                Constants.joinedClassVisits.append(code)
            }
        }
        
         let oVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JoinedScheduleNameViewController") as! JoinedScheduleNameViewController
        
        let sVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JoinedSettingsViewController") as! JoinedSettingsViewController
        
        if finalName != "" && code != "" {
         oVC.finalName1 = finalName
            oVC.color = classColor
            oVC.finalCode = code
            sVC.classCode = code
            sVC.className = finalName
            
         }
         return [oVC,sVC]
     }()
     
     override func viewDidLoad() {
     super.viewDidLoad()
         self.dataSource = self
         loadTheView()
         // This sets up the first view that will show up on our page control
         self.delegate = self
                       configurePageControl()
                
         
     }
     func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
         let pageContentViewController = pageViewController.viewControllers![0]
         self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
     }
     func configurePageControl() {
         // The total number of pages that are available is based on how many available colors we have.
         pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
         self.pageControl.numberOfPages = orderedViewControllers.count
         self.pageControl.currentPage = 0
         self.pageControl.tintColor = UIColor.black
         self.pageControl.pageIndicatorTintColor = UIColor.white
         self.pageControl.currentPageIndicatorTintColor = UIColor(named: "newBlue")
         self.view.addSubview(pageControl)
     }
     
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
         guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
             return nil
         }
         
         let previousIndex = viewControllerIndex - 1
         
         // User is on the first view controller and swiped left to loop to
         // the last view controller.
         guard previousIndex >= 0 else {
             return orderedViewControllers.last
             // Uncommment the line below, remove the line above if you don't want the page control to loop.
             // return nil
         }
         
         guard orderedViewControllers.count > previousIndex else {
             return nil
         }
         
         return orderedViewControllers[previousIndex]
     }
     
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
         guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
             return nil
         }
         
         let nextIndex = viewControllerIndex + 1
         let orderedViewControllersCount = orderedViewControllers.count
         
         // User is on the last view controller and swiped right to loop to
         // the first view controller.
         guard orderedViewControllersCount != nextIndex else {
             return orderedViewControllers.first
             // Uncommment the line below, remove the line above if you don't want the page control to loop.
             // return nil
         }
         
         guard orderedViewControllersCount > nextIndex else {
             return nil
         }
         
         return orderedViewControllers[nextIndex]
     }

     
 func loadTheView() {
         if let firstViewController = orderedViewControllers.first {
             
         
            
             setViewControllers([firstViewController],
             direction: .forward,
             animated: true,
             completion: nil)
     }
     
     func newVc(viewController: String) -> UIViewController {
         return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
     }
     /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
         // Drawing code
     }
     */


 }

 }

