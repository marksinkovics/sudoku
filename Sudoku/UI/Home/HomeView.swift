import SwiftUI

import UIKit

struct HomeView: View {
    
    enum Option {
        
        case easy
        case medium
        case hard
        case expert
        case `continue`
        case settings
        
        @ViewBuilder
        static func buildView(for option: Option) -> some View {
            switch option {
            case .easy:
                GameView(state: .new(difficulty: .easy))
            case .medium:
                GameView(state: .new(difficulty: .medium))
            case .hard:
                GameView(state: .new(difficulty: .hard))
            case .expert:
                GameView(state: .new(difficulty: .expert))
            case .`continue`:
                GameView(state: .`continue`)
            case .settings:
                SettingsView()
            }
        }
    }

    @State private var isContinueActive: Bool = false
    @State private var showingActionSheet: Bool = false
    @State private var showDetail: Bool = false
    @State private var selectedOption: Option? = nil
        
    func checkForSavedGame() {
        GameController.loadSavedGame() { game in
            self.isContinueActive = game != nil
        }
    }
                    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            Text("SUDOKU")
                .font(.system(size: 48, weight: .black, design: .rounded))
                .foregroundColor(Color.App.Home.title)
            Text("a puzzle game")
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundColor(Color.App.Home.title)
            Spacer()
            MenuItemView("New game") { self.showingActionSheet = true }
                .padding(30)
            if self.isContinueActive {
                MenuItemView("Continue") { selectedOption = .continue }
                    .padding(30)
            }
            MenuItemView("Settings", style: .secondary) { selectedOption = .settings }
                .padding(.top, 130)
                .padding(30)
            Spacer()
        }
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.App.background)
        .edgesIgnoringSafeArea(.all)
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text("Select the difficulty"), buttons: [
                .default(Text("Easy")) { selectedOption = .easy },
                .default(Text("Medium")) { selectedOption = .medium },
                .default(Text("Hard")) { selectedOption = .hard },
                .default(Text("Expert")) { selectedOption = .expert },
                .cancel()
            ])
        }
        .onAppear {
            checkForSavedGame()
        }
        .navigate(using: $selectedOption, destination: Option.buildView)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.colorScheme, .dark)
    }
}
