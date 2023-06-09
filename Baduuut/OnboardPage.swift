//
//  OnboardPage.swift
//  Baduuut
//
//  Created by Jevon Levin on 21/03/23.
//

import SwiftUI
import Lottie
import UserNotifications
struct OnboardPage: View {
    @Binding var currentPage: Page
    @State private var isSheetVisible = false

    @State private var selectedTime = "Every 30 minutes"
    let times = ["Every 15 seconds", "Every 30 minutes", "Every 1 hour", "Every 2 hours"]
    let message: String = welcomeMessages.randomElement()!
    
    //timer
    @StateObject private var vm = ViewModel()

    let time:Float = 1.0

    var body: some View {
        MasterView(title: "Oh, hi 😒", subtitle: message, lottieFileName: "hello"){
            VStack{
                Text("\(vm.time)")
                    .fontWeight(.bold)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }.onReceive(globalTimer) {_ in
                vm.updateCountdown()
                if vm.hasFinished{
                    currentPage = .stretch
                    print("msk")
                }
            }
 
            Text("until your next stretch")
                .font(.system(size: 18))
                .foregroundColor(.white)
                .padding(.bottom, 20)
            
            //fix: tulisannya, warna button?
            if vm.isActive{
                Button("Stop Timer"){
                    vm.reset()
                    UserDefaults.standard.set(nil, forKey: "timer_end_date")
                    UserDefaults.standard.set(nil, forKey: "timer_interval")
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                }
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .padding()
                .frame(width: UIScreen.main.bounds.width - 32)
                .foregroundColor(.white)
                .background(Color("Danger"))
                .cornerRadius(8)
                .shadow(radius: 10)
            } else {
                Button("Set Session"){
                    isSheetVisible = true
                }
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .padding()
                .frame(width: UIScreen.main.bounds.width - 32)
                .foregroundColor(Color("Primary"))
                .background(.white)
                .cornerRadius(8)
                .shadow(radius: 10)
                .sheet(isPresented: $isSheetVisible) {
                    ZStack {
                        Color.white.ignoresSafeArea(.all)
                        VStack(spacing: .none){
                            Text("How often should I bug you?")
                                .multilineTextAlignment(.center)
                                .font(.title2)
                                .bold()
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color("Primary"))
                            
                            Picker("Time", selection: $selectedTime) {
                                ForEach(times, id: \.self) {
                                    Text($0)
                                        .fontWeight(.medium)
                                        .foregroundColor(Color("Secondary"))
                                    
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 120)
                            .scaleEffect(1.1)
                            .padding(.bottom, -5)
                            .padding(.top, -17)
                            
                            Button("Start!"){
                                isSheetVisible = false
                                let seconds = vm.extractTime(selected: $selectedTime.wrappedValue)
                                vm.start(seconds: seconds)
                                
                                
                                
                                UserDefaults.standard.set(seconds, forKey: "timer_interval")
                            }
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 32)
                            .background(Color("Primary"))
                            .cornerRadius(8)
                            
                        }
                        .presentationDetents([.height(260)])
                    }
                }
                
            }

            Button("Stretch Now"){
                currentPage = .stretch
            }
            .font(.system(size: 18))
            .fontWeight(.semibold)
            .padding()
            .frame(width: UIScreen.main.bounds.width - 32)
            .foregroundColor(Color("Primary"))
            .background(.white)
            .cornerRadius(8)
            .shadow(radius: 10)
        }
        .onAppear{
            if UserDefaults.standard.object(forKey: "timer_interval") != nil && UserDefaults.standard.object(forKey: "timer_end_date") == nil{
                let seconds: Float = UserDefaults.standard.object(forKey: "timer_interval") as! Float
                vm.start(seconds: seconds)
                
            }
        }
        
    }
}


struct OnboardPage_Previews: PreviewProvider {
    static var previews: some View {
        OnboardPage(currentPage: .constant(.onboard))
    }
}
