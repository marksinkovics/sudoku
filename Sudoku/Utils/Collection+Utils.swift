import Foundation

extension Collection {
    func count(where test:(Element) throws -> Bool) rethrows -> Int {
        return try self.filter(test).count
    }
}
