//
//  SliderTableViewCell.swift
//  vlckitSwiftSample
//
//  Created by Mamad Shahib on 11/7/1399 AP.
//  Copyright © 1399 AP Mark Knapp. All rights reserved.
//

import UIKit
import MediaPlayer
enum SliderType {
    case sound
    case light
    case contrast
}
class SliderTableViewCell: UITableViewCell {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var containerStack: UIStackView!
    var delegate : SettingsDelegate?
    var sliderType : SliderType?
    let volumeView = MPVolumeView()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if sliderType == .sound {
            guard let safeSlider = slider else {return}
            safeSlider.removeFromSuperview()
            containerStack.addArrangedSubview(volumeView)
        }
    }
    @IBAction func sliderValueDidChange(_ sender: Any) {
   
        switch sliderType {
        case .contrast:
            self.delegate?.contrastDidChange(contrast: Int(slider.value))
            print("1")
        case .light :
            self.delegate?.lightDidChange(light: Int(slider.value))
            print("2")
        case .sound :
            self.delegate?.soundDidChange(sound: Int(slider.value))
            print("3")
        default:
            print("4")
        }
    }
    
}
