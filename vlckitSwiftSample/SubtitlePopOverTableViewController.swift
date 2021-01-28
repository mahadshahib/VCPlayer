//
//  SubtitlePopOverTableViewController.swift
//  vlckitSwiftSample
//
//  Created by Mamad Shahib on 11/8/1399 AP.
//  Copyright © 1399 AP Mark Knapp. All rights reserved.
//

import UIKit
import MobileCoreServices


class SubtitlePopOverTableViewController: UITableViewController , SubtitleDelegate , UIDocumentPickerDelegate {
    func didAddSubtitle(url: String) {
        print("Recied")
        self.delegate?.didAddSubtitle(url: url)
        DispatchQueue.main.async {
        self.dismiss(animated: true, completion: nil)
        }
    }
    
    func didAddSound(url: String) {
        self.delegate?.didAddSound(url: url)
        DispatchQueue.main.async {
        self.dismiss(animated: true, completion: nil)
        }
    }
    
    var delegate : SubtitleDelegate?
    var localSrts = [URL]()
    override func viewDidLoad() {
        super.viewDidLoad()
       localSrts = findSrtsOnDevice()

    }
    func findSrtsOnDevice() -> [URL] {
        var srts = [URL]()
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl.appendingPathComponent("subtitles"), includingPropertiesForKeys: nil, options: [])
            let srtFiles = directoryContents.filter{ $0.pathExtension == "srt" }
            srts = srtFiles

        } catch {
            print(error.localizedDescription)
        }
        return srts
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 3:
            return localSrts.count
        default:
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textfield", for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            cell.type = .subtitle
            cell.textField.placeholder = "لینک زیرنویس را وارد کنید"
            cell.selectionStyle = .none
            return cell
       
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textfield", for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            cell.type = .sound
            cell.textField.placeholder = "لینک صوت را وارد کنید"
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "srt", for: indexPath)
            cell.textLabel?.text = "اضافه کردن فایل زیرنویس"
            cell.layer.cornerRadius = 10
            cell.backgroundColor = .systemIndigo
            cell.textLabel?.textColor = .white
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell.selectionStyle = .blue
            return cell
        default :
            let cell = tableView.dequeueReusableCell(withIdentifier: "srt", for: indexPath)
            cell.textLabel?.text = localSrts[indexPath.row].lastPathComponent
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            cell.selectionStyle = .blue
            return cell
        
        }

   
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "زیر نویس"
        case 1:
            return "صوت جداگانه"
        case 2:
            return "فایل های اضافه شده"
        default:
            return "زیر نویس های کپی شده"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 2:
       
            let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.srt"], in: UIDocumentPickerMode.import)
              
                documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        case 3:
            let subPath = localSrts[indexPath.row]
            self.delegate?.didAddSubtitle(url: subPath.absoluteString)
            DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            }
        default:
        break
        }
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if controller.documentPickerMode == .import {
            let subPath = urls.first!
            self.delegate?.didAddSubtitle(url: subPath.absoluteString)
            DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            }
        }
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
