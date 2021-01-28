//
//  TextFieldTableViewCell.swift
//  vlckitSwiftSample
//
//  Created by Mamad Shahib on 11/7/1399 AP.
//  Copyright © 1399 AP Mark Knapp. All rights reserved.
//

import UIKit
enum CellType {
    case subtitle
    case sound
}

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var textField : UITextField!
    @IBOutlet weak var addButton: UIButton!
    var delegate : SubtitleDelegate?
    var type : CellType?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.addButton.layer.cornerRadius = 10
       
        // Configure the view for the selected state
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        print("tapped")
        if textField.text != "" {
                switch type {
                case .sound:
                    self.delegate?.didAddSound(url: textField.text ?? "")
                case .subtitle:
                    self.delegate?.didAddSubtitle(url: textField.text ?? "")
                default:
                    print("ok")
                }
            
        }
    }
}
