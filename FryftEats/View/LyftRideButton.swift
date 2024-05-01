//
//  LyftRideButton.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/29/24.
//

import Foundation
import SwiftUI
import CoreLocation
import LyftSDK

//struct LyftRideButton: View {
//    var pickup: CLLocationCoordinate2D
//    var destination: CLLocationCoordinate2D
//
//    @State private var showInstallOption: Bool = !UIApplication.shared.canOpenURL(URL(string: "lyft://")!)
//
//    var body: some View {
//        if showInstallOption {
//            Button(action: {
//                installLyft()
//            }) {
//                Text("Install Lyft")
//                    .frame(maxWidth: .infinity)
//            }
//            .frame(width: 300, height: 50)
//            .frame(maxWidth: .infinity)
//            .padding(.horizontal)
//            .background(Color.white)
//            .foregroundColor(Color(hex: "#FF00BF"))
//            .cornerRadius(10)
//            .padding()
//        } else {
//            LyftButtonRepresentable(pickup: pickup, destination: destination)
//        }
//    }
//    
//    private func installLyft() {
//        if let url = URL(string: "https://apps.apple.com/us/app/lyft/id529379082") {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//    }
//}
//
//struct LyftButtonRepresentable: UIViewRepresentable {
//    var pickup: CLLocationCoordinate2D
//    var destination: CLLocationCoordinate2D
//
//    func makeUIView(context: Context) -> LyftButton {
//        let lyftButton = LyftButton()
//        lyftButton.style = .multicolor
//        lyftButton.configure(pickup: pickup, destination: destination)
//        return lyftButton
//    }
//
//    func updateUIView(_ uiView: LyftButton, context: Context) {}
//}

struct LyftRideButton: UIViewRepresentable {
    var pickup: CLLocationCoordinate2D
    var destination: CLLocationCoordinate2D
    
    init(pickup: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        self.pickup = pickup
        self.destination = destination
    }
    
    func makeUIView(context: Context) -> LyftButton {
        let lyftButton = LyftButton()
        lyftButton.style = .multicolor
        lyftButton.configure(pickup: pickup, destination: destination)
        return lyftButton
    }
    
    func updateUIView(_ uiView: LyftButton, context: Context) {}
}
