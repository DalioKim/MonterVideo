//
//  LiveKey.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/08/01.
//

import AVFoundation
import Dependencies
import Foundation

extension VideoGenerateClient: DependencyKey {
    public static let liveValue = {
        return Self(
            trimThumbnail: { asset in
                var times = Array<NSValue>()
                let targetAasset = AVAsset(url: asset.url)
                let imageGenerator = AVAssetImageGenerator(asset: targetAasset)
                var thumbnails = [FrameThumbnail]()
                
                for idx in stride(from: 0 , to: CMTimeGetSeconds(targetAasset.duration), by: 1) {
                    let time = CMTime(value: CMTimeValue(idx * 100), timescale: 100)
                    times.append(NSValue(time: time))
                }
                
                imageGenerator.generateCGImagesAsynchronously(forTimes: times) { _, image, _, _, _ in
                    guard let image = image else { return }
                    
                    thumbnails.append(FrameThumbnail(img: image))
                }
                                
                return thumbnails
            }        
        )
    }()
}
