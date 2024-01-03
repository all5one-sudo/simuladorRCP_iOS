//
//  ContentView.swift
//  simuladorRCP
//
//  Created by Federico Villar on 03/01/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            InicioView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Inicio")
                }
            EntrenamientoView()
                .tabItem {
                    Image(systemName: "sportscourt.fill")
                    Text("Entrenamiento")
                }
            EvaluacionView()
                .tabItem {
                    Image(systemName: "doc.text.fill")
                    Text("Evaluación")
                }
            AcercaDeView()
                .tabItem {
                    Image(systemName: "info.circle.fill")
                    Text("Acerca de")
                }
        }
    }
}

struct InicioView: View {
    var body: some View {
        Text("Esta es la página de inicio")
    }
}

struct EntrenamientoView: View {
    var body: some View {
        Text("Esta es la página de entrenamiento")
    }
}

struct EvaluacionView: View {
    var body: some View {
        Text("Esta es la página de evaluación")
    }
}

struct AcercaDeView: View {
    var body: some View {
        Text("Esta es la página acerca de")
    }
}

#Preview {
    ContentView()
}
