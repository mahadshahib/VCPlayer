//
//  SettingsPopOverTableViewController.swift
//  vlckitSwiftSample
//
//  Created by Mamad Shahib on 11/7/1399 AP.
//  Copyright © 1399 AP Mark Knapp. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
class SettingsPopOverTableViewController: UITableViewController , SettingsDelegate {

    func rateDidChanged(rate: Float) {
        print(rate)
        self.delegate?.rateDidChanged(rate: rate)
        
    }
    
    func soundDidChange(sound: Int) {
        self.delegate?.soundDidChange(sound: sound)
    }
    
    func lightDidChange(light: Int) {
        self.delegate?.lightDidChange(light: light)
    }
    
    func contrastDidChange(contrast: Int) {
        self.delegate?.contrastDidChange(contrast: contrast)
    }
    
    var delegate : SettingsDelegate?
    var defualtContrast : Float = 1
    var defualtLight : Float = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
    }
    override func viewWillLayoutSubviews() {
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft:
            fallthrough
        case .landscapeRight:
            let screenHeight = UIScreen.main.bounds.height
            preferredContentSize = CGSize(width: screenHeight*0.7, height: screenHeight*0.7)
        case .portrait:
            fallthrough
        case .portraitUpsideDown:
            let screenWidth = UIScreen.main.bounds.width
            preferredContentSize = CGSize(width: screenWidth*0.7, height: screenWidth*0.7)
        default:
            break
        }
        
        }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "speed", for: indexPath) as! RateTableViewCell
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "slider", for: indexPath) as! SliderTableViewCell
            cell.label.text = "صدا"
            cell.sliderType = .sound
            cell.slider.value  = AVAudioSession.sharedInstance().outputVolume*100
            cell.slider.minimumValueImage = UIImage(systemName: "volume.fill")
            cell.slider.maximumValueImage = UIImage(systemName: "volume.3.fill")
       
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "slider", for: indexPath) as! SliderTableViewCell
            cell.label.text = "روشنایی"
            cell.sliderType = .light
            cell.slider.maximumValue = 180
            cell.slider.minimumValue = -180
            cell.slider.value = defualtLight
            cell.slider.minimumValueImage = UIImage(systemName: "light.min")
            cell.slider.maximumValueImage = UIImage(systemName: "light.max")
         
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "slider", for: indexPath) as! SliderTableViewCell
            cell.label.text = "کنتراست"
            cell.sliderType = .contrast
            cell.slider.maximumValue = 2
            cell.slider.minimumValue = 0
            cell.slider.value = defualtContrast
            cell.slider.minimumValueImage = UIImage(systemName: "sun.min")
            cell.slider.maximumValueImage = UIImage(systemName: "sun.max")
            
            cell.delegate = self
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "slider", for: indexPath) as! SliderTableViewCell
            return cell
        }
     

        // Configure the cell...

    
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
