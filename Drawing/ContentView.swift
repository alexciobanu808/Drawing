//
//  ContentView.swift
//  Drawing
//
//  Created by Alex Ciobanu on 2/14/22.
//

import SwiftUI

struct Flower: Shape {
    var petalOffset = -20.0
    var petalWidth = 100.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for number in stride(from: 0, to: Double.pi * 2, by: Double.pi / 8) {
            let rotation = CGAffineTransform(rotationAngle: number)
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            
            let originalPetal = Path(ellipseIn: CGRect(x: petalOffset, y: 0, width: petalWidth, height: rect.width / 2))
            let rotatedPetal = originalPetal.applying(position)
            
            path.addPath(rotatedPetal)
        }
        
        return path
    }
}

struct Arrow: Shape {
    let arrowBodyInset = 115.0
    let arrowHeadHeight = 100.0
    let arrowHeadInset = 50.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + arrowHeadInset, y: rect.minY + arrowHeadHeight))
        path.addLine(to: CGPoint(x: rect.minX + arrowBodyInset, y: rect.minY + arrowHeadHeight))
        path.addLine(to: CGPoint(x: rect.minX + arrowBodyInset, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - arrowBodyInset, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - arrowBodyInset, y: rect.minY + arrowHeadHeight))
        path.addLine(to: CGPoint(x: rect.maxX - arrowHeadInset, y: rect.minY + arrowHeadHeight))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}

struct ColorCyclingCirlce: View {
    var amount = 0.0
    var steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: Double(value))
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color(for: value, brightness: 1),
                                color(for: value, brightness: 0.5),
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2
                    )
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ColorCyclingRectangle: View {
    var amount = 0.0
    let steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                    .inset(by: Double(value))
                    .strokeBorder(color(for: value), lineWidth: 1)
            }
        }
    }
    
    func color(for value: Int) -> Color {
        var targetHue = Double(value) / Double(steps) + amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: 1)
    }
}

struct ContentView: View {
    @State private var amount = 0.5
    
    var body: some View {
        VStack {
            ColorCyclingRectangle(amount: amount)
                .frame(width: 300, height: 300)
            
            Slider(value: $amount)
                .padding([.horizontal, .top])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
