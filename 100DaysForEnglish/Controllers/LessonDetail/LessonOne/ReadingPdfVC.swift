//
//  ReadingPdfVC.swift
//  100DaysForEnglish
//
//  Created by Vu Tinh on 2/26/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

import UIKit
import WebKit

class ReadingPdfVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readFilePDF()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readFilePDF() {
        
        if let pdf = NSBundle.mainBundle().URLForResource("Do-Hoang-Viet-TopCV.vn-080217.151736", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(URL: pdf)
            let webView = UIWebView(frame: CGRectMake(20, 20, self.view.frame.size.width - 40, self.view.frame.size.height - 40))
            webView.loadRequest(req)
             view.addSubview(webView)
        }
        
//        if let pdfURL = Bundle.main.url(forResource: "myPDF", withExtension: "pdf", subdirectory: nil, localization: nil)  {
//            do {
//                let data = try Data(contentsOf: pdfURL)
//                let webView = WKWebView(frame: CGRect(x: 20,y: 20,width:view.frame.size.width - 40, height:view.frame.size.height - 40))
//                webView.load(data, mimeType: "application/pdf", characterEncodingName:"", baseURL: pdfURL.deletingLastPathComponent())
//                view.addSubview(webView)
//                
//            }
//            catch {
//                // catch errors here
//            }
//            
//        }
    }
}
