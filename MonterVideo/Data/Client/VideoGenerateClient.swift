//
//  AssetClient.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/07/31.
//

import AVFoundation
import Combine

class VideoGenerateClient: ObservableObject {
    @Published var thumbnails = [FrameThumbnail]()

    private var cancelBag = Set<AnyCancellable>()

    // MARK: Lifecycle
    
    init() {
        bindCurrentUser()
    }


    private func bindCurrentUser() {
        userRepository.currentUser()
            .sink { completion in
                switch completion {
                case .failure(let error): print("error \(error)")
                default: print("completion \(completion)")
                }

            } receiveValue: { [weak self] user in
                self?.setInfo(with: user)
            }
            .store(in: &cancelBag)
    }
    
    
    func trimThumbnail(_ fileUrl: URL) {
        var times = Array<NSValue>()
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        for idx in stride(from: 0 , to: CMTimeGetSeconds(asset.duration), by: 1) {
            let time = CMTime(value: CMTimeValue(idx * 100), timescale: 100)
            times.append(NSValue(time: time))

        }

        imageGenerator.generateCGImagesAsynchronously(forTimes: times) { _, image, _, _, _ in
            guard let image = image else { return }
            
            self.imageArr.append(ImageItem(img: image))
        }
    }
}
