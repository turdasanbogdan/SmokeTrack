//
//  MultiStepForm.swift
//  PersonalData2
//
//  Created by bogdan on 24.04.2024.
//
import SwiftUI

struct Step1View: View {
    @Binding var currentStep: Int
    @Binding var userProfile: UserProfile
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var email: String = ""
    @State private var dateOfBirth = Date()
    @State private var isDatePickerExpanded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Personal Information")
                .font(.title)
                .padding()
            
            Text("Name")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Name", text: $userProfile.name)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .textFieldStyle(PlainTextFieldStyle())
                .frame(height: 48)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 0.5))
                .padding(.bottom)
            
            Text("Surname")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Surname", text: $userProfile.surname)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .textFieldStyle(PlainTextFieldStyle())
                .frame(height: 48)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 0.5))
                .padding(.bottom)
            
            Text("Email")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Email", text: $userProfile.email)
                .keyboardType(.emailAddress)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .textFieldStyle(PlainTextFieldStyle())
                .frame(height: 48)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 0.5))
                .padding(.bottom)
            

            
            Spacer()
            
            DatePicker("Date of Birth", selection: $userProfile.dateOfBirth, displayedComponents: .date)
                .accentColor(Color("Teams"))
            
            Spacer()
            
            Button( action: {
                currentStep += 1
            }){
                
                Image("ic-button-next-stamp")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
               
            }
        }
        .padding()
    }
}



struct Step2View: View {
    @Binding var currentStep: Int
    @Binding var userProfile: UserProfile
    @State private var selectedProduct: String?

    var body: some View {
        VStack {
            Text("What products do you currently use?")
                .font(.title)
                .padding()

            VStack(spacing: 10) {
                // Array of product names
                let productNames = ["Cigarettes", "Tobacco", "Vaping Devices", "E-Cigarette", "Others"]
                
                ForEach(productNames, id: \.self) { product in
                    Button(action: {
                        self.selectedProduct = product
                    }) {
                        Text(product)
                            .foregroundColor(self.selectedProduct == product ? .white : .black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(self.selectedProduct == product ? Color("Teams") : Color.clear)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
                    }
                    .animation(.easeInOut, value: selectedProduct)
                }
            }
            .padding()
            
            Spacer()

            VStack {
                
                Button( action: {
                    currentStep += 1
                    userProfile.productType = selectedProduct ?? ""
                }){
                    
                    Image("ic-button-next-stamp")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                   
                }
                
                
                Button( action: {
                    currentStep -= 1
                }){
                    
                    Image("ic-button-previous-stamp")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .padding()
        }
        .padding()
    }
}


struct Step3View: View {
    @Binding var currentStep: Int
    @Binding var userProfile: UserProfile
    @State private var packingType: String = "Cigarettes Pack"
    @State private var cigaretteCount: Int = 23
    @State private var productPrice: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Product Information")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            
            Text("Type of Packing")
                .padding(.top)
            Text("Specify the type of cigarettes packing")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Menu {
                Picker("Select Packing Type", selection: $packingType) {
                    Text("Cigarettes Pack").tag("Cigarettes Pack")
                    Text("Roll your own").tag("Roll your own")
                }
            } label: {
                HStack {
                    Text(packingType)
                        .foregroundColor(Color("Teams"))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color("Teams"))
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
            }
            .padding(.bottom)
            
           
            
            Text("Cigarettes Quantity")
                .padding(.top)
            Text("Specify the quantity of cigarettes per packing")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Text("Count")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                
                Text("\(cigaretteCount)")
                    .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    if cigaretteCount > 1 { cigaretteCount -= 1 }
                }) {
                    Image(systemName: "minus.circle")
                        .foregroundColor(Color("Teams"))
                }
                                
                Button(action: {
                    cigaretteCount += 1
                }) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(Color("Teams"))
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
            
            Text("Product Price")
                .padding(.top)
            Text("Specify the price of one pack")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Text("Price: ")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                TextField("Enter price", text: $productPrice)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer()
                
                Text("DKK")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
            
            Spacer()
            
            VStack {
                
                Button( action: {
                    currentStep += 1
                    userProfile.price = Int(productPrice) ?? 0
                    userProfile.quantity = cigaretteCount
                    userProfile.packingType = packingType
                }){
                    
                    Image("ic-button-next-stamp")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                 
                }
                
                
                Button( action: {
                    currentStep -= 1
                }){
                    
                    Image("ic-button-previous-stamp")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                  
                }
            }
            .padding()
        }
        .padding()
    }
}

struct Step4View: View {
    @Binding var currentStep: Int
    @Binding var userProfile: UserProfile
    @State private var selectedProduct: String?

    var body: some View {
        VStack {
            Text("What is your goal?")
                .font(.title)
                .padding()
            
            Text("Choose the mode which suits you the best right now. You can change this later on at any time.")
                .font(.subheadline)
                .foregroundColor(Color("Teams2"))
            
            Spacer()

            VStack(spacing: 10) {
               
                let goals = ["Quit Smoking", "Reduce my smoking consumption", "Track my smoking consumption"]
                
                ForEach(goals, id: \.self) { product in
                    Button(action: {
                        self.selectedProduct = product
                    }) {
                        Text(product)
                            .foregroundColor(self.selectedProduct == product ? .white : .black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(self.selectedProduct == product ? Color("Teams") : Color.clear)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
                    }
                    .animation(.easeInOut, value: selectedProduct)
                }
            }
            .padding()
            
            Spacer()

            VStack {
                
                Button( action: {
                    currentStep += 1
                    userProfile.goal = selectedProduct ?? ""

                }){
                    
                    Image("ic-button-next-stamp")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                   
                }
                
                
                Button( action: {
                    currentStep -= 1
                }){
                    
                    Image("ic-button-previous-stamp")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                   
                }
            }
            .padding()
        }
        .padding()
    }
}

struct Step5View: View {
    
    @Binding var currentStep: Int
    @Binding var userProfile: UserProfile
    @State private var cigarettesPerDay: String = ""
    @State private var cigarettesTarget: String = ""
    @State private var monthsTarget: String = ""
    @Binding  var showCheckmark: Bool
    @EnvironmentObject var userProfileManager: UserProfileManager
    @State private var showingPlanCreation = false
    @State private var showingCompletionView = false
    
    
    var body: some View {
        VStack(alignment: .leading) {
             
                  mainContentView()
              
          }.fullScreenCover(isPresented: $showingPlanCreation) {
              CreatingPlanView(showingPlanCreation: $showingPlanCreation, showingCompletionView: $showingCompletionView)
          }
          .fullScreenCover(isPresented: $showingCompletionView) {
              ModifiedCompletionView(isActiveComplete: $showingCompletionView, currentStep: $currentStep)
          }
    }
        
        
        
        @ViewBuilder
        func mainContentView() -> some View {
            
        
            VStack(alignment: .leading) {
                
                Text("Tell us about your habbits")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                
                Text("Current consumptions")
                    .padding(.top)
                Text("Give an aproximate of the quantity of cigarettes per day")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)

                
                TextField("Cigarettes/Day", text: $cigarettesPerDay)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(height: 48)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 0.5))
                    .padding(.bottom)
                
                
                Text("New Target")
                    .padding(.top)
                
                Text("Give an aproximate of the new quantity of cigarettes that you would like to consume per day")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                
                TextField("Cigarettes/Day", text: $cigarettesTarget)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(height: 48)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 0.5))
                    .padding(.bottom)
                
                
                Text("Time Frame")
                    .padding(.top)

                Text("Specify the time frame in months that you would like to achieve your goals")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                TextField("Months", text: $monthsTarget)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(height: 48)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 0.5))
                    .padding(.bottom)
                

                
                Spacer()
                
        
                
                VStack {
                    
                    Button( action: {
                        showingPlanCreation = true
                        userProfile.consumption = Int(cigarettesPerDay) ?? 0
                        userProfile.newTarget = Int(cigarettesTarget) ?? 0
                        userProfile.timeFrame = Int(monthsTarget) ?? 0
                        print(userProfileManager.userProfile)
                    }){
                        
                        Image("ic-button-next-stamp")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                    }
                    
                    
                    Button( action: {
                        currentStep -= 1
                    }){
                        
                        Image("ic-button-previous-stamp")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    
                    }
                }
                .padding()
            }
            .padding()
            
        }

    
}

struct CreatingPlanView: View {
    @Binding var showingPlanCreation: Bool
    @Binding var showingCompletionView: Bool

    @State private var activeIndex: Int = 0

    var body: some View {
        VStack {
            Spacer()
            Text("Creating Plan")
                .font(.title)
                .foregroundColor(Color("Teams"))
            
            HStack(spacing: 10) {
                ForEach(0..<3) { index in
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color("Teams"))
                        .opacity(activeIndex == index ? 1 : 0.3)
                }
            }
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                    animateDots()
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Teams3Background").edgesIgnoringSafeArea(.all))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showingPlanCreation = false
                showingCompletionView = true
            }
        }
    }
    
    func animateDots() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            activeIndex = (activeIndex + 1) % 3
        }
    }
}


struct ModifiedCompletionView: View {
    @Binding var isActiveComplete: Bool
    @Binding var currentStep: Int
    @State private var scale: CGFloat = 1.0

    var body: some View {
        VStack {
            Spacer()
            Text("Plan Created Successfully")
                .font(.title)
                .foregroundColor(Color("Teams2"))
            
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(Color("Teams"))
                .scaleEffect(scale)
                .onAppear {
                    
                    let baseAnimation = Animation.easeInOut(duration: 1)
                    withAnimation(baseAnimation.repeatForever(autoreverses: true)) {
                        scale = 1.2
                    }
                    
                }
            
            Spacer()
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Teams3Background").edgesIgnoringSafeArea(.all))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isActiveComplete = false
                currentStep += 1
            }
        }
    }
}

struct MultiStepForm: View {
    @State private var currentStep = 0
    @State private var showCheckmark = false
    let totalSteps = 5
    @EnvironmentObject var userProfileManager: UserProfileManager
    
    var body: some View {
        
        
        
        NavigationView {
            
            
            
            VStack {
                
                
                
                if currentStep < 5 {
                    ProgressBar(currentStep: currentStep, totalSteps: totalSteps)
                    
                    if currentStep == 0 {
                        Step1View(currentStep: $currentStep, userProfile: $userProfileManager.userProfile)
                    } else if currentStep == 1 {
                        Step2View(currentStep: $currentStep, userProfile: $userProfileManager.userProfile)
                    } else if currentStep == 2 {
                        Step3View(currentStep: $currentStep, userProfile: $userProfileManager.userProfile)
                    }
                    else if currentStep == 3 {
                        Step4View(currentStep: $currentStep, userProfile: $userProfileManager.userProfile)
                    }
                    else if currentStep == 4 {
                        Step5View(currentStep: $currentStep,
                                  userProfile: $userProfileManager.userProfile,
                                  showCheckmark: $showCheckmark )
                            .environmentObject(userProfileManager)
                    }
                    
                }else{
                   
                    ContentView()
                        .navigationBarBackButtonHidden(true)
                }

            }
        }
        .overlay(
            checkmarkOverlay
        )
        .navigationBarBackButtonHidden(true)
    }
    

    
    var checkmarkOverlay: some View {
        Group {
            if showCheckmark {
                VStack {
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.green)
                        .transition(.scale(scale: 0.1, anchor: .center).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.5)) 
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showCheckmark = false
                                    currentStep = 6
                                }
                            }
                        }
                    Spacer()
                }
            }
        }
    }
}



struct ProgressBar: View {
    let currentStep: Int
    let totalSteps: Int

    var body: some View {
        HStack {
            ForEach(0..<totalSteps) { step in
                RoundedRectangle(cornerRadius: 5)
                    .fill(step <= currentStep ? Color("Teams") : Color.gray)
                    .frame(height: 6)
            }
        }
        .padding()
    }
}
