//
//  MenuManager.swift
//  TokenGames
//
//  Created by Jozer on 21/11/2017.
//  Copyright © 2017 Jozer. All rights reserved.
//

import UIKit

class MenuManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    //Declarations:
    let blackView = UIView()
    let menuTableView = UITableView()
    let arrayOfSorts = ["by A to Z", "by Z to A", "by Release Date (Newest First)", "by Release Date (Latest First)"]
    var mainVC: ViewController?
    
    
    //Opening Animations:
    public func openMenu() {
        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            blackView.backgroundColor = UIColor (white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissMenu)))
            
            let height: CGFloat = 200
            
            let y = window.frame.height - height
            
            menuTableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            window.addSubview(blackView)
            window.addSubview(menuTableView)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.blackView.alpha = 1
                self.menuTableView.frame.origin.y = y
            })
        }
    }
    
    
    //Closing Animations:
    @objc public func dismissMenu(){
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow{
                self.menuTableView.frame.origin.y = window.frame.height
            }
        })
    }
    
    
    //Menu Options:
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfSorts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = arrayOfSorts[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = mainVC {
            if indexPath.item == 0{
                vc.sortByNameAZ()
            }
            if indexPath.item == 1{
                vc.sortByNameZA()
            }
            if indexPath.item == 2{
                vc.sortByDateDesc()
            }
            if indexPath.item == 3{
                vc.sortByDateAsc()
            }
        }
        self.dismissMenu()
    }
    
    
    //Initialization
    override init(){
        super.init()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        menuTableView.isScrollEnabled = false
        menuTableView.bounces = false
        
        menuTableView.register(BaseViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
    }
}
