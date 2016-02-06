//
//  CarritoTableViewCell.swift
//  Suprema Salsa
//
//  Created by Miguel Angel on 11/01/16.
//  Copyright © 2016 miguel mexicano. All rights reserved.
//

import UIKit

class CompraTableViewCell: UITableViewCell {

    
    @IBOutlet weak var figura: UIImageView!
    @IBOutlet weak var producto: UILabel!
    @IBOutlet weak var precio: UILabel!
    
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
