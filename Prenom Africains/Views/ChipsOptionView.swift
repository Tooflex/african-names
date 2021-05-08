//
//  ChipsOptionView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 08/05/2021.
//

import SwiftUI

struct ChipsDataModel: Identifiable {
    let id = UUID()
    @State var isSelected: Bool
    let systemImage: String
    let titleKey: LocalizedStringKey
}

class ChipsViewModel: ObservableObject {
    @Published var dataObject: [ChipsDataModel] = [ChipsDataModel.init(isSelected: false, systemImage: "pencil.circle", titleKey: "Pencil Circle")]
    
    func addChip() {
        dataObject.append(ChipsDataModel.init(isSelected: false, systemImage: "pencil.circle", titleKey: "Pencil"))
    }
    
    func initChips(optionList:[ChipsDataModel]) {
        dataObject = optionList
    }
    
    func removeLast() {
        guard dataObject.count != 0 else {
            return
        }
        dataObject.removeLast()
    }
}

struct ChipsOptionView: View {
    @StateObject var viewModel = ChipsViewModel()
    @State var title: String
    var body: some View {
        VStack {
            ScrollView {
                ChipsContent(viewModel: viewModel, title: title)
            }
            Spacer()
        }
    }
}

struct ChipsContent: View {
    @ObservedObject var viewModel = ChipsViewModel()
    var title: String
    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return GeometryReader { geo in
            Text(title)
                .font(.title2)
                .bold()
            ZStack(alignment: .topLeading, content: {
                ForEach(viewModel.dataObject) { chipsData in
                    Chips(systemImage: chipsData.systemImage,
                          titleKey: chipsData.titleKey,
                          isSelected: chipsData.isSelected)
                        .padding(.all, 5)
                        .alignmentGuide(.leading) { dimension in
                            if (abs(width - dimension.width) > geo.size.width) {
                                width = 0
                                height -= dimension.height
                            }
                            
                            let result = width
                            if chipsData.id == viewModel.dataObject.last!.id {
                                width = 0
                            } else {
                                width -= dimension.width
                            }
                            return result
                        }
                        .alignmentGuide(.top) { dimension in
                            let result = height
                            if chipsData.id == viewModel.dataObject.last!.id {
                                height = 0
                            }
                            return result
                        }
                }
            }).padding(.vertical, 30)
        }.padding(.all, 10)
    }
}


struct Chips: View {
    let systemImage: String
    let titleKey: LocalizedStringKey
    @State var isSelected: Bool
    var body: some View {
        HStack {
            Image.init(systemName: systemImage).font(.title3)
            Text(titleKey).font(.title3).lineLimit(1)
        }.padding(.all, 10)
        .foregroundColor(isSelected ? .white : .blue)
        .background(isSelected ? Color.blue : Color.white)
        .cornerRadius(40)
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color.blue, lineWidth: 1.5)
            
        ).onTapGesture {
            isSelected.toggle()
        }
    }
}

struct ChipsOptionView_Previews: PreviewProvider {
    static var previews: some View {
        ChipsOptionView( title: "Test")
    }
}
