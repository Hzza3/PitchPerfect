//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Epic Systems on 11/22/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI(isRecording: false)
    }

    func configureUI(isRecording recording: Bool) {
        recordingLabel.text = recording ? "Recording in progress" : "Tap to Record"
        recordingButton.isEnabled = !recording
        stopButton.isEnabled = recording
    }
    
    @IBAction func recordingButtonTapped(_ sender: UIButton) {
        
        configureUI(isRecording: true)
        
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordVoice.wav"
        let pathArray = [dir, recordingName]
        let filePath = URL(fileURLWithPath: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            let errorAlert = UIAlertController(title: nil, message: "Error Recording Audio", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.dismiss(animated: false, completion: nil)
            }
            errorAlert.addAction(confirmAction)
            present(errorAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func stopButtonTapped(_ sender: Any) {
        
        configureUI(isRecording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let soundURL = sender as! URL
            playSoundVC.recordedAudioURL = soundURL
        }
    }
}

