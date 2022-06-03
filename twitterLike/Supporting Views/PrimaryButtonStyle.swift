//
//  PrimaryButtonStyle.swift
//  twitterLike
//
//  Created by Антон Голубейков on 02.06.2022.
//

import SwiftUI
//MARK: - We can declare our own button style with a structure that conforms to the ButtonStyle protocol. Then, we style the button using the makeBody(configuration:) method. This is used for the “Sign In” button. And can be reused then.
struct PrimaryButtonStyle: ButtonStyle {
    //Environment that monitors if view is not disabled (we disable it by "isWorking property)
    @Environment(\.isEnabled) private var isEnabled
 
    func makeBody(configuration: Configuration) -> some View {
        Group {
            if isEnabled {
                configuration.label
            } else {
                ProgressView()
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(Color.accentColor)
        .cornerRadius(10)
        .animation(.default, value: isEnabled)
    }
}
//This extension applies to the ButtonStyle where Self is the PrimaryButtonStyle, allowing us to define our button style as a static property of the ButtonStyle protocol. Like this: .buttonStyle(.primary)
extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}
