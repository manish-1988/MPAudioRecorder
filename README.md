
> # MPAudioRecorder
This is a library with which you can perform an *Audio Recording* into your application, it is fully customizable, you can pass Audio settings in it.

# Installation
You can install this library using cocoapods or manually.

1. > Cocoapods (If required or if there is any error on pod installation, first try to do pod setup or pod repo update)
    - pod 'MPAudioRecorder'
    - pod 'MPAudioRecorder', '~> 0.1' (For a stable swift 3.0 version)
    
2. > Manually
    - Copy the <MPAudioRecorder> folder from the example included in the repository.
    
    

# Usage
1. Create an instance of MPAudioRecorder like this
    /// MPAudioRecorder, assigning delegate is mandatory.
    
        let mpRecorder: MPAudioRecorder = MPAudioRecorder()
    
2. In view did load assign the delegate, so that all relevant delegate methods can be invoked

    ```
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mpRecorder.delegateMPAR  = self // Imp
    }
    ```
    If required do import AVFoundation in your view controller.
    
3. To start the recording you can use a function and call it through the MPAudioRecorder instance you have created like this:-

        mpRecorder.startAudioRecording()
    

4. To stop the recording you can use a function and call it through the MPAudioRecorder instance you have created like this:-
   
       mpRecorder.stopAudioRecording()
    
5. ### Delegates
        You can implement all the delegates as per requirement with few mandatory delegate implementation.

        A.  AudioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped.
            This method is NOT called if the recorder is stopped due to an interruption.
            
            func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
                        
        B.  If an error occurs while encoding it will be reported to the delegate
          
            func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?)
                
        C.  AVAudioRecorder INTERRUPTION NOTIFICATIONS ARE DEPRECATED - Use AVAudioSession instead. */
            audioRecorderBeginInterruption: is called when the audio session has been interrupted while the recorder was
            recording. The recorded file will be closed.
            
            func audioRecorderBeginInterruption(_ recorder: AVAudioRecorder) 
            
        D.  AudioRecorderEndInterruption:withOptions: is called when the audio session interruption has ended and this
            recorder had been interrupted while recording.
            Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume.
            
            func audioRecorderEndInterruption(_ recorder: AVAudioRecorder, withOptions flags: Int)
            
          
6. Other properties which user can use.

            /// Settings, audio settings for a recorded audio.

            public var audioSettings        : [String : Int]?


            /// File name, Name of the audio file with which user wants to save it.

            public var audioFileName: String?

            /// Custom url if any user wants to save the recorded Audio file at specific location.

            public var customPath: String?


            /// If user wants the recorded audio filed to be saved to the iPhone's library # Coming soon.

            public var shouldSaveToLibrary: Bool = false


            /// If user want delegates methods to be implemented in their class.

            public var delegateMPAR: MPAudioRecorderDelegate?



 >  # Coming soon...
 1. ### Split audio files
 2. ### Merge Audio files
 3. ### Overlap Audio files

 # Gif of sample
 ![ScreenShot](https://raw.githubusercontent.com/manish-1988/MPAudioRecorder/master/MPAudioRecorder_Sample.gif)
 
If you have any suggestions or see a scope of improvement please suggest as it is my first cocoapods library.

Thanks


            
            
