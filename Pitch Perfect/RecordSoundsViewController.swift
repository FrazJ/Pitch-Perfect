//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Frazer Hogg on 25/07/2015.
//  Copyright (c) 2015 HomeProjects. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    /* User interface properties*/
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordInstruction: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    /* Properties */
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    let audioSession = AVAudioSession.sharedInstance()
    
    /* ViewController lifecycle functions */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Fucntion that causes the stopButton and record button to be hidden and enable respectively */
    override func viewWillAppear(animated: Bool) {
        recordInstruction.hidden = false    //Shows the record instruction
        stopButton.hidden = true            //Hides the stop button
        pauseButton.hidden = true           //Hides the pause button
        resumeButton.hidden = true          //Hides the resume button
        recordButton.enabled = true         //Enables the state recording button
    }

    /* Function that records audio from the microphone of the device when a user presses the recordButton */
    @IBAction func recordAudio(sender: UIButton) {
        //Updates the user interface
        recordInstruction.hidden = true     //Hides the Tap to record label
        recordingInProgress.hidden = false  //Shows the Recording in progress label
        stopButton.hidden = false           //Shows the stop recording button
        pauseButton.hidden = false          //Shows the pause button
        recordButton.enabled = false        //Disables the start recording button
        
        //Sets up the file path that the recorded audio will be stored at
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print("filePath \(filePath)")
        
        //Gets and configures the device's AVAudioSession signleton object to allow the app to playback and record audio
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //Configures the device's AVAudioSession to playback audio out of the built-in lound speaker
        audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: nil)
        
        //Initialises and prepares the recorder using the previously configured filePath and settings
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self           //Assigns RecordSoundsViewController to the property delegate of AVAudioRecorder
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        
        //Begins recording audio
        audioRecorder.record()

    }
    
    /* Function that pauses the audio recording when the user presses the pause button */
    @IBAction func pauseRecording(sender: UIButton) {
        recordingInProgress.hidden = true   //Hides the recording in progress label
        audioRecorder.pause()               //Pauses the audio recording
        pauseButton.hidden = true           //Hides the pause button
        resumeButton.hidden = false         //Shows the resume button
    }
    
    /* Function that resumes the audio recording when the user presses the pause button */
    @IBAction func resumeRecording(sender: UIButton) {
        recordingInProgress.hidden = false  //Shows the recording in progress label
        audioRecorder.record()              //Resumes the audio recording
        resumeButton.hidden = true          //Hides the resume button
        pauseButton.hidden = false          //Shows the pause button
    }
    
    /* Function stops recording audio when a recording is in progress and the user presses the stopButton */
    @IBAction func stopRecording(sender: UIButton) {
        //Updates the user interface by hidding the recording in progress label
        recordingInProgress.hidden = true
        
        //Stops recording audio
        audioRecorder.stop()
        
        //Resets the audio policy for the app as it is no longer needed, allowing other apps to use the devices audio if needed
        audioSession.setActive(false, error: nil)

    }
    
    /* Function called by the system when audio recording is stopped */
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        //If the audio recording finished successful then...
        if (flag) {
            //Save recorded audio
            recordedAudio = RecordedAudio(locationToSaveTo: recorder.url, desriedFileName: recorder.url.lastPathComponent)
            
            //RecordSoundsViewcontroller calls performSegue, causing the recordSounds view to display.
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording was not successful")
            //Update the user interface to enable the record button and hid the stop button
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    
    /* Function is called before a segue from RecordSoundsViewController is performed */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Checks to see if the segue is "stopRecording"
        if (segue.identifier == "stopRecording") {
            //Stores the desintation viewController as a constant
            let playSoundsVC : PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio     //Stores the audio file passed as an arguement in the call
            playSoundsVC.recievedAudio = data       //Sets the recivedAudio property of PlaySoundsViewController
        }
    }
}

