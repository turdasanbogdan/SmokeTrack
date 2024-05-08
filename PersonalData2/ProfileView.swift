//
//  ProfileView.swift
//  PersonalData2
//
//  Created by bogdan on 14.04.2024.
//

import SwiftUI

import SwiftUI

extension UserProfile {
    static var sampleProfile: UserProfile {
        UserProfile(
            name: "Jane",
            surname: "Doe",
            email: "jane.doe@example.com",
            dateOfBirth: Calendar.current.date(byAdding: .year, value: -30, to: Date()) ?? Date(),
            productType: "Cigarettes",
            packingType: "Box",
            quantity: 20,
            price: 5,
            goal: "Reduce smoking",
            consumption: 10,
            newTarget: 5,
            timeFrame: 6
        )
    }
}

struct ProfileView: View {
    
    @EnvironmentObject var userProfileManager: UserProfileManager
    @State private var showingEditPopup = false
    @State private var editingField = ""

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("About").font(.caption)) {
                    HStack {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading) {
                            Text("\(userProfileManager.userProfile.name) \(userProfileManager.userProfile.surname)")
                                .font(.caption).fontWeight(.bold)
                            Text("\(userProfileManager.userProfile.age) years old")
                                .font(.caption2)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            editingField = "personal"
                            showingEditPopup = true
                        }) {
                            Image("ic-profile-edit")
                                .foregroundColor(Color("Teams"))
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                }
                
                Section(header: Text("Product Information").font(.caption)) {
                    HStack {
                        Image("ic-profile-cig")
                            .resizable()
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading) {
                            Text("Packaging Type: \(userProfileManager.userProfile.packingType)")
                                .font(.caption2).fontWeight(.bold)
                            Text("Quantity: \(userProfileManager.userProfile.quantity)")
                            + Text(" pcs per Packaging")
                            Text("Price: \(userProfileManager.userProfile.price) DKK")
                        }
                        .font(.caption2)
                        
                        Spacer()
                        
                        Button(action: {
                            editingField = "product"
                            showingEditPopup = true
                        }) {
                            Image("ic-profile-edit")
                                .foregroundColor(Color("Teams"))
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                }
                
                Section(header: Text("Goal & Current Plan").font(.caption)) {
                    VStack(alignment: .leading) {
                        HStack {
                            Image("ic-profile-decrease")
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            VStack(alignment: .leading) {
                                Text(userProfileManager.userProfile.goal)
                                    .font(.caption).fontWeight(.bold)
                                
                                Text("Get a personalized plan to reduce the cigarette intake")
                                    .font(.caption2)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                editingField = "goal"
                                showingEditPopup = true
                            }) {
                                Image("ic-profile-edit")
                                    .foregroundColor(Color("Teams"))
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                        
                    }
                   
                }
                
                Section {
                    HStack {
                        Image("ic-profile-target")
                            .resizable()
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading) {
                            Text("Desired Target: \(userProfileManager.userProfile.newTarget) Cigarettes/Day")
                                .font(.caption).fontWeight(.bold)
                            Text("Time Frame: \(userProfileManager.userProfile.timeFrame) Months")
                                .font(.caption2)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            editingField = "target"
                            showingEditPopup = true
                        }) {
                            Image("ic-profile-edit")
                                .foregroundColor(Color("Teams"))
                             
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                }
                

            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showingEditPopup) {
                EditProfileView(editingField: $editingField, userProfileManager: _userProfileManager)
            }
        }
    }
}

struct EditProfileView: View {
    @Binding var editingField: String
    @EnvironmentObject var userProfileManager: UserProfileManager
    @Environment(\.presentationMode) var presentationMode
    let goalOptions = ["Quit Smoking", "Reduce my smoking consumption", "Track my smoking consumption"]
    
    var body: some View {
        NavigationView {
            Form {
                if editingField == "personal" {
                    Section(header: Text("Personal Information").textCase(.none)) {
                                        VStack(alignment: .leading, spacing: 20) {
                                            LabeledTextField(label: "Name", text: $userProfileManager.userProfile.name)
                                            LabeledTextField(label: "Surname", text: $userProfileManager.userProfile.surname)
                                            LabeledDatePicker(label: "Date of Birth", date: $userProfileManager.userProfile.dateOfBirth)
                                        }
                                    }

                } else if editingField == "product" {
                    
                    Section(header: Text("Edit Product Details").font(.headline)) {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Packaging Type").font(.callout).bold()
                            Picker("Select Packaging Type", selection: $userProfileManager.userProfile.packingType) {
                                Text("Cigarettes Box").tag("Cigarettes Box")
                                Text("Roll Your Own").tag("Roll Your Own")
                            }
                            .pickerStyle(SegmentedPickerStyle())  // Makes it look like buttons
                            .padding(.bottom, 10)
                            .accentColor(Color("Teams"))

                            Text("Quantity").font(.callout).bold()
                            TextField("Enter Quantity", value: $userProfileManager.userProfile.quantity, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 10)

                            Text("Price").font(.callout).bold()
                            TextField("Enter Price", value: $userProfileManager.userProfile.price, formatter: NumberFormatter())
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.vertical)
                    }
                } else if editingField == "goal" {
                    
                    Section(header: Text("Edit Goal").font(.headline)) {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Select Your Goal").font(.callout).bold()
                            Picker("Goal", selection: $userProfileManager.userProfile.goal) {
                                ForEach(goalOptions, id: \.self) { goal in
                                    Text(goal).tag(goal)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.bottom, 10)
                            .accentColor(Color("Teams"))
                        }
                        .padding(.vertical)
                    }
                } else if editingField == "target"{
                    
                    Section(header: Text("Set Your Targets").font(.headline)) {
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(alignment: .leading) {
                                Text("Desired Target").font(.callout).bold()
                                TextField("Enter Target (Cigarettes/Day)", value: $userProfileManager.userProfile.newTarget, formatter: NumberFormatter())
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }

                            VStack(alignment: .leading) {
                                Text("Time Frame").font(.callout).bold()
                                TextField("Enter Time Frame (Months)", value: $userProfileManager.userProfile.timeFrame, formatter: NumberFormatter())
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
            .navigationTitle("Edit \(editingField.capitalized)")
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let userProfileManager = UserProfileManager(userProfile: .sampleProfile)
        
        ProfileView()
            .environmentObject(userProfileManager)
            .previewLayout(.sizeThatFits)
    }
}

struct LabeledTextField: View {
    var label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            TextField(label, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
        }
    }
}



struct LabeledDatePicker: View {
    var label: String
    @Binding var date: Date

    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
        }
    }
}
