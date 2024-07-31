//
//  LoadResourceView.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/07/31.
//

import SwiftUI
import CoreData
import AVFoundation

struct LoadResourceView: View {
    @State private var isImporting: Bool = false
    @State private var imageArr = [ImageItem]()
    
    private var data  = Array(1...20)
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        VStack {
            importBtn
            gridThumbnails
        }
    }
    
    func trimThumbnail(_ fileUrl: URL) {
        var times = Array<NSValue>()
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        for idx in stride(from: 100 , to: CMTimeGetSeconds(asset.duration), by: 1) {
            let time = CMTime(value: CMTimeValue(idx * 100), timescale: 100)
            times.append(NSValue(time: time))

        }
        //        for index in 0..<Int(CMTimeGetSeconds(asset.duration)) {
//        for index in 0..<100 {
//            let time = CMTime(value: 100 * Int64(Double(index)), timescale: 100)
//            times.append(NSValue(time: time))
//        }
        
        imageGenerator.generateCGImagesAsynchronously(forTimes: times) { _, image, _, _, _ in
            guard let image = image else { return }
            
            self.imageArr.append(ImageItem(img: image))
        }
    }
}

extension ContentView {
    private var importBtn: some View {
        Button(action: {
            isImporting = true
        }, label: {
            Text("Import Resource")
        })
        .fileImporter(isPresented: $isImporting,
                      allowedContentTypes: [.mpeg4Movie],
                      onCompletion: { result in
            
            switch result {
            case .success(let url):
                trimThumbnail(url)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private var thubnails: some View {
        List {
            ForEach(imageArr) { item in
                let myNsImage = NSImage(cgImage: item.img, size: .init(width: 100, height: 100))
                Image(nsImage: myNsImage)
            }
        }
    }
    
    private var gridThumbnails: some View {
        ScrollView{
            LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                ForEach(imageArr) { item in
                    let myNsImage = NSImage(cgImage: item.img, size: .init(width: 150, height: 150))
                    Image(nsImage: myNsImage)
                }
            }
            
        } .padding()
    }
}


struct LoadResourceView: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct ImageItem: Identifiable {
    var id = UUID()
    var img: CGImage
}

