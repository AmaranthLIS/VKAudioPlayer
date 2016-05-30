//
//  AudioPlayerViewController.swift
//  VkAudio
//
//  Created by mac-224 on 05.05.16.
//  Copyright © 2016 y0rrrsh. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import JLToast

class AudioPlayerViewController: UIViewController, AudioPlayerDelegate {
    
    @IBOutlet weak var labelArtist: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageCover: UIImageView! //todo: download cover
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnShuffle: UIButton!
    @IBOutlet weak var btnRepeat: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var progressAudioStream: BufferingSlider!
    @IBOutlet weak var labelAudioCurrentDuration: UILabel!
    @IBOutlet weak var labelAudioDuration: UILabel!
    
    let api: VKAPService = VKAPService.sharedInstance!
    let player = AudioPlayer.sharedInstance
    var playlistOwnerId: Int? //nil means current user
    var audios: [Audio]!
    var selectedAudioIndex: Int!
        
    var shuffleEnabled = false
    var repeatEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupBlurView { (blurView) in
            self.view.addSubview(blurView)
            self.view.sendSubviewToBack(blurView)
        }
        
        player.delegate = self
        player.playlist = audios.map({$0 as Audio}) //[?] stackoverflow.com/questions/30100787
        if player.currentAudio?.playlistPosition != selectedAudioIndex {
            player.play(selectedAudioIndex)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let audio = player.currentAudio?.audio as! Audio
        
        let playButtonImageRes = player.isPlaying() ? "ic_pause" : "ic_play"
        btnPlay.setImage(UIImage(named: playButtonImageRes), forState: .Normal)
        labelArtist.text = audio.artist
        labelName.text = audio.name
        progressAudioStream.maximumValue = Float(audio.duration!)
    }
    
    @IBAction func onPreviousButtonClicked(sender: AnyObject) {
        player.playPrevious()
    }
    
    @IBAction func onPlayButtonClicked(sender: AnyObject) {        
        if player.isPlaying() {
            player.pause()
        }
        else {
            player.continuePlaying()
        }
    }
    
    @IBAction func onNextButtonClicked(sender: AnyObject) {
        player.playNext()
    }
    
    @IBAction func onShuffleButtonClicked(sender: AnyObject) {
        var newPlaylist = [Audio]()
        if !shuffleEnabled {
            newPlaylist = audios.shuffle()
            btnShuffle.tintColor = progressAudioStream.tintColor
        }
        else {
            newPlaylist = self.audios
            btnShuffle.tintColor = UIColor.blackColor()
        }
        shuffleEnabled = !shuffleEnabled
        player.playlist = newPlaylist.map({$0 as Audio})
    }
    
    @IBAction func onRepeatButtonClicked(sender: AnyObject) {
        if !repeatEnabled {
            btnRepeat.tintColor = progressAudioStream.tintColor
        }
        else {
            btnRepeat.tintColor = UIColor.blackColor()
        }
        repeatEnabled = !repeatEnabled
    }
    
    @IBAction func onRemoveButtonClicked(sender: AnyObject) {
        let currentAudio = player.currentAudio?.audio as! Audio
        api.removeAudio(currentAudio.id!, ownerId: currentAudio.ownerId!, callback: VkApiCallback(onResult: { (result) in
            let message = "\(currentAudio.artist ?? "Unknown") - \(currentAudio.name ?? "Unnamed") was removed from your page"
            JLToast.makeText(message, duration: JLToastDelay.LongDelay).show()
        }))
        player.playlist.removeAtIndex(player.currentAudio!.playlistPosition)
        player.playNext()
    }
    
    @IBAction func onAddButtonClicked(sender: AnyObject) {
        let currentAudio = player.currentAudio?.audio as! Audio
        api.addAudio(currentAudio.id!, ownerId: currentAudio.ownerId!, callback: VkApiCallback(onResult: { (result) in
            let message = "\(currentAudio.artist ?? "Unknown") - \(currentAudio.name ?? "Unnamed") was added to your page"
            JLToast.makeText(message, duration: JLToastDelay.LongDelay).show()
        }))
    }
    
    @IBAction func onAudioSliderDragged(sender: UISlider) {
        player.seekToTime(Int64(progressAudioStream.value)) {
            let currentAudio = self.player.currentAudio?.audio as! Audio
            let elapsedTime = Int64(self.progressAudioStream.value)
            
            self.updateMediaCenterInfo(currentAudio, elapsedTime: elapsedTime)
        }
    }
    
    private func updateMediaCenterInfo(currentAudio: Audio, elapsedTime: Int64? = 0) {
        let currentAudioInfo = [
            MPMediaItemPropertyArtist: currentAudio.artist!,
            MPMediaItemPropertyTitle: currentAudio.name!,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: NSNumber(longLong: elapsedTime!),
            MPMediaItemPropertyPlaybackDuration: NSNumber(integer: currentAudio.duration!)
        ]
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = currentAudioInfo
    }
    
    //MARK: - AudioPlayerDelegate
    
    func onStopPlaying(audio: AudioPlayerItem, playlistPosition: Int, stopSeconds: Int64) {
        btnPlay.setImage(UIImage(named: "ic_play"), forState: .Normal)
        if stopSeconds == Int64(audio.duration!) {
            if repeatEnabled {
                player.play(playlistPosition)
            }
            else {
                player.playNext()
            }
        }
    }
    
    func onStartPlaying(audio: AudioPlayerItem, playlistPosition: Int, startSeconds: Int64) {
        let audio = audio as! Audio
        
        btnPlay.setImage(UIImage(named: "ic_pause"), forState: .Normal)
        labelArtist.text = audio.artist
        labelName.text = audio.name
        progressAudioStream.maximumValue = Float(audio.duration!)
        labelAudioDuration.text = audioDurationToString(audio.duration!)
        
        btnRemove.enabled = playlistOwnerId == nil
        btnAdd.enabled = playlistOwnerId != nil
        
        updateMediaCenterInfo(audio, elapsedTime: startSeconds)
    }
    
    private func audioDurationToString(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
                
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
    
    func onTimeChanged(seconds: Int64, cachedSeconds: Int64) {
        progressAudioStream.value = Float(seconds)
        labelAudioCurrentDuration.text = audioDurationToString(Int(seconds))
        progressAudioStream.bufferValue = Float(cachedSeconds)
    }
}