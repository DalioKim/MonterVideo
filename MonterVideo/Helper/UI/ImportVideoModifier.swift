//
//  ImportFileModifier.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/07/31.
//

import SwiftUI

struct ImportFileModifier: ViewModifier {
    func body(content: Content) -> some View {
        func body(content: Content) -> some View {
            content
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

}

extension View {
    func isEmpty() -> some View {
        modifier(ImportFileModifier())
    }
}
