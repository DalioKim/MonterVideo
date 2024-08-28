//
//  LiveKey.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/08/01.
//

import AVFoundation
import Dependencies

extension VideoAssetClient: DependencyKey {
    public static let liveValue = {
        return Self(
            load: {
                VideoAsset(url: $0)
            },
            trimThumbnail: { asset in
                let videoActor = VideoActor()

                return await videoActor.genetate(asset: asset)
            }
        )
    }()

    private actor VideoActor {
        var thumbnails = [FrameThumbnail]()

        func genetate(asset: VideoAsset) async -> [FrameThumbnail] {
            let targetAasset = AVAsset(url: asset.url)
            let imageGenerator = AVAssetImageGenerator(asset: targetAasset)
            let duration = CMTimeGetSeconds(targetAasset.duration)
            var thumbnails = [FrameThumbnail]()

            for idx in stride(from: 0, to: duration, by: 100) {
                let time = CMTime(value: CMTimeValue(idx * 100), timescale: 100)
                do {
                    try await thumbnails.append(FrameThumbnail(img: imageGenerator.image(at: time).image))
                } catch { }
            }
            return thumbnails
        }
    }
}
