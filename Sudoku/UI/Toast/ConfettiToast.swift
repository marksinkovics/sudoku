import UIKit
import SwiftUI

class ConfettiParticleView: UIView {
    
    var particleImage: UIImage? = UIImage(named: "confetti")
        
    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
    
    var emitterLayer: CAEmitterLayer {
        return self.layer as! CAEmitterLayer
    }

    func makeEmitterCell(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 3
        cell.lifetime = 7.0
        cell.lifetimeRange = 0
        cell.color = color.cgColor
        cell.velocity = 200
        cell.velocityRange = 50
        cell.emissionLongitude = .pi
        cell.emissionRange = .pi / 4
        cell.spin = 2
        cell.spinRange = 3
        cell.scale = 0.75
        cell.scaleRange = 0.5
        cell.scaleSpeed = -0.05
        cell.contents = particleImage?.cgImage
        return cell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emitterLayer.masksToBounds = true
        emitterLayer.emitterShape = .line
        emitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: 0)
        emitterLayer.emitterSize = CGSize(width: bounds.size.width, height: 1)
        
        let purple = makeEmitterCell(color: UIColor(named: "color_1") ?? UIColor.purple)
        let blue = makeEmitterCell(color: UIColor(named: "color_2") ?? UIColor.blue)
        let green = makeEmitterCell(color: UIColor(named: "color_3") ?? UIColor.green)
        let magenta = makeEmitterCell(color: UIColor(named: "color_4") ?? UIColor.magenta)
        let yellow = makeEmitterCell(color: UIColor(named: "color_5") ?? UIColor.yellow)
        emitterLayer.emitterCells = [purple, blue, green, magenta, yellow]
    }
}

struct ConfettiView: UIViewRepresentable {
    
    var confettiParticleView: ConfettiParticleView?
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> ConfettiParticleView {
        ConfettiParticleView()
    }
    
    func updateUIView(_ uiView: ConfettiParticleView, context: UIViewRepresentableContext<Self>) {

    }
}


public struct ConfettiToast: View {
    
    var title: String
    var subtitle: String? = nil
    
    private let animation = Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)
    private let minScale: CGFloat = 0.8
    private let maxScale: CGFloat = 1.2
    @State var enableScaleAnimation = false
    
    public var body: some View {
        ZStack {
            ConfettiView()
            ZStack {
                VisualEffectView(effect: UIBlurEffect(style: .light))
                VStack {
                    Spacer()
                    Text(title)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(Color.App.Home.title)
                    Spacer()
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(Color.App.Home.title)
                        Spacer()
                    }
                }
            }
            .frame(width: 200, height: 200, alignment: .center)
            .cornerRadius(15)
            .scaleEffect(enableScaleAnimation ? maxScale : minScale)
            .onAppear {
                withAnimation(self.animation, {
                    self.enableScaleAnimation.toggle()
                })
            }
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }
}
