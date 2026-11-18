import SwiftUI

struct ErrorView: View {
    let message: String
    let retry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 50))
                .foregroundStyle(.secondary)

            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Button("Retry", action: retry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
