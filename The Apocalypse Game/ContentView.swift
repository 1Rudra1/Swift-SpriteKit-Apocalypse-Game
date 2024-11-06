//
//  ContentView.swift
//  The Apocalypse Game
//
//  Created by Rudra Patel on 1/21/22.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    var scene:SKScene{
        let scene = GameScene()
        scene.size = CGSize(width: 2000, height: 1500)
        scene.scaleMode = .aspectFill
        scene.anchorPoint = CGPoint(x:0, y:0)
        return scene
    }
    
    @State private var isGameShowing = false
    @State var sliderValue: Double = 3.0
//    @State var coinAmount: Double = 30.0
    
    var body: some View {
        ZStack {
            Color.brown.ignoresSafeArea()

            
            VStack {
            
                Spacer()
                
                Text("Cannon Coin")
                    .font(.system(size: 45))
                    .font(.callout).foregroundColor(.black)
                    .fontWeight(.bold)
                    .underline()
                
                Spacer()
                Spacer()
                
                Button(action: {
                    
                    SettingsData.shared.speed = sliderValue
//                    SettingsData.shared.coins = coinAmount
                    
                    isGameShowing.toggle()
                }
                ){
                    Text("Start")
                        .font(.system(size: 35))
                        .font(.callout).foregroundColor(.green)
                        .fontWeight(.bold)
                        .frame(width: 150, height: 60)
                        .background(Color.black)
                }
                
                Spacer()
                
                
                Text("Difficulty Slider Value: \(sliderValue, specifier: "%.2f")")
                    .font(.system(size: 25))
                    .font(.callout).foregroundColor(.blue)
                
                
                HStack {
                    Image(systemName: "plus")
                    Slider(value: $sliderValue, in: 0...10, step: 1)
                        .accentColor(Color.green)
                    Image(systemName: "minus")
        
                }
                .foregroundColor(Color.green)
                
                Spacer()
//
//                Text("Coin Amount: \(coinAmount, specifier: "%.2f")")
//                    .font(.system(size: 25))
//                    .font(.callout).foregroundColor(.blue)
//
                

//                HStack {
//                    Image(systemName: "plus")
//                    Slider(value: $coinAmount, in: 0...10, step: 1)
//                        .accentColor(Color.green)
//                    Image(systemName: "minus")
//                }
//                .foregroundColor(Color.green)
                
                
            }
            
        }
        .fullScreenCover(isPresented: $isGameShowing) {
                SpriteView(scene:scene)
                    .frame(width: 1000, height: 750)
                    .ignoresSafeArea()
                    
            }
     
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
