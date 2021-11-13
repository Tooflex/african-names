//
//  WaveShape.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 12/11/2021.
//

import SwiftUI

struct Wave: Shape {

    var waveHeight: CGFloat
    var phase: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 800)) // Bottom Left

        for posX in stride(from: 0, through: rect.width, by: 1) {
            let relativeX: CGFloat = posX / 50 // wavelength
            let sine = CGFloat(sin(relativeX + CGFloat(phase.radians)))
            let posY = waveHeight * sine // + rect.midY
            path.addLine(to: CGPoint(x: posX, y: posY))
        }

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY)) // Top Right
        path.addLine(to: CGPoint(x: rect.maxX, y: 800)) // Bottom Right

        return path
    }
}
