//
//  CuponesTableViewCell.swift
//  Suprema Salsa
//
//  Created by guitarrkurt on 24/01/16.
//  Copyright © 2016 miguel mexicano. All rights reserved.
//

import UIKit

class CuponesTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var figura: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(patternImage: UIImage(named: "cafeClaro.png")!)
        
        bgColorView.layer.cornerRadius = 8
        selectedBackgroundView = bgColorView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
