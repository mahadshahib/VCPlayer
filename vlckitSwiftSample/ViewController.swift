//
//  ViewController.swift
//  vlckitSwiftSample
//
//  Created by Mark Knapp on 11/18/15.
//  Copyright © 2015 Mark Knapp. All rights reserved.
//

import UIKit
import MediaPlayer
enum ScreenState {
    case locked
    case unlocked
}
class ViewController: UIViewController, VLCMediaPlayerDelegate {

    @IBOutlet weak var topRightCons: NSLayoutConstraint!
    @IBOutlet weak var topLeftCons: NSLayoutConstraint!
    @IBOutlet weak var controlStack: UIStackView!
    @IBOutlet weak var topLeftStak: UIStackView!
    @IBOutlet weak var topRightStack: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var mainBottom: UIStackView!
    @IBOutlet weak var lockScreenButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var unlockButton: UIButton!
    @IBOutlet weak var aspectRatioButton: UIButton!
  
    var currentScreenState = ScreenState.unlocked
    var movieView: UIView!
    let loader = UIActivityIndicatorView(activityIndicatorStyle: .white)
    var aspectRatioIndex = 0
    var defualtAspect = UnsafeMutablePointer(mutating: ("\(1):\(1)" as NSString).utf8String)
    var seeking = false
    // Enable debugging
    //var mediaPlayer: VLCMediaPlayer = VLCMediaPlayer(options: ["-vvvv"])

    var mediaPlayer: VLCMediaPlayer = VLCMediaPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(loader)
   
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loader.heightAnchor.constraint(equalToConstant: 25).isActive = true
        loader.widthAnchor.constraint(equalToConstant: 25).isActive = true
        loader.startAnimating()
        loader.isHidden = true
        self.view.backgroundColor = .black
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationChanged), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
        topLeftStak.layer.cornerRadius = 15
        topRightStack.layer.cornerRadius = 15
        mainBottom.layer.cornerRadius = 15
        mainBottom.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        topLeftStak.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        topRightStack.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        //Add rotation observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ViewController.rotated),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil)

        //Setup movieView
        self.movieView = UIView()
        self.movieView.backgroundColor = UIColor.black
        self.movieView.frame = UIScreen.screens[0].bounds
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.movieViewTapped(_:)))
              self.movieView.addGestureRecognizer(gesture)

        //setup slider shape
        slider.setThumbImage(UIImage(systemName: "sparkle"), for: .highlighted)
        slider.setThumbImage(UIImage(systemName: "circlebadge.fill"), for: .normal)
        slider.tintColor = .white
        slider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: [.valueChanged , .allTouchEvents])

        //Add movieView to view controller
        self.view.insertSubview(self.movieView, at: 0)
    }

    override func viewDidAppear(_ animated: Bool) {

        //Playing multicast UDP (you can multicast a video from VLC)
        //let url = NSURL(string: "udp://@225.0.0.1:51018")

        //Playing HTTP from internet
        //let url = NSURL(string: "http://streams.videolan.org/streams/mp4/Mr_MrsSmith-h264_aac.mp4")

        //Playing RTSP from internet
        let url = URL(string: "http://streams.videolan.org/streams/mkv/720p.HDTV.AC3.x264.Sample.mkv".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)

        if url == nil {
            print("Invalid URL")
            return
        }

        let media = VLCMedia(url: url!)

        // Set media options
        // https://wiki.videolan.org/VLC_commandaqa-line_help
        media.addOptions([
            "network-caching": 5000,
            "hardware-decoding": false
        
        ])

        mediaPlayer.media = media
        mediaPlayer.addPlaybackSlave(URL(string: "https://raw.githubusercontent.com/andreyvit/subtitle-tools/master/sample.srt"), type: .subtitle, enforce: true)
        mediaPlayer.delegate = self
        mediaPlayer.drawable = self.movieView
        mediaPlayer.play()
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func rotated() {

        let orientation = UIDevice.current.orientation

        if (UIDeviceOrientationIsLandscape(orientation)) {
            print("Switched to landscape")
        }
        else if(UIDeviceOrientationIsPortrait(orientation)) {
            print("Switched to portrait")
        }

        //Always fill entire screen
        self.movieView.frame = self.view.frame

    }

    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        seeking = true
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                // handle drag began
            print("began")
            case .moved:
                // handle drag moved
            print("moved")
            case .ended:
                let totalTime = mediaPlayer.media.length
                let sliderPosition = slider.value
                let time = VLCTime(int: Int32(Float(totalTime.intValue)*sliderPosition))
                let remaingTime = VLCTime(int: Int32(Float(totalTime.intValue)*(1-sliderPosition)))
                timeLabel.text = time?.description
                totalTimeLabel.text = remaingTime?.description
                mediaPlayer.position = sliderPosition
                seeking=false
            default:
                break
            }
        }
    }
    
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
        loader.isHidden = true
        if seeking == false {
        timeLabel.text = mediaPlayer.time.description
        totalTimeLabel.text = mediaPlayer.remainingTime.description
        let progress = mediaPlayer.position
            UIView.animate(withDuration:0.3) { [self] in
                slider.value = progress
            }
       
        }
        
    }
    @IBAction func lockScreenAction(_ sender: Any) {
      lockScreen()
    }
    
    @IBAction func unlockScreenAction(_ sender: Any) {
   unlockScreen()
    }
    @objc func hideUnlockButton() {
        UIView.animate(withDuration:0.3) { [self] in
        unlockButton.isHidden = true
        }
    }
    @objc func showUnlockButton() {
        UIView.animate(withDuration:0.3) { [self] in
        unlockButton.isHidden = false
        }
        perform(#selector(hideUnlockButton), with: nil, afterDelay: 3)
    }
    @objc func lockScreen() {
        currentScreenState = .locked
        UIView.animate(withDuration:0.3) { [self] in
        topLeftStak.isHidden = true
        topRightStack.isHidden = true
        mainBottom.isHidden = true
        unlockButton.isHidden = false
        }
        perform(#selector(hideUnlockButton), with: nil, afterDelay: 3)
    }
    @objc func unlockScreen() {
        currentScreenState = .unlocked
        UIView.animate(withDuration:0.3) { [self] in
        topLeftStak.isHidden = false
        topRightStack.isHidden = false
        mainBottom.isHidden = false
        unlockButton.isHidden = true
        }
        perform(#selector(hideUnlockButton), with: nil, afterDelay: 3)
    }
    @objc func movieViewTapped(_ sender: UITapGestureRecognizer) {

        if currentScreenState == .unlocked {
             lockScreen()
        }
        else {
           showUnlockButton()
        }
        
    }
    @IBAction func backwardAction(_ sender: Any) {
        mediaPlayer.jumpBackward(30)
      
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        if mediaPlayer.isPlaying {
            mediaPlayer.pause()
           
        }
        else {
            mediaPlayer.play()
        }
    }
    
    @IBAction func forwardAction(_ sender: Any) {
        mediaPlayer.jumpForward(30)
    }
    
    @IBAction func aspectRatioChangeAction(_ sender: Any) {
        switch aspectRatioIndex {
        case 4:
            UIView.animate(withDuration:0.2) { [self] in
            mediaPlayer.videoAspectRatio = defualtAspect
            aspectRatioIndex = 0
            }
        case 3:
            UIView.animate(withDuration:0.2) { [self] in
            mediaPlayer.videoAspectRatio = UnsafeMutablePointer(mutating: ("\(16):\(9)" as NSString).utf8String)
            aspectRatioIndex = 4
            }
        case 2:
            UIView.animate(withDuration:0.2) { [self] in
            mediaPlayer.videoAspectRatio = UnsafeMutablePointer(mutating: ("\(383):\(195)" as NSString).utf8String)
            aspectRatioIndex = 3
            }
        case 1:
            UIView.animate(withDuration:0.2) { [self] in
            mediaPlayer.videoAspectRatio = UnsafeMutablePointer(mutating: ("\(16):\(10)" as NSString).utf8String)
            aspectRatioIndex = 2
            }
        case 0:
            UIView.animate(withDuration:0.2) { [self] in
            mediaPlayer.videoAspectRatio = UnsafeMutablePointer(mutating: ("\(19.5):\(9)" as NSString).utf8String)
            aspectRatioIndex = 1
            }
        default:
            print("nothing")
        }
    
    }
    
    @IBAction func dismissPlayer(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
     
    }
    
    @IBAction func settingButtonAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "setting") as! SettingsPopOverTableViewController
          present(vc, animated: true, completion: nil)
    }
    @IBAction func subtitleButtonAction(_ sender: Any) {
    }
    @IBAction func airplayButtonAction(_ sender: Any) {
    }
    
    
    
    
    
    
    
    
    
    @objc func orientationChanged(notification: NSNotification) {
            let deviceOrientation = UIApplication.shared.statusBarOrientation

            switch deviceOrientation {
            case .portrait:
                fallthrough
            case .portraitUpsideDown:
                print("Portrait")
                topLeftCons.constant = 15
                topRightCons.constant = 15
                mainBottom.axis = .vertical
                mainBottom.distribution = .fillEqually
                mainBottom.addArrangedSubview(self.mainBottom.subviews[1])
                self.view.layoutIfNeeded()

            case .landscapeLeft:
                fallthrough
            case .landscapeRight:
                print("landscape")
                topLeftCons.constant = 60
                topRightCons.constant = 60
                mainBottom.axis = .horizontal
                mainBottom.distribution = .fill
                controlStack.spacing = 25
                mainBottom.addArrangedSubview(self.mainBottom.subviews[0])
                self.view.layoutIfNeeded()
            case .unknown:
                print("unknown orientation")
            @unknown default:
                print("unknown case in orientation change")
            }
        }
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
       // print("stateChanged")
        switch mediaPlayer.state {
        case .buffering:
            loader.isHidden = false
            playButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            print("buffering is \(mediaPlayer.state.rawValue)")
        case .ended:
            loader.isHidden = true
            playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            print("ending is \(mediaPlayer.state.rawValue)")
        case .error:
            loader.isHidden = true
            playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            print("error is \(mediaPlayer.state.rawValue)")
        case .opening:
            loader.isHidden = false
            playButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            print("opening is \(mediaPlayer.state.rawValue)")
        case .paused:
            loader.isHidden = true
            playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            print("pause is \(mediaPlayer.state.rawValue)")
        case .playing:
            loader.isHidden = true
            playButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            print("playing is \(mediaPlayer.state.rawValue)")
        case .stopped:
            loader.isHidden = true
            playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            print("stoping is \(mediaPlayer.state.rawValue)")
        case .esAdded:
            print("esAdded")
            defualtAspect = mediaPlayer.videoAspectRatio
        default:
            loader.isHidden = true
        
        }
        
    }
    
}

extension ViewController : SettingsDelegate {
    func rateDidChanged(rate: Float) {
        mediaPlayer.rate = rate
    }
    
    func soundDidChange(sound: Int) {
    
    }
    
    func lightDidChange(light: Int) {
        mediaPlayer.brightness = Float(light)
    }
    
    func contrastDidChange(contrast: Int) {
        mediaPlayer.contrast = Float(contrast)
    }

    
}
