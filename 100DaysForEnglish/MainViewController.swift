//
//  MainViewController.swift
//  100DaysForEnglish
//
//  Created by Vu Tinh on 2/12/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    var listDays : [Int] = {
        var result = [Int]()
        for item in 0 ... 60 {
            result += [item]
        }
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDays.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID.listdayTableCell, forIndexPath: indexPath) as! ListdayTableCell
            cell.daysLabel.setTitle("Ngày \(listDays[indexPath.row])", forState: UIControlState.Normal)
        return cell
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // get your storyboard
//        let storyboard = UIStoryboard(name: "LessonDetail", bundle: nil)
//        
//        let lessonDetail = storyboard.instantiateViewControllerWithIdentifier("LessonDetailTabbarController") as! LessonDetailTabbarController
        
        
        
//    }
}

