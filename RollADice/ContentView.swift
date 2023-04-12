//
//  ContentView.swift
//  RollADice
//
//  Created by Biagio Ricci on 12/04/23.
//

import CoreHaptics
import SwiftUI

struct ContentView: View {
    let diceTypes = [4, 6, 8, 10, 12, 20, 100]
    @State private var selectedDiceType = 4
    @State private var numberRolled: Int = 1
    @State private var engine: CHHapticEngine?
    var body: some View {
        NavigationView {
            Section {
                VStack{
                    Picker("Choose a dice", selection: $selectedDiceType) {
                        ForEach(diceTypes, id: \.self) { type in
                            Text("\(type)")
                        }
                    }
                    .pickerStyle(.wheel)
                    Text("Dice type selected: \(selectedDiceType)")
                    
                    Spacer()
                    
                    
                    Button {
                        rollADice()
                        
                    } label: {
                        ZStack{
                            Rectangle()
                                .fill(.indigo)
                                .shadow(color: .indigo, radius: 20, x: 0.0, y: 0.0)
                                .frame(width: 200, height: 200)
                            Text("\(numberRolled)")
                                .font(.system(size: 95))
                                .foregroundColor(.white)
                                .bold()
                        }
                    }
                    .onTapGesture {
                        complexSuccess()
                    }
                }
            }
            .navigationTitle("Dice")
            .preferredColorScheme(.dark)
            .onAppear{
                prepareHaptics()
            }
        }
    }
    
    func rollADice() {
        numberRolled = Int.random(in: 1...selectedDiceType)
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return}
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
