//
//  ViewController.swift
//  AudioFunctions
//
//  Created by iDevelopers on 6/19/17.
//  Copyright © 2017 iDevelopers. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController
{

    @IBOutlet weak var btnAudioRecord: UIButton!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    
    var isRecord : Bool = true
    var audioPlayer : AVAudioPlayer!
    
    /// This will contain the URL of the saved audio file
    var audioFileURL: URL?
    
    /// MPAudioRecorder, assigning delegate is mandatory.
    let mpRecorder: MPAudioRecorder = MPAudioRecorder()
    
    //MARK:- Default functions
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mpRecorder.delegateMPAR  = self
    }

    //MARK:- Custom functions
    func playerTimeInterval()
    {
        audioSlider.value = Float(audioPlayer.currentTime)
        lblStartTime.text = "\(Int(audioSlider.value))"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "SplitAudioFile"
        {
            let destinationVC = segue.destination as! SplitAudioFile
            destinationVC.fileURL = audioFileURL
        }else
        {
            let destinationVC = segue.destination as! MergeAudioFiles
            destinationVC.fileURL1 = audioFileURL
        }
    }

    //MARK:- IBActions
    @IBAction func clicki_ToOpenSplitView(_ sender: Any)
    {
        
         //self.performSegue(withIdentifier: "SplitAudioFile", sender: nil)
    }
    
    @IBAction func click_AudioRecord(_ sender: Any)
    {
        if isRecord == true
        {
            isRecord = false
            self.btnAudioRecord.setTitle("Stop Recording", for: UIControlState.normal)
            self.btnAudioRecord.backgroundColor = UIColor(red: 119.0/255.0, green: 119.0/255.0, blue: 119.0/255.0, alpha: 1.0)
            mpRecorder.startAudioRecording()
        } else
        {
            isRecord = true
            self.btnAudioRecord.setTitle("Start Record", for: UIControlState.normal)
            self.btnAudioRecord.backgroundColor = UIColor(red: 221.0/255.0, green: 27.0/255.0, blue: 50.0/255.0, alpha: 1.0)
            mpRecorder.stopAudioRecording()
        }
    }
    
    @IBAction func doPlay(_ sender: Any)
    {
        
        if audioFileURL != nil
        {
            self.audioPlayer = try! AVAudioPlayer(contentsOf: audioFileURL!)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
            audioSlider.maximumValue = Float(audioPlayer.duration)
            lblEndTime.text = "\(audioPlayer.duration)"
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(playerTimeInterval), userInfo: nil, repeats: true)
        }else
        {
            self.showBasicAlert(title: "No recording", message: "First record an audio then press play recording button")
        }
    }

    @IBAction func click_ToOpenMergeView(_ sender: Any)
    {
        //self.performSegue(withIdentifier: "MergeAudioFiles", sender: nil)
    }
}

// MARK: - MPAudioRecorderDelegate
extension ViewController: MPAudioRecorderDelegate
{
    func audioRecorderFailed(errorMessage: String)
    {
        print(errorMessage)
        self.showBasicAlert(title: "Failed", message: "\(errorMessage)")
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        print("\(recorder) \n /n \(flag)")
        audioFileURL = recorder.url
        self.showBasicAlert(title: "\(flag == true ? "Success" : "Failed")", message: "Audio has been recorded at \(audioFileURL!)")
        
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?)
    {
        print("\(recorder) \n /n \(String(describing: error?.localizedDescription))")
    }
    func audioRecorderBeginInterruption(_ recorder: AVAudioRecorder)
    {
        print("\(recorder)")
    }
    func audioRecorderEndInterruption(_ recorder: AVAudioRecorder, withOptions flags: Int)
    {
        print("\(recorder) \n /n \(flags)")
    }
    func audioSessionPermission(granted: Bool)
    {
        print(granted)
    }
}


// MARK: - Extension to show alert
extension UIViewController
{
    func showBasicAlert(title : String?, message : String)
    {
        // Show alert
        let alertController: UIAlertController = UIAlertController(title: title == nil ? "Title" : title!, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: { action in
            alertController .dismiss(animated: true, completion: nil)
        })
        alertController.addAction(actionOk)
        self.present(alertController, animated: true, completion: nil)
    }
}
