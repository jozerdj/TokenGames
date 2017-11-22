//
//  WebViewController.swift
//  TokenGames
//
//  Created by Jozer on 20/11/2017.
//  Copyright © 2017 Jozer. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    //UI Declarations:
    @IBOutlet var webview: UIWebView!
    @IBOutlet var progressBar: UIProgressView!
    
    
    //Declarations:
    var url: String?
    
    var timeBool: Bool?
    var timer: Timer?
    
    
    //Open URL:
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.delegate = self
        webview.loadRequest(URLRequest(url: URL(string: url!)!))
    }

    
    //Memory Warning:
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //ProgressBar:
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.progressBar.progress = 0.0
        self.timeBool = false
        self.timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(timerCallBack), userInfo: nil, repeats: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.timeBool = true
    }
    
    @objc func timerCallBack(){
        self.progressBar.progress += 0.05
        if self.timeBool == true {
            if self.progressBar.progress >= 1 {
                self.progressBar.isHidden = true
                self.timer?.invalidate()
            }else{
                self.progressBar.progress += 0.1
            }
        }else{
            self.progressBar.progress += 0.05
            if self.progressBar.progress >= 0.95{
                self.progressBar.progress = 0.95
            }
        }
    }
    
    

}
