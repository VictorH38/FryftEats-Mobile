//
//  Profile.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation
import SwiftUI

struct Profile: View {
    @ObservedObject var sessionManager = SessionManager.shared
    
    var body: some View {
        VStack {
            if sessionManager.isLoggedIn, let user = sessionManager.user {
                VStack(alignment: .leading) {
                    Text("\(user.firstName) \(user.lastName)")
                        .padding()
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Text("Email: \(user.email)")
                        .padding([.top, .horizontal])
                        .font(.title2)
                        .foregroundColor(.white)
                    Text("Username: \(user.username)")
                        .padding([.horizontal])
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        sessionManager.logout()
                    }) {
                        Text("Logout")
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            } else {
                Login()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(hex: "#990000"))
    }
}

#Preview {
    let previewSessionManager = SessionManager.shared
    let dummyUser = User(id: 1, firstName: "John", lastName: "Doe", email: "john.doe@example.com", username: "johndoe")
    
    previewSessionManager.isLoggedIn = true
    previewSessionManager.user = dummyUser
    
    return Profile()
        .environmentObject(previewSessionManager)
}
