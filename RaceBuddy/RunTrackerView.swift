//
//  RunTrackerView.swift
//  RaceBuddy
//
//  Created by Arnav Srinivasan on 10/12/24.
//

import SwiftUI
import MapKit

struct RunTrackerView: View{
    @EnvironmentObject var viewModel: RunTrackerViewModel
    
    var body: some View {
        VStack {
            // Display Map
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 300)
                
            // Display Run Info
            VStack(alignment: .leading) {
                Text("Distance: \(viewModel.distance, specifier: "%.2f") meters")
                    .font(.title)
                Text("Time: \(viewModel.formattedTime)")
                    .font(.title)
            }
            .padding()
                
            // Start/Stop Buttons
            HStack {
                if viewModel.isRunning {
                    Button(action: viewModel.stopRun) {
                        Text("Stop Run")
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(8)
                    }
                } else {
                    Button(action: viewModel.startRun) {
                        Text("Start Run")
                            .foregroundColor(.green)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.checkLocationAuthorization()
        }
    }
}
