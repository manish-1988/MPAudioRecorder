//
//  MPAudioSessionConfig.swift
//  AudioFunctions
//
//  Created by MANISH_iOS on 28/06/17.
//  Copyright © 2017 iDevelopers. All rights reserved.
//

import UIKit
import AVFoundation

/// This class will be responsible for configuring the Audio session
class MPAudioSessionConfig: NSObject
{
    /// AVAudio session
    public var mpAudioSession     : AVAudioSession!
    
    /// Singleton object for MPAudioSessionConfig
    static let shared = MPAudioSessionConfig()
    
    /// Initialising the AVAudioSession for recording
    ///
    /// - Parameter completionHandlerWithGrantPermission: Permission status that is granted or not will be return with success true and failed false.
    public func initialiseRecordingSession( completionHandlerWithGrantPermission :@escaping (_ permissionStatus : Bool, _ mpAudioSession: AVAudioSession?) -> Void)
    {
        if mpAudioSession == nil
        {
            mpAudioSession = AVAudioSession.sharedInstance()
            do {
                
                try mpAudioSession.setCategory(AVAudioSession.Category.playAndRecord)
                try mpAudioSession.setActive(true)
                
                mpAudioSession.requestRecordPermission()
                { [unowned self] allowed in
                    DispatchQueue.main.async
                    {
                        if allowed
                        {
                            completionHandlerWithGrantPermission(true, self.mpAudioSession)
                        } else
                        {
                            completionHandlerWithGrantPermission(false, nil)
                        }
                    }
                }
            } catch
            {
                completionHandlerWithGrantPermission(false, nil)
            }
        }
    }
    
    class func getDirectoryURLForFileName(fName : String) -> URL?
    {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent("\(fName).m4a")
        do
        {
            try FileManager.default.removeItem(at: soundURL)
        } catch let error as NSError
        {
            print(error.debugDescription)
        }
        return soundURL as URL?
    }
    
    class func getDefaultAudioSettings() -> [String : Int]
    {
        return [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    }
}
