import UIKit
import SwiftUI

enum ArcNumpadDirection {
    case left, right
        
    var text: String {
        switch self {
            case .right: return "RIGHT"
            case .left: return "LEFT"
        }
    }

}

enum ArcNumpadKey {
    case numpad(Int)
    case clear
    
    var text: String {
        switch self {
            case .clear: return "X"
            case .numpad(let value): return "\(value)"
        }
    }
}

protocol ArcNumpadUIViewDelegate: AnyObject {
    func tapped(key: ArcNumpadKey) -> Void
}

class ArcNumpadUIView: UIView {
    
    private struct Constants {
        static let numberOfTiles = 5
        static let lineWidth: CGFloat = 2.0
        static let arcWidth: CGFloat = 40
        static let selectedArcWidthOffset: CGFloat = 20
        static let textSize: CGFloat = 24
        static let selectedTextSize: CGFloat = 28
        static var halfOfLineWidth: CGFloat {
            return lineWidth / 2
        }
        static let texts: [ArcNumpadKey] = (1...9).map { ArcNumpadKey.numpad($0) } + [.clear]
        
        static var outlineColor: UIColor = .black
        static var counterColor: UIColor = .white
        static var selectedColor: UIColor = .yellow
        static let startAngle: CGFloat = 3 * .pi / 4 //135
        static let endAngle: CGFloat = -(.pi / 2) //-45
        static let angleDifference: CGFloat = 2 * .pi - startAngle + endAngle

    }
    
    private class Tile {
        var key: ArcNumpadKey
        var path: UIBezierPath
        var selectedPath: UIBezierPath
        var outlinePath: UIBezierPath
        var selectedOutlinePath: UIBezierPath
        var textPosition: CGPoint
        var selectedTextPosition: CGPoint

        internal init(key: ArcNumpadKey, path: UIBezierPath, outlinePath: UIBezierPath, selectedPath: UIBezierPath, selectedOutlinePath: UIBezierPath, textPosition: CGPoint, selectedTextPosition: CGPoint) {
            self.key = key
            self.path = path
            self.outlinePath = outlinePath
            self.selectedPath = selectedPath
            self.selectedOutlinePath = selectedOutlinePath
            self.textPosition = textPosition
            self.selectedTextPosition = selectedTextPosition
        }

    }
    
    var touchLocation: CGPoint = .zero
        
    var direction: ArcNumpadDirection = .left {
        didSet {
            debugPrint("direction: \(direction.text)")
            self.tiles = generateTiles()
        }
    }
    
    private var tiles: [Tile] = []
    
    weak var delegate: ArcNumpadUIViewDelegate? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect {
        didSet {
            self.tiles = generateTiles()
        }
    }
    
    func rad2deg(_ number: CGFloat) -> CGFloat {
        return number * 180.0 / .pi
    }

    func deg2rad(_ number: CGFloat) -> CGFloat {
        return number * .pi / 180.0
    }

        
    //
    // Touches
    //
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchLocation = touch.location(in: self)
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchLocation = touch.location(in: self)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let tile = tiles.first(where: { $0.outlinePath.contains(touchLocation) }) {
            self.delegate?.tapped(key: tile.key)
        }

        touchLocation = .zero
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchLocation = .zero
        setNeedsDisplay()
    }

    //
    // Tile, Path
    //

    
    private func generateTiles() -> [Tile] {
        var result: [Tile] = []
        for rowIndex in 0...1 {
            for columnIndex in 0..<Constants.numberOfTiles {
                let path = tilePath(forRow: rowIndex, column: columnIndex, selected: false)
                let outlinePath = tileOutlinePath(forRow: rowIndex, column: columnIndex, selected: false)
                let selectedPath = tilePath(forRow: rowIndex, column: columnIndex, selected: true)
                let selectedOutlinePath = tileOutlinePath(forRow: rowIndex, column: columnIndex, selected: true)
                let (textPosition, _, _) = textPositionAngle(forRow: rowIndex, column: columnIndex, selected: false)
                let (selectedTextPosition, _, _) = textPositionAngle(forRow: rowIndex, column: columnIndex, selected: true)
                let text = Constants.texts[rowIndex * Constants.numberOfTiles + columnIndex]
                
                let tile = Tile(key: text,
                                path: path,
                                outlinePath: outlinePath,
                                selectedPath: selectedPath,
                                selectedOutlinePath: selectedOutlinePath,
                                textPosition: textPosition,
                                selectedTextPosition: selectedTextPosition)
                result.append(tile)
            }
        }
        return result
    }
        
    func point(angle: CGFloat, radius: CGFloat, center: CGPoint) -> CGPoint {
        let x: CGFloat = center.x + radius * cos(angle)
        let y: CGFloat = center.y + radius * sin(angle)
        return CGPoint(x: x, y: y)
    }

    
    func textPositionAngle(forRow row: Int, column: Int, selected: Bool) -> (position: CGPoint, angle: CGFloat, radius: CGFloat) {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = max(bounds.midX, bounds.midY) - Constants.selectedArcWidthOffset

        let offsetRadius = CGFloat(row) * Constants.arcWidth
        let arcLengthPerTile = Constants.angleDifference / CGFloat(Constants.numberOfTiles)
        let directionOffsetAngle: CGFloat = direction == .left ? -Constants.angleDifference - (.pi / 2)  : 0
        let textAngle = Constants.startAngle + directionOffsetAngle + (CGFloat(column) * arcLengthPerTile) + (arcLengthPerTile / 2)

        let textRadius  = radius - Constants.arcWidth / 3 - offsetRadius + (selected ? Constants.selectedArcWidthOffset / 2 : 0)
        
        let position = point(angle: textAngle, radius: textRadius, center: center)
        return (position, textAngle, textRadius)
    }
    
    func tilePath(forRow row: Int, column: Int, selected: Bool) -> UIBezierPath {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = max(bounds.midX, bounds.midY) - Constants.selectedArcWidthOffset
        
        let arcWidth = Constants.arcWidth
        let offsetRadius = CGFloat(row) * arcWidth
        let arcLengthPerTile = Constants.angleDifference / CGFloat(Constants.numberOfTiles)
        let tileRadius  = radius - arcWidth / 2 - offsetRadius + (selected ? Constants.selectedArcWidthOffset / 2 : 0)
        
        let selectedAngleOffset = selected ? deg2rad(4) : 0
        let directionOffsetAngle: CGFloat = direction == .left ? -Constants.angleDifference - (.pi / 2)  : 0
        let tileStartAngle = Constants.startAngle + directionOffsetAngle + (CGFloat(column) * arcLengthPerTile) - selectedAngleOffset
        let tileEndAngle = Constants.startAngle + directionOffsetAngle + (CGFloat((column + 1)) * arcLengthPerTile) + selectedAngleOffset
        
        let path = UIBezierPath(arcCenter: center, radius: tileRadius, startAngle: tileStartAngle, endAngle: tileEndAngle, clockwise: true)
        path.lineWidth = arcWidth + (selected ? Constants.selectedArcWidthOffset : 0)
        return path
    }
    
    func tileOutlinePath(forRow row: Int, column: Int, selected: Bool) -> UIBezierPath {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = max(bounds.midX, bounds.midY) - Constants.selectedArcWidthOffset
        let arcWidth = Constants.arcWidth
        
        let offsetRadius = CGFloat(row) * arcWidth
        let angleParTile = Constants.angleDifference / CGFloat(Constants.numberOfTiles)
        
        let selectedAngleOffset = selected ? deg2rad(4) : 0
        let directionOffsetAngle: CGFloat = direction == .left ? -Constants.angleDifference - (.pi / 2)  : 0
        let outlineStartAngle = Constants.startAngle + directionOffsetAngle + (CGFloat(column) * angleParTile) - selectedAngleOffset
        let outlineEndAngle = Constants.startAngle + directionOffsetAngle + (CGFloat((column + 1)) * angleParTile) + selectedAngleOffset
        
        let outerArcRadius = radius - Constants.halfOfLineWidth - offsetRadius + (selected ? Constants.selectedArcWidthOffset : 0)
        let outlinePath = UIBezierPath(arcCenter: center, radius: outerArcRadius, startAngle: outlineStartAngle, endAngle: outlineEndAngle, clockwise: true)
        let innerArcRadius = radius - arcWidth + Constants.halfOfLineWidth - offsetRadius
        outlinePath.addArc(withCenter: center, radius: innerArcRadius, startAngle: outlineEndAngle, endAngle: outlineStartAngle, clockwise: false)
        outlinePath.close()
        outlinePath.lineWidth = Constants.lineWidth
        return outlinePath
    }
    
    
    //
    // Draw
    //
        
    override func draw(_ rect: CGRect) {
                
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attrs = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: Constants.textSize),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]

        let selectedAttrs = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: Constants.selectedTextSize),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]

        
        let targetSize = CGSize(width: Constants.textSize, height: Constants.textSize)
        let selectedTargetSize = CGSize(width: Constants.selectedTextSize, height: Constants.selectedTextSize)

        
        for tile in tiles where !tile.outlinePath.contains(touchLocation) {
            
            Constants.counterColor.setStroke()
            tile.path.stroke()
            Constants.outlineColor.setStroke()
            tile.outlinePath.stroke()

            let boundingRect = tile.key.text.boundingRect(with: targetSize,
                                                          options: [.usesLineFragmentOrigin],
                                                          attributes: attrs,
                                                          context: nil)
            
            let textRect = CGRect(x: tile.textPosition.x - (boundingRect.width / 2),
                                  y: tile.textPosition.y - (boundingRect.height / 2),
                                  width: boundingRect.width,
                                  height: boundingRect.height)

            tile.key.text.draw(with: textRect, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }

        
        for tile in tiles where tile.outlinePath.contains(touchLocation) {
            
            Constants.selectedColor.setStroke()
            tile.selectedPath.stroke()
            Constants.outlineColor.setStroke()
            tile.selectedOutlinePath.stroke()
                        
            let boundingRect = tile.key.text.boundingRect(with: selectedTargetSize,
                                                          options: [.usesLineFragmentOrigin],
                                                          attributes: selectedAttrs,
                                                          context: nil)
            
            let textRect = CGRect(x: tile.selectedTextPosition.x - (boundingRect.width / 2),
                                  y: tile.selectedTextPosition.y - (boundingRect.height / 2),
                                  width: boundingRect.width,
                                  height: boundingRect.height)

            tile.key.text.draw(with: textRect, options: .usesLineFragmentOrigin, attributes: selectedAttrs, context: nil)
        }

        
    }
}
