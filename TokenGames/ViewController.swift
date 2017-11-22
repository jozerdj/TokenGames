//
//  ViewController.swift
//  TokenGames
//
//  Created by Jozer on 19/11/2017.
//  Copyright © 2017 Jozer. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //UI Declarations
    @IBOutlet var tableview: UITableView!
    @IBOutlet var buttonSort: UIBarButtonItem!
    
    
    //Declarations
    var games: [Game]? = []
    var refresher: UIRefreshControl!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    //Start View:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Activity Indicator:
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        
        //Pull to refresh:
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(fetchGames), for: UIControlEvents.valueChanged)
        tableview.addSubview(refresher)

        //Fetch the data
        fetchGames()
        
        
    }

    
    //Memory Warning:
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //Fetch Games data from JSON:
    @objc func fetchGames(){
        let urlRequest = URLRequest(url: URL(string: "https://dl.dropboxusercontent.com/s/1b7jlwii7jfvuh0/games")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            self.games = [Game]()
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let gamesFromJson = json["games"] as? [[String : AnyObject]] {
                    for gameInJson in gamesFromJson {
                        let game = Game()
                        if let title = gameInJson["name"] as? String, let releaseDate = gameInJson["release_date"] as? String, let platform = gameInJson["platforms"] as? [String], let urlImage = gameInJson["image"] as? String, let urlVideo = gameInJson["trailer"] as? String {
                            
                            game.title = title
                            game.releaseDate = releaseDate
                            game.platform = platform
                            game.urlImage = urlImage
                            game.urlVideo = urlVideo
                        }
                        self.games?.append(game)
                    }
                }
                DispatchQueue.main.async{
                    self.tableview.reloadData()
                    self.refresher.endRefreshing()                          //End Refresher
                    self.activityIndicator.stopAnimating()                  //End Activity Indicator
                    UIApplication.shared.endIgnoringInteractionEvents()     //Return UI Controls to User
                }
            } catch let error{
                print(error)
            }
        }
        task.resume()
    }
    
    //Button(Menu):
    let menuManager = MenuManager()
    @IBAction func sortPressed(_ sender: UIButton) {
        menuManager.openMenu()
        menuManager.mainVC = self
    }
    
    
    //Sort Data:
    func sortByNameAZ(){
        let sorted = (self.games?.sorted(by: {$0.title! < $1.title!}))!
        
        self.games = sorted
        
        DispatchQueue.main.async{
            self.tableview.reloadData()
        }
    }
    
    func sortByNameZA(){
        let sorted = (self.games?.sorted(by: {$0.title! > $1.title!}))!
        
        self.games = sorted
        
        DispatchQueue.main.async{
            self.tableview.reloadData()
        }
    }
    
    func sortByDateDesc(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let sorted = (self.games?.sorted(by: {dateFormatter.date(from: $0.releaseDate!)?.compare(dateFormatter.date(from: $1.releaseDate!)!) == .orderedDescending}))!
        
        self.games = sorted
        
        DispatchQueue.main.async{
            self.tableview.reloadData()
        }
    }
    
    func sortByDateAsc(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let sorted = (self.games?.sorted(by: {dateFormatter.date(from: $0.releaseDate!)?.compare(dateFormatter.date(from: $1.releaseDate!)!) == .orderedAscending}))!
        
        self.games = sorted
        
        DispatchQueue.main.async{
            self.tableview.reloadData()
        }
    }
    
    
    //TableView Display and Action:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameCell
        
        cell.title.text = self.games?[indexPath.item].title
        cell.releaseDate.text = self.games?[indexPath.item].releaseDate
        
        
        let text = self.games?[indexPath.item].platform?.joined(separator: ", ")
        
        cell.platform.text = text
        
        cell.imgView.downloadImage(from: (self.games?[indexPath.item].urlImage)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as! WebViewController
        
        webVC.url = self.games?[indexPath.item].urlVideo
        
        self.present(webVC, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.games?.count ?? 0
    }

}


extension UIImageView{
    //Download image data:
    func downloadImage(from url: String){
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        if let image = imageCache[url]{
            self.image = image
        }else{
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                let image = UIImage(data: data!)
                
                imageCache[url] = image
                
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            task.resume()
        }
        
    }
    
}

