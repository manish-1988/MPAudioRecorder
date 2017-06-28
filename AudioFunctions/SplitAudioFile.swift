//
//  SplitAudioFile.swift
//  AudioFunctions
//
//  Created by qmcpl on 6/19/17.
//  Copyright © 2017 qmcpl. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SplitAudioFile: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var label_lengthFAudio: UILabel!
    
    @IBOutlet weak var txt_start: UITextField!
    
    @IBOutlet weak var txt_end: UITextField!
    
    @IBOutlet weak var btn_Split: UIButton!
    
    @IBOutlet weak var btn_Play: UIButton!
    
    @IBOutlet weak var audioSlider: UISlider!
    
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblEnd: UILabel!
    
    
    var audioFileOutput:URL!
     var fileURL:URL!
    var audioFile:AnyObject!
    var filecount:Int = 0
     var audioPlayer : AVAudioPlayer!
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.audioPlayer = try! AVAudioPlayer(contentsOf: fileURL!)
        label_lengthFAudio.text = "\(self.audioPlayer.duration)"
         lblEnd.text = "\(audioPlayer.duration)"
       
        
    }
    
    
    @IBAction func click_Split(_ sender: Any) {
        
      
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
         audioFileOutput = documentDirectory.appendingPathComponent("abcdf.m4a")
       print("\(audioFileOutput!)")
        do {
            try  FileManager.default.removeItem(at: audioFileOutput)
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
        let asset = AVAsset.init(url: fileURL)
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
        let startTrimTime: Float = Float(txt_start.text!)!
        let endTrimTime: Float = Float(txt_end.text!)!
        let startTime: CMTime = CMTimeMake(Int64(Int(floor(startTrimTime * 100))), 100)
        let stopTime: CMTime = CMTimeMake(Int64(Int(ceil(endTrimTime * 100))), 100)
        
        let exportTimeRange: CMTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime)
        exportSession?.outputURL = audioFileOutput
        exportSession?.outputFileType = AVFileTypeAppleM4A
        exportSession?.timeRange = exportTimeRange
        exportSession?.exportAsynchronously(completionHandler: {() -> Void in
            if AVAssetExportSessionStatus.completed == exportSession?.status {
                print("Success!")
                self.audioPlayer = try! AVAudioPlayer(contentsOf: self.audioFileOutput)
                self.lblEnd.text = "\(self.audioPlayer.duration)"
                
                let alert = UIAlertController(title: "Alert", message: "File Trimmed Successfuly. Click on play to check", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else if AVAssetExportSessionStatus.failed == exportSession?.status {
                print("failed")
            }
            
        })

    
    }
    
    
    @IBAction func click_Play(_ sender: Any) {
      
        
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.delegate = self
        self.audioPlayer.play()
        
        audioSlider.maximumValue = Float(audioPlayer.duration)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(playerTimeIntervalSplitController), userInfo: nil, repeats: true)
    }
    
    func playerTimeIntervalSplitController()
    {
        audioSlider.value = Float(audioPlayer.currentTime)
        
        lblStart.text = "\(audioSlider.value)"
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print(flag)
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?){
        print(error.debugDescription)
    }
    internal func audioPlayerBeginInterruption(_ player: AVAudioPlayer){
        print(player.debugDescription)
    }

    
    
    
}
