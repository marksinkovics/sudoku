import SwiftUI
import UIKit


struct HomeView: View {

    enum Option: Hashable {

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

    @EnvironmentObject var history: History
    @EnvironmentObject var router: Router

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
                MenuItemView("Continue") { router.path.append(Option.continue) }
                .padding(30)
            }
            MenuItemView("Settings", style: .secondary) { router.path.append(Option.settings) }
            .padding(.top, 130)
            .padding(30)
            Spacer()
        }
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.App.background)
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showingActionSheet) {
            DifficultySheetView(items: [
                MenuItemView("Easy") {
                    showingActionSheet = false
                    router.path.append(Option.easy)
                },
                MenuItemView("Medium") {
                    showingActionSheet = false
                    router.path.append(Option.medium)
                },
                MenuItemView("Hard") {
                    showingActionSheet = false
                    router.path.append(Option.hard)
                },
                MenuItemView("Expert") {
                    showingActionSheet = false
                    router.path.append(Option.expert)
                },
            ])
        }
        .task {
            await history.load();
            self.isContinueActive = !history.isEmpty
        }
        .navigationDestination(for: Option.self) { option in
            Option.buildView(for: option)
        }

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.colorScheme, .dark)
    }
}
