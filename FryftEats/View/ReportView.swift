//
//  ReportView.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/30/24.
//

import Foundation
import SwiftUI

struct ReportView: View {
    @ObservedObject var viewModel: ReportViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Make a Report")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .leading])
                    
                    if let successMessage = viewModel.successMessage {
                        Text(successMessage)
                            .foregroundColor(.green)
                            .padding([.leading])
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding([.leading])
                    }
                    
                    HStack {
                        Text("Select Restaurant:")
                            .foregroundColor(.black)
                            .padding(.leading)
                        
                        Picker("Select Restaurant", selection: $viewModel.selectedRestaurantId) {
                            Text("-- Restaurant --").tag(nil as Int?).foregroundColor(.gray)
                            ForEach(viewModel.restaurants, id: \.id) { restaurant in
                                Text(restaurant.name).tag(restaurant.id as Int?)
                            }
                        }
                        .frame(height: 60)
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                    }
                    
                    HStack {
                        Text("Reason:")
                            .foregroundColor(.black)
                            .padding(.leading)
                        
                        Picker("Reason", selection: $viewModel.reason) {
                            ForEach(["Outside of Fryft zone", "Inaccurate information"], id: \.self) { reason in
                                Text(reason)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                    }

                    TextField("Additional notes", text: $viewModel.additionalNotes)
                        .placeholder(when: viewModel.additionalNotes.isEmpty) {
                            Text("Additional notes").foregroundColor(.gray)
                        }
                        .padding()
                        .frame(height: 50)
                        .multilineTextAlignment(.leading)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    
                    Button(action: {
                        viewModel.submitReport()
                    }) {
                        Text("Submit Report")
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .disabled(viewModel.isLoading)
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
            .onDisappear {
                viewModel.resetReportForm()
            }
        }
    }
}

#Preview {
    ReportView(viewModel: ReportViewModel())
}
