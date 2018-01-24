//
//  ViewController.swift
//  SkipFrameTest
//
//  Created by lvpengwei on 1/24/18.
//  Copyright © 2018 lvpengwei. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var generator: AVAssetImageGenerator!
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "IMG_9008", ofType: "MP4")!
        let url = URL(fileURLWithPath: path)
        let asset = AVAsset(url: url)
        let composition = AVMutableComposition()
        let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: 1)!
        try? videoTrack.insertTimeRange(CMTimeRange(start: kCMTimeZero, duration: asset.duration), of: asset.tracks(withMediaType: .video)[0], at: kCMTimeZero)
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: 1080, height: 1920)
        videoComposition.frameDuration = CMTimeMake(20, 600)
        
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        layerInstruction.setOpacityRamp(fromStartOpacity: 1.0, toEndOpacity: 1.0, timeRange: CMTimeRangeMake(kCMTimeZero, asset.duration))
        
        let instruction = AVMutableVideoCompositionInstruction()
        
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration)
        instruction.layerInstructions = [layerInstruction]
        videoComposition.instructions = [instruction]
        
        generator = AVAssetImageGenerator(asset: composition)
        generator.videoComposition = videoComposition
        generator.requestedTimeToleranceAfter = kCMTimeZero
        generator.requestedTimeToleranceBefore = kCMTimeZero
        generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: kCMTimeZero)]) { (time1, cgimage, time2, res, error) in
            print("\(time1), \(time2), \(res), \(error?.localizedDescription ?? "")")
        }
    }

}
