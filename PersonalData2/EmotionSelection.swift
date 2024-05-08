import SwiftUI

struct EmotionSelection: View {
    let images: [String]
    @Binding var selectedEmotion: String?
    var body: some View {
        GeometryReader { fullView in
            ScrollViewReader { scrollView in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(images.indices, id: \.self) { index in
                            GeometryReader { geometry in
                                Image(images[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .scaleEffect(self.scale(for: geometry, in: fullView))
                                    .opacity(self.opacity(for: geometry, in: fullView))
                                    .padding(5)
                                    .onAppear {
                                        self.updateSelectedEmotion(for: geometry, in: fullView, image: images[index])
                                    }
                                    .onChange(of: geometry.frame(in: .global).midX) { newValue in
                                        self.updateSelectedEmotion(for: geometry, in: fullView, image: images[index])
                                    }
                            }
                            .frame(width: 65, height: 120)
                            .id(index)
                        }
                    }
                    .padding(.horizontal, (fullView.size.width - 60) / 2)
                }
                .onAppear {
                    scrollView.scrollTo(2, anchor: .center)
                }
            }
        }
        .frame(height:100)
    }

    private func updateSelectedEmotion(for geometry: GeometryProxy, in fullView: GeometryProxy, image: String) {
        let frame = geometry.frame(in: .global)
        let midPoint = fullView.size.width / 2
        if abs(frame.midX - midPoint) < 10 {  
            DispatchQueue.main.async {
                if self.selectedEmotion != image {
                    self.selectedEmotion = image
                }
            }
        }
    }

    private func scale(for geometry: GeometryProxy, in fullView: GeometryProxy) -> CGFloat {
        let distance = abs(geometry.frame(in: .global).midX - fullView.size.width / 2)
        let normDistance = min(distance / (fullView.size.width / 2), 1)
        return 1.2 - normDistance * 1.0
    }

    private func opacity(for geometry: GeometryProxy, in fullView: GeometryProxy) -> Double {
        let distance = abs(geometry.frame(in: .global).midX - fullView.size.width / 2)
        let normDistance = min(distance / (fullView.size.width / 2), 1)
        return 1.0 - normDistance * 0.6
    }
}

struct EmotionSelection_Previews: PreviewProvider {
    static var previews: some View {
        EmotionSelection(images: ["ic-emoji-angry", "ic-emoji-sad", "ic-emoji-smile", "ic-emoji-happy"], selectedEmotion: .constant("Happy"))
    }
}
