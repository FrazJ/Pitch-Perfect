//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Frazer Hogg on 25/07/2015.
//  Copyright (c) 2015 HomeProjects. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    /* Properties */
    var audioPlayer : AVAudioPlayer!
    var recievedAudio : RecordedAudio!
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup AVAudioPlayer to be used for modifying the RATE of audio
        audioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        //Creates an AVAudioEngine to be used for modifying the PITCH of audio
        audioEngine = AVAudioEngine()
        
        //Creates a new AVAudioFile using the filePath of  the recievedAudio object
        audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Helper functions */
    
    /* Function to stop any audio that is in the middle of playing */
    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
    }
    
    /* Function to play audio at a given RATE */
    func playSoundAtRate (rate: Float) {
        stopAllAudio()
        audioPlayer.rate = rate         //Sets the rate the audio should be played at
        audioPlayer.currentTime = 0.0   //Reset the playback time of the audio to 0.0
        audioPlayer.play()              //Plays the audio
    }
    
    /* Helper function to play audio at a given PITCH */
    func playAudioWithVariablePitchAndReverb(pitch: Float, reverb: Float) {
        stopAllAudio()
        audioEngine.reset()
        
        //Creates and attaches the AVAudioPlayerNode to the audioEngine
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //Creates and attaches the AVAudioUnitTimePitch to the audioEngine
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        //Creates and attaches the AVAudioUnitReverb to the audioEngine
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.LargeHall2)
        reverbEffect.wetDryMix = reverb
        audioEngine.attachNode(reverbEffect)
        
        //Connects the audioPlayerNode, changePitchEffect and reverb to the audioEngine and one another
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        //Prepares the audioEngine for audio playback
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        //Plays the audio file
        audioPlayerNode.play()
        
    }

    /* User interface button functions */
    
    
    /* Function that when a user presses the SNAIL button will play the audio with a SLOW rate */
    @IBAction func playSoundSlowly(sender: UIButton) {
        playSoundAtRate(0.5)
    }

    /* Function that when a user presses the HARE button will play the audio with a FAST rate */
    @IBAction func playSoundFast(sender: UIButton) {
        playSoundAtRate(2.0)
    }
    
    /* Function that when a user presses the CHIPMUNK button will play the audio at a HIGH pitch */
    @IBAction func playChimpmunkAudio(sender: UIButton) {
        playAudioWithVariablePitchAndReverb(1000, reverb: 0)
    }
    
    /* Function that when a user presses the DARTHVADER button will play the audio at a LOW pitch */
    @IBAction func playDarthVadarAudio(sender: UIButton) {
        playAudioWithVariablePitchAndReverb(-1000, reverb: 0)
    }
    
    /* Function that when a user presseds the ECHO button will play the audio with REVERB */
    @IBAction func playAudioWithEcho(sender: UIButton) {
        playAudioWithVariablePitchAndReverb(0, reverb: 70.0)
    }

    /* Function that when a user presses the STOP button stops the audio from playing */
    @IBAction func stopSoundFromPlaying(sender: UIButton) {
        stopAllAudio()
    }
    

}
