//
//  MPAudioRecorder.swift
//  AudioFunctions
//
//  Created by MANISH_iOS on 28/06/17.
//  Copyright © 2017 iDevelopers. All rights reserved.
//

//MARK:- Protocol
/// This is a mandatory protocol you should implement
@objc protocol MPAudioRecorderDelegate
{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    @objc optional func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?)
    @objc optional func audioRecorderBeginInterruption(_ recorder: AVAudioRecorder)
    @objc optional func audioRecorderEndInterruption(_ recorder: AVAudioRecorder, withOptions flags: Int)
    
    /// This will invoke after audio session permission request response comes.
    ///
    /// - Parameter granted: Granted will be true if the permission is granted else it will be false.
    @objc optional func audioSessionPermission(granted: Bool)
    
    /// This function will be called if there is a failure
    ///
    /// - Parameter errorMessage: Error message
    func audioRecorderFailed(errorMessage: String)
    
}

import UIKit
import AVFoundation

//MARK:- Class MPAudioRecorder
/// This class is responsible for recording.
class MPAudioRecorder: NSObject
{
    /// AVAudio session
    private var recordingSession     : AVAudioSession!
    
    /// AVAudio recorder
    private var audioRecorder        : AVAudioRecorder!
    
    /// Settings, audio settings for a recorded audio
    public var audioSettings        : [String : Int]?
    
    /// File name, Name of the audio file with which user wants to save it
    public var audioFileName: String?
    
    /// Custom url if any user wants to save the recorded Audio file at specific location
    public var customPath: String?
    
    /// If user wants the recorded audio filed to be saved to the iPhone's library
    public var shouldSaveToLibrary: Bool = false
    
    /// If user want delegates methods to be implemented in their class
    public var delegateMPAR: MPAudioRecorderDelegate?
    
    override init()
    {
        super.init()
        initialiseRecordingSession()
    }
    
    //MARK:- Custom Functions
    /// This function will start the audio recording, If Audio File name & destination URL is not provided it will take the default values
    public func  startAudioRecording()
    {
        if recordingSession == nil
        {
            initialiseRecordingSession()
        }else
        {
            unowned let unownedSelf = self // To handle unseen nil of class
            settingUpRecorder(completionHandler:
                                { (setupComplete) in
                if setupComplete == true
                {
                    do
                    {
                        try unownedSelf.recordingSession.setActive(true)
                        unownedSelf.audioRecorder.record() // Main
                    }
                    catch
                    {
                        if unownedSelf.delegateMPAR != nil
                        {
                            unownedSelf.delegateMPAR?.audioRecorderFailed(errorMessage: "Unable to start the recording")
                            unownedSelf.clearAudioRecorder()
                        }
                    }
                }
            })
        }
    }
    
    /// This function will stop the audio recording
    public func  stopAudioRecording()
    {
        clearAudioRecorder()
    }
    
    //MARK:- Private Functions
    private func  clearAudioRecorder()
    {
        if audioRecorder != nil
        {
            if audioRecorder.isRecording == true
            {
                audioRecorder.stop()
            }
            audioRecorder = nil
        }
    }
    
    private func initialiseRecordingSession()
    {
        if recordingSession == nil
        {
            unowned let unownedSelf = self // Unowned self
            MPAudioSessionConfig.shared.initialiseRecordingSession(completionHandlerWithGrantPermission: { (isGranted, mSession) in
                if isGranted == true, mSession != nil
                {
                    unownedSelf.recordingSession = mSession
                    
                    if unownedSelf.delegateMPAR != nil
                    {
                        unownedSelf.delegateMPAR?.audioSessionPermission!(granted: true)
                    }else
                    {
                        unownedSelf.delegateMPAR?.audioSessionPermission!(granted: false)
                    }
                }
            })
        }
    }
    
    /// Put audio settings, configure AVAudioRecorder, destination file path
    private func settingUpRecorder(completionHandler :@escaping (_ success : Bool) -> Void)
    
    {
        do // Setting up the recorder
        {
            audioRecorder = try AVAudioRecorder(url: MPAudioSessionConfig.getDirectoryURLForFileName(fName: audioFileName != nil ? audioFileName! : "recordedAudioFile")!,
                                                settings: audioSettings == nil ? MPAudioSessionConfig.getDefaultAudioSettings() : audioSettings!)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            completionHandler(true)
        }
        catch
        {
            delegateMPAR?.audioRecorderFailed(errorMessage: "Unable to initialise AVAudioRecorder")
            clearAudioRecorder()
            completionHandler(false)
        }
    }
}

extension MPAudioRecorder: AVAudioRecorderDelegate
{
    /* audioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption. */
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if delegateMPAR != nil
        {
            delegateMPAR?.audioRecorderDidFinishRecording(recorder, successfully: flag)
        }
        stopAudioRecording() // Clear recording
    }
    
    /* if an error occurs while encoding it will be reported to the delegate. */
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?)
    {
        if delegateMPAR != nil
        {
            delegateMPAR?.audioRecorderEncodeErrorDidOccur!(recorder, error: error)
            delegateMPAR?.audioRecorderFailed(errorMessage: (error?.localizedDescription)!)
        }
        stopAudioRecording() // Clear recording
    }
    
    /* AVAudioRecorder INTERRUPTION NOTIFICATIONS ARE DEPRECATED - Use AVAudioSession instead. */
    
    /* audioRecorderBeginInterruption: is called when the audio session has been interrupted while the recorder was recording. The recorded file will be closed. */
    func audioRecorderBeginInterruption(_ recorder: AVAudioRecorder)
    {
        if delegateMPAR != nil
        {
            delegateMPAR?.audioRecorderBeginInterruption!(recorder)
        }
    }
    
    /* audioRecorderEndInterruption:withOptions: is called when the audio session interruption has ended and this recorder had been interrupted while recording. */
    /* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
    func audioRecorderEndInterruption(_ recorder: AVAudioRecorder, withOptions flags: Int)
    {
        if delegateMPAR != nil
        {
            delegateMPAR?.audioRecorderEndInterruption!(recorder, withOptions: flags)
        }
    }
}
