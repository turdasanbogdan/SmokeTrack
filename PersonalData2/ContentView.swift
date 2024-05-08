import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showRecordSmoke = false
    @State private var isActive = false
    
    @EnvironmentObject var smokeStore: SmokeStore
    
    var userProfile = UserProfile(name: "Dan", surname: "Dan", email: "", dateOfBirth: Date(), productType: "Cigarettes", packingType: "Carton", quantity: 25, price: 50, goal: "Quit Smoking", consumption: 12, newTarget: 7, timeFrame: 10)


    var body: some View {
        ZStack {
        
            switch selectedTab {
            case 0:

                 HomeView(smokeStore: smokeStore)
            case 1:

                 DataOverview2(smokeStore: smokeStore)
            case 3:
                LearnView()

            case 4:
                ProfileView()
            default:
                Text("Selection does not exist")
            }

            VStack {
                Spacer()
                customTabBar
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(radius: 2)
            }
            
            if showRecordSmoke {
                StartingStampView(showRecordSmoke: $showRecordSmoke, isActive: $isActive)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.opacity(1).edgesIgnoringSafeArea(.all))
                    .zIndex(1)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
        

    var customTabBar: some View {
        HStack {
            VStack {
                tabButton(icon: "ic-home", selectedIcon: "ic-home-fill", tag: 0)
                Text("Home")
                    .font(.caption)
            }
            .padding(.leading, 10)

            VStack {
                tabButton(icon: "ic-dash-boards", selectedIcon: "ic-dash-boards-fill", tag: 1)
                Text("Data")
                    .font(.caption)
            }

            VStack {
                tabButton(icon: "ic-record-smokes", size: 50, tag: 2)
            }

            VStack {
                tabButton(icon: "ic-smokes", selectedIcon: "ic-smokes-fill", tag: 3)
                Text("Learn")
                    .font(.caption)
            }

            VStack {
                tabButton(icon: "ic-profile", selectedIcon: "ic-profile-fill", tag: 4)
                Text("Profile")
                    .font(.caption)
            }
            .padding(.trailing, 10)
        }
        .padding(.horizontal)
    }

    func tabButton(icon: String, selectedIcon: String? = nil, size: CGFloat = 20, yOffset: CGFloat = 0, tag: Int) -> some View {
        Button(action: {
            if tag == 2 {
                showRecordSmoke = true
            } else {
                selectedTab = tag
                showRecordSmoke = false
            }
        }) {
            Image(selectedTab == tag ? (selectedIcon ?? icon) : icon)
                .scaledToFit()
                .frame(width: size, height: size - 15)
                .padding()
                .offset(y: yOffset)
        }
    }
}
