//
//  SearchBarView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 08/05/2021.
//

import SwiftUI
import SlideOverCard

struct SearchBarView: View {
    @EnvironmentObject var searchScreenViewModel: SearchScreenViewModel

    @Binding var searchText: String

    @Binding var resultArray: [FirstnameDataModel]
    @State private var isEditing = false
    @State private var showCancelButton: Bool = false
    @Binding var showingSheet: Bool
    @State var isFirstResponder = true

    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 30) {
                Image("feather-search").foregroundColor(.black)
                    // Fallback on earlier versions
                LegacyTextField(text: $searchText, isFirstResponder: $isFirstResponder)
                    .onChange(of: searchText) { newValue in
                        searchScreenViewModel.searchFirstnames(searchString: newValue)
                    }
                    .onAppear(perform: {
                        self.showCancelButton = true
                    })
                    .textFieldStyle(DefaultTextFieldStyle())

                    .frame(maxWidth: .infinity, maxHeight: 30)
                    .id(true)
                 // Force TextField to accept editable
                if showCancelButton {
                    Button("Cancel") {
                        showingSheet = false
                        // UIApplication.shared.endEditing(true)
                        // self.searchText = ""
                        // self.showCancelButton = false
                    }
                    .foregroundColor(Color(.systemBlue))
                }
            }
            .padding()
            .navigationBarHidden(showCancelButton)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            .onReceive(searchScreenViewModel.$searchResults) { firstnames in
                if !firstnames.isEmpty {
                    resultArray = firstnames
                } else {
                    resultArray = []
                }
                if searchText.isEmpty {
                    showCancelButton = false
                    UIApplication.shared.endEditing(true)
                } else {
                    showingSheet = true
                }
            }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(
                      searchText: .constant(""),
                      resultArray: .constant([]),
                      showingSheet: .constant(true))
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.inputView?.window?.windowScene?.keyWindow?
            // .filter {$0.isKeyWindow}
            // .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged {_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
