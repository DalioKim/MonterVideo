//
//  LiveKey.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/08/01.
//

import AVFoundation
import Dependencies
import Foundation
import SwiftUI

extension VideoGenerateClient: DependencyKey {
    public static let liveValue = {
        return Self(
            trimThumbnail: { asset in
                return genetate(asset: asset)
            }
        )
    }()
}

func genetate(asset: VideoAsset) -> [FrameThumbnail] {
    //    var times = Array<NSValue>()
    var times = [CMTime]()
    let targetAasset = AVAsset(url: asset.url)
    let imageGenerator = AVAssetImageGenerator(asset: targetAasset)
    var thumbnails = [FrameThumbnail]()
    
    for idx in stride(from: 0 , to: CMTimeGetSeconds(targetAasset.duration), by: 100) {
        let time = CMTime(value: CMTimeValue(idx * 100), timescale: 100)
        let cgImage = try! imageGenerator.copyCGImage(at: time, actualTime: nil)
        thumbnails.append(FrameThumbnail(img: cgImage))
//        print("debug \(idx)")
    }
//    print("debug thumbnails \(thumbnails.count)")
    return thumbnails
}

//extension AVAsset {
//
//    func generateThumbnail(completion: @escaping (CGImage?) -> Void) {
//        DispatchQueue.global().async {
//            let imageGenerator = AVAssetImageGenerator(asset: self)
//            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
//            let times = [NSValue(time: time)]
//            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
//                if let image = image {
//                    completion(image)
//                } else {
//                    completion(nil)
//                }
//            })
//        }
//    }
//}
