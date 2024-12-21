//
//  ChipsOptionView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 08/05/2021.
//

import SwiftUI

struct ChipsOptionView: View {

    private var title: String
	private var data: [ChipsDataModel]
	private var action: (_ chipView: ChipsView) -> Void

	public init(title: String, data: [ChipsDataModel], action: @escaping (_ chipView: ChipsView) -> Void) {
		self.title = title
		self.data = data
		self.action = action
	}

    var body: some View {
        VStack {
			ChipsContent(title: title, data: data, action: action)
            Spacer()
        }
    }
}

struct ChipsContent: View {
    @State var title: String
    @State var data: [ChipsDataModel]
	@State var action: (_ chipView: ChipsView) -> Void

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
								action(chipView)
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
            title: "Test",
            data: [
                ChipsDataModel(isSelected: false, titleKey: "Wesh", displayedTitle: "Wesh translated"),
                ChipsDataModel(isSelected: true, titleKey: "Yo", displayedTitle: "Yo translated")
			], action: {_ in })
    }
 }
