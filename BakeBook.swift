//
//  Dashboard.swift
//  BakeBook
//
//  Created by Rayaan Ismail on 10/4/24.
//

import SwiftUI

struct Dashboard: View {
    var body: some View {
        
            VStack {
                HStack {
                    Image(.logo)
                        .resizable()
                        .frame(width: 75, height: 75)
                        .padding(.horizontal)
                    Spacer()
                    Image(systemName: "square.and.pencil")
                        .imageScale(Image.Scale.large)
                        .fontWeight(.bold)
                    
                        .padding(.horizontal)
                }
                
                Picker(selection: .constant(1), label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                    Text("Base Recipes").tag(1)
                    Text("Favorites").tag(2)
                    Text("Custom").tag(3)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                //SearchBar(text: searchText)
                HStack {
                    Text("Base Recipe")
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }
                
                
                Spacer()
            }
        }
    }


#Preview {
    ZStack {
        Color("Primary")
            .ignoresSafeArea()
        Dashboard()
    }
}
