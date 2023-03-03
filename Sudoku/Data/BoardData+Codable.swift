import Foundation


extension BoardData: Codable {

    private enum CodingKeys: String, CodingKey {
        case grid
        case solution
        case difficulty
    }

    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.grid = try container.decode([Item].self, forKey: .grid)
        self.solution = try container.decode([Int].self, forKey: .solution)
        self.difficulty  = try container.decode(Difficulty.self, forKey: .difficulty)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(grid, forKey: .grid)
        try container.encode(solution, forKey: .solution)
        try container.encode(difficulty, forKey: .difficulty)
    }
}
