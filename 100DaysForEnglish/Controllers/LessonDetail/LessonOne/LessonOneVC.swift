//
//  LessonOneVC.swift
//  100DaysForEnglish
//
//  Created by Vu Tinh on 2/24/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

import UIKit

class LessonOneVC: UIViewController,CAPSPageMenuDelegate {

    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var readingsImage: UIImageView!
    @IBOutlet weak var readingsLabel: UILabel!
    @IBOutlet weak var readingsIndicatorView: UIView!
    
    @IBOutlet weak var dictionaryLabel: UILabel!
    @IBOutlet weak var dictionaryImage: UIImageView!
    
    @IBOutlet weak var dictionaryIndicatorView: UIView!
    
    var pageMenuIndex : Int = 0
    var pageMenu: CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupPageMenu() {
        var controllerArray : [UIViewController] = []
        // get your storyboard
        let storyboard = UIStoryboard(name: "LessonOne", bundle: nil)
        let readingPdfVC : ReadingPdfVC = storyboard.instantiateViewControllerWithIdentifier("ReadingPdfVC") as! ReadingPdfVC
        readingPdfVC.title = "Bài đọc"
        controllerArray.append(readingPdfVC)
        
        let dictionaryVC : DictionaryVC = storyboard.instantiateViewControllerWithIdentifier("DictionaryVC") as! DictionaryVC
        dictionaryVC.title = "Từ điển"
        controllerArray.append(dictionaryVC)
        
        let screenWidth = (UIScreen.mainScreen().bounds.width / 2)
        let parameters: [CAPSPageMenuOption] = [
            .SelectedMenuItemLabelColor(UIColor.whiteColor()),
            .UnselectedMenuItemLabelColor(UIColor(hex: 0xDADADA)),
            .ScrollMenuBackgroundColor(UIColor(hex: 0x16244D)),
            .MenuItemSeparatorWidth(0.5),
            .MenuItemSeparatorColor(UIColor.blackColor()),
            .SelectionIndicatorHeight(5),
            .AddBottomMenuHairline(false),
            .MenuItemFont(UIFont.boldSystemFontOfSize(13)),
            .MenuHeight(0),
            .MenuItemWidth(screenWidth),
            .EnableHorizontalBounce(false),
            ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.mainView.frame.size.width, self.mainView.frame.size.height), pageMenuOptions: parameters)
        pageMenu?.delegate = self
        self.mainView.addSubview(pageMenu!.view)
    }
    @IBAction func readingTap(sender: UITapGestureRecognizer) {
        setupReadingWhenTap()
        pageMenu?.moveToPage(0)
        pageMenuIndex = 0
    }
    @IBAction func dictionaryTap(sender: UITapGestureRecognizer) {
        setupDictionaryWhenTap()
        pageMenu?.moveToPage(1)
        pageMenuIndex = 1
    }

    @IBAction func backbutton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //MARK: - CAPSPageMenuDelegate
    func didMoveToPage(controller: UIViewController, index: Int){
        if index == 0 {
            setupReadingWhenTap()
            pageMenuIndex = 0
        }else{
            setupDictionaryWhenTap()
            pageMenuIndex = 1
        }
    }

    func setupReadingWhenTap() {
        
    }
    
    func setupDictionaryWhenTap() {
        
    }
    
}
