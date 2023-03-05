import Foundation

class History: ObservableObject {

    enum Keys: String {
        case saved = "saved"
    }

    var items: [BoardData] = []

    var isEmpty: Bool {
        return items.isEmpty
    }

    func set(data: BoardData) {
        if items.isEmpty {
            items.append(data)
        } else {
            items[0] = data
        }
    }

    func load() async {
        guard let encodedData = UserDefaults.standard.data(forKey: Keys.saved.rawValue) else {
            debugPrint("No saved game")
            return
        }

        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(BoardData.self, from: encodedData)
            self.items.append(result)
        } catch {
            debugPrint(error)
        }
    }

    func save() {
        guard let data = items.first else { return  }

        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(data)
            UserDefaults.standard.set(encodedData, forKey: "saved")
        } catch {
            debugPrint(error)
        }

    }

    func delete(data: BoardData) {

    }

    func cleanAll() {
        items.removeAll();
        UserDefaults.standard.removeObject(forKey: "saved")
    }
}
