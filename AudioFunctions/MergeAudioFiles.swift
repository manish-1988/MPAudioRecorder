//
//  MergeAudioFiles.swift
//  AudioFunctions
//
//  Created by qmcpl on 6/20/17.
//  Copyright © 2017 qmcpl. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class MergeAudioFiles: UIViewController , AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    
    @IBOutlet weak var btnRecording: UIButton!
    
    @IBOutlet weak var audioSlider: UISlider!
    
    @IBOutlet weak var lblStart: UILabel!
    
    @IBOutlet weak var lblEnd: UILabel!
    
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var btnMerge: UIButton!
    
    
    var recordingSession : AVAudioSession!
    var audioRecorder    :AVAudioRecorder!
    var settings         = [String : Int]()
     var fileURL1:URL!
    var fileURL2:URL!
    var fileDestinationUrl:URL!
    var isRecord : Bool = true
    var audioPlayer : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //PREVIOUS Recording
         self.audioPlayer = try! AVAudioPlayer(contentsOf: fileURL1!)
           lblEnd.text = "\(audioPlayer.duration)"
        //   durationFile1 = CMTimeMakeWithSeconds(<#T##seconds: Float64##Float64#>, <#T##preferredTimescale: Int32##Int32#>)(audioPlayer.duration)
        //RECORD
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Allow")
                    } else {
                        print("Dont Allow")
                    }
                }
            }
        } catch {
            print("failed to record!")
        }
        
        // Audio Settings
        
        settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    }
    
    
    
    func directoryURL() -> NSURL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        fileURL2 = documentDirectory.appendingPathComponent("sound2.m4a")
        do {
            try  FileManager.default.removeItem(at: fileURL2)
        } catch let error as NSError {
            print(error.debugDescription)
        }
        return fileURL2 as NSURL?
    }
    
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            audioRecorder = try AVAudioRecorder(url: self.directoryURL()! as URL,
                                                settings: settings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            finishRecording(success: false)
        }
        do {
            try audioSession.setActive(true)
            audioRecorder.record()
        } catch {
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        if success {
            print(success)
            self.audioPlayer = try! AVAudioPlayer(contentsOf:fileURL2)
        } else {
            audioRecorder = nil
            print("Somthing Wrong.")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    
    
    //Mark:Action
    @IBAction func click_Recording(_ sender: Any) {
        if isRecord == true {
            
            isRecord = false
            self.btnRecording.setTitle("Stop Recording", for: UIControlState.normal)
            self.btnRecording.backgroundColor = UIColor(red: 119.0/255.0, green: 119.0/255.0, blue: 119.0/255.0, alpha: 1.0)
            self.startRecording()
            
        } else {
            isRecord = true
            self.btnRecording.setTitle("Start 2nd Record", for: UIControlState.normal)
            self.btnRecording.backgroundColor = UIColor(red: 221.0/255.0, green: 27.0/255.0, blue: 50.0/255.0, alpha: 1.0)
            self.finishRecording(success: true)
            
        }
    }
    
    
    
   
    

    
   
    @IBAction func click_Play(_ sender: Any) {
       
        
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.delegate = self
            self.audioPlayer.play()
            
            audioSlider.maximumValue = Float(audioPlayer.duration)
            lblEnd.text = "\(audioPlayer.duration)"
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(playerTimeInterval), userInfo: nil, repeats: true)
        
    }
    
    
    func playerTimeInterval()
    {
        audioSlider.value = Float(audioPlayer.currentTime)
        
        lblStart.text = "\(audioSlider.value)"
    }
    
    
    
    @IBAction func click_Merge(_ sender: Any) {
        
    self.playmerge(audio1: fileURL1! as NSURL, audio2: fileURL2 as NSURL)
    }
    
    
    func playmerge(audio1: NSURL, audio2:  NSURL)
    {
        let composition = AVMutableComposition()
        let compositionAudioTrack1:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        let compositionAudioTrack2:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        self.fileDestinationUrl = documentDirectoryURL.appendingPathComponent("resultmerge.m4a")! as URL
        
        let filemanager = FileManager.default
        if (!filemanager.fileExists(atPath: self.fileDestinationUrl.path))
        {
            do
            {
                try filemanager.removeItem(at: self.fileDestinationUrl)
            }
            catch let error as NSError
            {
                NSLog("Error: \(error)")
            }
            
            
        }
        else
        {
            do
            {
                try filemanager.removeItem(at: self.fileDestinationUrl)
                let alert = UIAlertController(title: "Alert", message: "File Merged Successfuly. Click on play to check", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            catch let error as NSError
            {
                NSLog("Error: \(error)")
            }
            
        }
        
        let url1 = audio1
        let url2 = audio2
        
        let avAsset1 = AVURLAsset(url: url1 as URL, options: nil)
        let avAsset2 = AVURLAsset(url: url2 as URL, options: nil)
        
        var tracks1 = avAsset1.tracks(withMediaType: AVMediaTypeAudio)
        var tracks2 = avAsset2.tracks(withMediaType: AVMediaTypeAudio)
        
        let assetTrack1:AVAssetTrack = tracks1[0]
        let assetTrack2:AVAssetTrack = tracks2[0]
        
        let duration1: CMTime = assetTrack1.timeRange.duration
        let duration2: CMTime = assetTrack2.timeRange.duration
        
        print("duration1 = \(duration1)")
        print("duration2 = \(duration2)")
        
        let timeRange1 = CMTimeRangeMake(kCMTimeZero, duration1)
        let timeRange2 = CMTimeRangeMake(kCMTimeZero, duration2)
        
        print("timeRange1 = \(timeRange1)")
        print("timeRange2 = \(timeRange2)")
        
        
        do
        {
            try compositionAudioTrack1.insertTimeRange(timeRange1, of: assetTrack1, at: kCMTimeZero)
            let nextClipStartTime = CMTimeAdd(kCMTimeZero, timeRange1.duration)
            try compositionAudioTrack2.insertTimeRange(timeRange2, of: assetTrack2, at: nextClipStartTime)
        }
        catch
        {
            print(error)
        }
        
        let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
        assetExport?.outputFileType = AVFileTypeAppleM4A
        assetExport?.outputURL = fileDestinationUrl
        assetExport?.exportAsynchronously(completionHandler:
            {
                switch assetExport!.status
                {
                case AVAssetExportSessionStatus.failed:
                    print("failed \(String(describing: assetExport?.error))")
                case AVAssetExportSessionStatus.cancelled:
                    print("cancelled \(String(describing: assetExport?.error))")
                case AVAssetExportSessionStatus.unknown:
                    print("unknown\(String(describing: assetExport?.error))")
                case AVAssetExportSessionStatus.waiting:
                    print("waiting\(String(describing: assetExport?.error))")
                case AVAssetExportSessionStatus.exporting:
                    print("exporting\(String(describing: assetExport?.error))")
                default:
                    print("complete")
                }
                
                do
                {
                    self.audioPlayer = try! AVAudioPlayer(contentsOf:self.fileDestinationUrl)
                }
                catch let error as NSError
                {
                    print(error)
                }
        })
    }
    
}
