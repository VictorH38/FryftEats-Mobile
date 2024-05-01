//
//  Profile.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @ObservedObject var sessionManager = SessionManager.shared
    
    var body: some View {
        NavigationView {
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
                        
                        NavigationLink(destination: ReportView(viewModel: ReportViewModel())) {
                            Text("Report a Restaurant")
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                        Button(action: {
                            sessionManager.logout()
                        }) {
                            Text("Logout")
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding()
                } else {
                    LoginView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "#990000"))
        }
    }
}

#Preview {
    let previewSessionManager = SessionManager.shared
    let dummyUser = User(id: 1, firstName: "John", lastName: "Doe", email: "john.doe@example.com", username: "johndoe")
    
    previewSessionManager.isLoggedIn = true
    previewSessionManager.user = dummyUser
    
    return ProfileView()
        .environmentObject(previewSessionManager)
}
