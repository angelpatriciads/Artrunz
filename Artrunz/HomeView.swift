//
//  HomeView.swift
//  Artrunz
//
//  Created by Angelica Patricia on 23/05/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Image("home-background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 50) {
                Image("home-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                
                Button(action: {
                    
                }, label: {
                    Text("Finish")
                        .frame(width: 300, height: 20)
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(LinearGradient(colors: [Color("yellow"),Color.white,Color("yellow")], startPoint: .leading, endPoint: .trailing), lineWidth: 3)
                            )
                })
                .background(Color("yellow").opacity(0.2))
                .cornerRadius(8)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
