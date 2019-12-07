//
//  BaseViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 12/4/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit
import AVFoundation

class BaseViewController: UIViewController {

    //TODO: replace test sound name (& extension) with the actual one
    private var sfxAudioPlayer = AVAudioPlayer()
    private var musicAudioPlayer = AVAudioPlayer()
    private var buttonAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(turnSFXOn), name: .turnSFXOn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(turnSFXOff), name: .turnSFXOff, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(turnMusicOn), name: .turnMusicOn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(turnMusicOff), name: .turnMusicOff, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playButtonClickedSound), name: .buttonPressed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playSFXSound), name: .sfxSoundPlay, object: nil)
        
        setupButtonAudioPlayer()
    }
    
    private func setupButtonAudioPlayer(){
        if let buttonClickSoundFileURL = Bundle.main.url(forResource: "signalRocketSound", withExtension: "mp3") {
            do{
                buttonAudioPlayer = try AVAudioPlayer(contentsOf: buttonClickSoundFileURL)
                buttonAudioPlayer.volume = Settings.shared.isSoundEffectsEnabled ? 1.0 : 0.0
            }catch{
                print("Unable to initialize buttonAudioPlayer")
            }
        }else{print("Unable to locate audio file for Button Click Audio Player")}
    }
    func setupAudioPlayers(sfxSoundFileName: String, musicSoundFileName: String){
        setupSFXAudioPlayerWith(currentBirdSoundFileName: sfxSoundFileName)
        setupMusicAudioPlayerWith(currentLevelMusicSoundFileName: musicSoundFileName)
    }
    private func setupSFXAudioPlayerWith(currentBirdSoundFileName name: String){
        if let birdFileURL = Bundle.main.url(forResource: name, withExtension: "mp3") {
            do{
                sfxAudioPlayer = try AVAudioPlayer(contentsOf: birdFileURL)
                sfxAudioPlayer.volume = Settings.shared.isSoundEffectsEnabled ? 1.0 : 0.0
            }catch{
                print("Unable to initialize sfxAudioPlayer")
            }
        }else{print("Unable to locate audio file for SFX Audio Player")}
    }
    private func setupMusicAudioPlayerWith(currentLevelMusicSoundFileName name: String){
        if let musicFileURL = Bundle.main.url(forResource: name, withExtension: "mp3") {
            do{
                musicAudioPlayer = try AVAudioPlayer(contentsOf: musicFileURL)
                musicAudioPlayer.volume = Settings.shared.isMusicEnabled ? 1.0 : 0.0
                if musicAudioPlayer.isPlaying{
                    musicAudioPlayer.stop()
                }
                musicAudioPlayer.numberOfLoops = -1 // infinite play
                musicAudioPlayer.play()
            }catch{
                print("Unable to initialize musicAudioPlayer")
            }
        }else{print("Unable to locate audio file for Music Audio Player")}
    }
    
    @objc func playSFXSound(){
        sfxAudioPlayer.play()
    }
    @objc func playButtonClickedSound(){
        buttonAudioPlayer.play()
    }
    
    @objc func turnMusicOn(){
        musicAudioPlayer.volume = 1.0
    }
    @objc func turnMusicOff(){
        musicAudioPlayer.volume = 0.0
    }
    @objc func turnSFXOn(){
        sfxAudioPlayer.volume = 1.0
        buttonAudioPlayer.volume = 1.0
    }
    @objc func turnSFXOff(){
        sfxAudioPlayer.volume = 0.0
        buttonAudioPlayer.volume = 0.0
    }
}
