import SwiftUI

struct HeartRatingView: View {
    @Binding var rating: Int
    var isInteractive: Bool = true

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { heart in
                Text(heart <= rating ? "❤️" : "🤍")
                    .font(.system(size: 40))
                    .onTapGesture {
                        if isInteractive {
                            rating = heart
                        }
                    }
            }
        }
    }
}
