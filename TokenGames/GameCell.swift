//
//  GameCell.swift
//  TokenGames
//
//  Created by Jozer on 20/11/2017.
//  Copyright © 2017 Jozer. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {
    
    //UI Declarations:
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var releaseDate: UILabel!
    @IBOutlet var platform: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
