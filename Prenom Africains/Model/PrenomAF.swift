//
//  PrenonAF.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 05/04/2021.
//

import Foundation

struct PrenomAF: Identifiable, Codable  {
    
    var firstname: String?
    var gender: Gender
    var id: Float?
    var isFavorite: Bool?
    var meaning: String?
    var origins: String?
    var soundURL: String?
    
    init() {
        self.firstname = "Firstname Test"
        self.meaning = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi quam arcu, fermentum sed blandit ac, ultrices et turpis. Aliquam eu est non massa aliquet efficitur quis id mauris. In id tincidunt mauris, sit amet imperdiet sem. Vivamus blandit at odio sed varius. Mauris vel tortor sed felis aliquet tristique eget nec massa. Maecenas rutrum mi scelerisque metus pellentesque mattis. Pellentesque vulputate fermentum nulla sed feugiat. Donec eget quam gravida quam sodales egestas. Suspendisse quis laoreet ipsum, eu aliquam ligula. Aenean a metus semper, porttitor quam et, imperdiet risus. Cras dictum suscipit turpis, posuere posuere purus semper ut. Duis convallis, quam vitae tristique condimentum, sapien sapien luctus augue, ut pharetra dui nisl aliquam ipsum. Nam at accumsan quam. Aliquam gravida quam congue, lobortis ante in, faucibus diam. Suspendisse id fringilla nulla. Mauris vehicula nulla sed est viverra, ac semper justo fringilla. In aliquam id ante nec sagittis. Praesent ligula nunc, vulputate in orci id, iaculis semper lacus. Pellentesque semper nisi at ex facilisis, non vulputate sem blandit. Vestibulum iaculis cursus lorem, molestie venenatis nibh fringilla eu.In hac habitasse platea dictumst. Aliquam vel auctor sem, vulputate elementum enim. Pellentesque porttitor turpis velit, sed placerat lacus pellentesque non. Vestibulum at consequat lorem. Aliquam aliquet mi volutpat ante aliquam vehicula. Nullam ornare, libero sed mattis iaculis, diam sem condimentum orci, et tempor arcu odio nec nulla. Suspendisse diam augue, accumsan vitae ligula ut, efficitur finibus arcu. Cras mattis lectus tellus. Vivamus urna ligula, luctus egestas sagittis at, sodales id velit. Suspendisse pulvinar tempus turpis semper molestie. Nam sapien erat, posuere efficitur interdum at, varius at nunc. Nulla nibh ex, volutpat a magna ut, congue hendrerit enim. Sed ut lectus ut sem ornare volutpat. Suspendisse feugiat nisl et lacinia suscipit. Donec vel rhoncus neque. Sed non posuere leo, ut porta est.Nunc fringilla ipsum sit amet sapien efficitur facilisis. Suspendisse metus purus, sodales nec felis ut, consectetur varius turpis. Donec hendrerit libero felis, non hendrerit erat tincidunt sit amet. Etiam fermentum augue ac erat mollis, vel rhoncus quam interdum. Duis finibus maximus urna eget convallis. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In sodales vulputate augue non scelerisque. Morbi eget mi nibh. Integer commodo convallis sapien in feugiat. Aenean lectus augue, tempus vel porttitor eget, accumsan nec nulla.Morbi condimentum, sapien vitae tincidunt lacinia, arcu leo eleifend nibh, ac aliquam velit felis non justo. Vivamus efficitur eget risus scelerisque tempor. Nunc quis velit dapibus, volutpat ipsum ut, tempus nisi. Quisque ut arcu quis diam porta facilisis eget at nisl. Quisque vitae justo nulla. Donec eget placerat orci, at volutpat tellus. Duis et pharetra arcu, in suscipit orci. Cras vel nisl dui. Nunc pretium enim leo, vitae tempus nunc elementum eget. Maecenas in dui vitae ex molestie condimentum."
        self.origins = "manjack, bantoue, arab, fon, yoruba, test"
        self.soundURL = ""
        self.gender = Gender.mixed
        self.isFavorite = false
    }
    
    enum CodingKeys: String, CodingKey {
        case id, firstname, gender, meaning, origins, soundURL
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
                
        firstname = try container.decodeIfPresent(String.self, forKey: .firstname)
                
        meaning = try container.decodeIfPresent(String.self, forKey: .meaning)
        
        origins = try container.decodeIfPresent(String.self, forKey: .origins)
        
        soundURL = try container.decodeIfPresent(String.self, forKey: .soundURL)
        
        let genderString = try container.decode(String.self, forKey: .gender)
        gender = Gender(rawValue: genderString.lowercased()) ?? Gender.undefined
    } 
}
