//
//  ContactView.swift
//  FryftEats
//
//  Created by Victor Hoang on 5/1/24.
//

import Foundation
import SwiftUI

struct ContactView: View {
    @StateObject private var viewModel = ContactViewModel()
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @FocusState private var focusedField: Field?

    enum Field: Hashable {
        case name, email, message
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Contact Us")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .leading])
                    
                    TextField("Name", text: $name)
                        .placeholder(when: name.isEmpty) {
                            Text("Name").foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(5)
                        .focused($focusedField, equals: .name)
                        .onSubmit {
                            focusedField = .email
                        }
                    
                    TextField("Email", text: $email)
                        .placeholder(when: email.isEmpty) {
                            Text("Email").foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(5)
                        .focused($focusedField, equals: .email)
                        .onSubmit {
                            focusedField = .message
                        }

                    TextField("Message", text: $message)
                        .placeholder(when: message.isEmpty) {
                            Text("Message").foregroundColor(.gray)
                        }
                        .padding()
                        .frame(height: 50)
                        .multilineTextAlignment(.leading)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .focused($focusedField, equals: .message)
                        .onSubmit {
                            focusedField = nil
                        }
                    
                    Button(action: {
                        viewModel.sendEmail(name: name, email: email, message: message)
                    }) {
                        Text("Send")
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#FFCC00"))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding()
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "#990000"))
            .onTapGesture {
                viewModel.dismissKeyboard()
            }
            .onAppear {
                name = ""
                email = ""
                message = ""
            }
        }
    }
}

#Preview {
    ContactView()
}
