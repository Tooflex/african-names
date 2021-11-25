//
//  ParamScreen.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 13/11/2021.
//

import SwiftUI

struct ParamScreen: View {

    @Binding var selectedTab: Int
    @State var languageCodeSelection: String = "us"

    var body: some View {
        VStack {
            Spacer()
            Text("Choose your language")
            Picker("Choose your language", selection: $languageCodeSelection) {
                ForEach(CountryLibrary.countries.filter({ country in
                    ["fr", "us", "it", "al"].contains(country.code.lowercased())
                })) { country in
                    HStack {
                        Text(country.code + " - " + country.flagAndName)
                    }
                }
            }.onChange(of: languageCodeSelection) { _ in
            }
            Spacer()
        }
    }

}

// import UIKit
//
// private var kBundleKey: UInt8 = 0
//
// class BundleEx: Bundle {
//
//    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
//        if let bundle = objc_getAssociatedObject(self, &kBundleKey) {
//            return (bundle as? Bundle)?.localizedString(forKey: key, value: value, table: tableName) ?? ""
//        }
//        return super.localizedString(forKey: key, value: value, table: tableName)
//    }
//
// }
//
// extension Bundle {
//
//    static let once: Void = {
//        object_setClass(Bundle.main, type(of: BundleEx()))
//    }()
//
//    class func setLanguage(_ language: String? = "fr") {
//        Bundle.once
//        let isLanguageRTL = Bundle.isLanguageRTL(language)
//        if isLanguageRTL {
//            UIView.appearance().semanticContentAttribute = .forceRightToLeft
//        } else {
//            UIView.appearance().semanticContentAttribute = .forceLeftToRight
//        }
//        UserDefaults.standard.set(isLanguageRTL, forKey: "AppleTextDirection")
//        UserDefaults.standard.set(isLanguageRTL, forKey: "NSForceRightToLeftWritingDirection")
//        UserDefaults.standard.synchronize()
//
//        let value = (language != nil ? Bundle.init(path: (Bundle.main.path(forResource: language, ofType: "lproj")) ?? "" ) : nil)
//        objc_setAssociatedObject(Bundle.main, &kBundleKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//    }
//
//    class func isLanguageRTL(_ languageCode: String?) -> Bool {
//        return (languageCode != nil && Locale.characterDirection(forLanguage: languageCode!) == .rightToLeft)
//    }
//
// }
