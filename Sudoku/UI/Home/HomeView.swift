import SwiftUI

import UIKit

struct NavigationBarColor: ViewModifier {

  init(backgroundColor: UIColor, tintColor: UIColor) {
    let coloredAppearance = UINavigationBarAppearance()
    coloredAppearance.configureWithOpaqueBackground()
    coloredAppearance.backgroundColor = backgroundColor
    coloredAppearance.titleTextAttributes = [.foregroundColor: tintColor]
    coloredAppearance.largeTitleTextAttributes = [.foregroundColor: tintColor]
    coloredAppearance.shadowColor = .clear
    coloredAppearance.shadowImage = UIImage()

    UINavigationBar.appearance().standardAppearance = coloredAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    UINavigationBar.appearance().compactAppearance = coloredAppearance
    UINavigationBar.appearance().tintColor = tintColor
  }

  func body(content: Content) -> some View {
    content
  }
}

struct ToolBarColor: ViewModifier {
    init(backgroundColor: UIColor, tintColor: UIColor) {
        UIToolbar.appearance().barTintColor = backgroundColor
        UIToolbar.appearance().backgroundColor = backgroundColor
        UIToolbar.appearance().setShadowImage(nil, forToolbarPosition: .any)
    }
    
    func body(content: Content) -> some View {
      content
    }
}

extension View {
    func navigationBarColor(backgroundColor: UIColor, tintColor: UIColor) -> some View {
        self.modifier(NavigationBarColor(backgroundColor: backgroundColor, tintColor: tintColor))
    }
    
    func toolBarColor(backgroundColor: UIColor, tintColor: UIColor) -> some View {
        self.modifier(ToolBarColor(backgroundColor: backgroundColor, tintColor: tintColor))
    }
}

struct HomeView: View {
    
    struct MenuOptions {
        enum OptionType {
            case easy
            case medium
            case hard
            case expert
            case `continue`
            case settings
        }
        
        typealias Option = (id: UUID, value: String, type: Self.OptionType)
        static var options: [Option] = [
            (UUID(), "Easy", .easy),            // 0
            (UUID(), "Medium", .medium),        // 1
            (UUID(), "Hard", .hard),            // 2
            (UUID(), "Expert", .expert),        // 3
            (UUID(), "Continue", .`continue`),  // 4
            (UUID(), "Settings", .settings),    // 5
        ]
        
        static func option(for optionType: OptionType) -> Option {
            switch optionType {
            case .easy:
                return options[0]
            case .medium:
                return options[1]
            case .hard:
                return options[2]
            case .expert:
                return options[3]
            case .`continue`:
                return options[4]
            case .settings:
                return options[5]
            }
        }
        
        static func buildView(for option: Option) -> some View {
            switch option.type {
            case .easy:
                return AnyView(GameView(state: .new(difficulty: .easy)))
            case .medium:
                return AnyView(GameView(state: .new(difficulty: .medium)))
            case .hard:
                return AnyView(GameView(state: .new(difficulty: .hard)))
            case .expert:
                return AnyView(GameView(state: .new(difficulty: .expert)))
            case .`continue`:
                return AnyView(GameView(state: .`continue`))
            case .settings:
                return AnyView(SettingsView())
            }
        }
    }

    @State private var isContinueActive: Bool = false
    @State private var showingActionSheet: Bool = false
    @State private var selectedOption: MenuOptions.Option = (id: UUID(), "", .easy)
    @State private var showDetail: Bool = false

    func hasSavedGame() -> Bool {
        return GameController.load() != nil
    }
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.sText
    }
    
    func show(option: MenuOptions.OptionType) {
        selectedOption = MenuOptions.option(for: option)
        showDetail = true
    }
            
    var body: some View {
        NavigationView {
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
                MenuItemView("Continue", enabled: self.$isContinueActive) { show(option: .continue) }
                    .padding(30)
                MenuItemView("Settings", style: .secondary) { show(option: .settings) }
                    .padding(.top, 130)
                    .padding(30)
                NavigationLink("", destination: MenuOptions.buildView(for: selectedOption), isActive: $showDetail)
                    .opacity(0)
                Spacer()
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.App.background)
            .edgesIgnoringSafeArea(.all)
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Select the difficulty"), buttons: [
                    .default(Text("Easy")) { show(option: .easy) },
                    .default(Text("Medium")) { show(option: .medium) },
                    .default(Text("Hard")) { show(option: .hard) },
                    .default(Text("Expert")) { show(option: .expert) },
                    .cancel()
                ])
            }
            .navigationBarColor(backgroundColor: .sBackground, tintColor: .sText)
            .toolBarColor(backgroundColor: .sBackground, tintColor: .sText)
            .onAppear {
                self.isContinueActive = self.hasSavedGame()
            }
        }
        .background(Color.App.background)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.colorScheme, .dark)
    }
}
