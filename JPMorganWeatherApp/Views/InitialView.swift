//
//  InitialView.swift
//  JPMorganWeatherApp
//
//  Created by Xavier Carty on 9/27/24.
//

import Foundation
import SwiftUI

struct InitialView: View {
    var body: some View {
        VStack {
            Text("Welcome to weather app, search by city")
                .font(.title)
                .multilineTextAlignment(.center)
                .frame(alignment: .center)
                .padding()

            Text("Ex: Los Angeles, New York, Chicago, Portland, Denver ")
                .font(.title)
                .multilineTextAlignment(.center)
                .frame(alignment: .center)
                .padding(.horizontal)
        }
    }
}
