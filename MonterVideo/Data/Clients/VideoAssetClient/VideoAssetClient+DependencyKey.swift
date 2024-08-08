//
//  LiveKey.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/08/01.
//

import AVFoundation
import Dependencies

extension VideoAssetClient: DependencyKey {
//    public static let liveValue = {
//        return Self(
//            trimThumbnail: { asset in
//                return genetate(asset: asset)
//            }
//        )
//    }()
}

//func genetate(asset: VideoAsset) -> [FrameThumbnail] {
//    let targetAasset = AVAsset(url: asset.url)
//    let imageGenerator = AVAssetImageGenerator(asset: targetAasset)
//    let duration = CMTimeGetSeconds(targetAasset.duration)
//    var thumbnails = [FrameThumbnail]()
//
//    for idx in stride(from: 0, to: duration, by: 100) {
//        let time = CMTime(value: CMTimeValue(idx * 100), timescale: 100)
//        do {
//            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
//            thumbnails.append(FrameThumbnail(img: cgImage))
//        } catch {
//        }
//    }
//    return thumbnails
//}
