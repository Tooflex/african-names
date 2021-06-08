//
//  ChipsOptionView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 08/05/2021.
//

import SwiftUI

struct ChipsOptionView: View {

    @StateObject var searchScreenViewModel: SearchScreenViewModel
    @State var title: String
    @State var data: [ChipsDataModel]
    var body: some View {
        VStack {
            ChipsContent( searchScreenViewModel: searchScreenViewModel, title: title, data: data)
            Spacer()
        }
    }
}

struct ChipsContent: View {
    @ObservedObject var searchScreenViewModel: SearchScreenViewModel
    @State var title: String
    @State var data: [ChipsDataModel]
    fileprivate func filterByChip(isSelected: Bool, chipsData: ChipsDataModel) {

        if isSelected {
            print("selected")
            searchScreenViewModel.addToFilterChainString(newFilter: title, newFilterValue: chipsData.titleKey)
        } else {
            print("unselected")
            searchScreenViewModel.removeFromFilterChainString(
                filterToRemove: title,
                filterValueToRemove: chipsData.titleKey)
        }

        print(searchScreenViewModel.currentFilterChain)
    }

    var body: some View {
        return GeometryReader { _ in
            Text(title)
                .font(.title2)
                .bold()
            ZStack(alignment: .topLeading, content: {
                ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(data) { chipsData in
                        let chipView: ChipsView = ChipsView(chip: chipsData)
                            chipView.onTapGesture {
                                chipsData.isSelected.toggle()

                                filterByChip(isSelected: chipsData.isSelected, chipsData: chipsData)
                            }
                            .padding(.all, 5)

                    }
                }
                }

            }).padding(.vertical, 30)
        }.padding(.all, 10)
    }
}

 struct ChipsOptionView_Previews: PreviewProvider {
    static var previews: some View {
        ChipsOptionView(
            searchScreenViewModel: SearchScreenViewModel(),
            title: "Test",
            data: [
                ChipsDataModel(isSelected: false, titleKey: "Wesh"),
                ChipsDataModel(isSelected: false, titleKey: "Yo")
            ])
    }
 }

// extension ChipsContent {
//
//    typealias CompletionHandler = (_ success: Bool) -> Void
//
//    public func onChipTapped(completionHandler: CompletionHandler) -> some View {
//
//        let flag = true // true if download succeed,false otherwise
//
//        completionHandler(flag)
//        return self
//    }
// }
