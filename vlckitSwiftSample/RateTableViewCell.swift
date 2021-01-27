//
//  RateTableViewCell.swift
//  vlckitSwiftSample
//
//  Created by Mamad Shahib on 11/7/1399 AP.
//  Copyright © 1399 AP Mark Knapp. All rights reserved.
//

import UIKit

class RateTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rateSegmentController: UISegmentedControl!
     var delegate : SettingsDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func videoRateDidChange(_ sender: Any) {
        self.delegate?.rateDidChanged(rate: Float((self.rateSegmentController.selectedSegmentIndex+1))*0.5)
    }
    
}
