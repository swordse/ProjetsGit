//
//  Anecdote.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 14/01/2023.
//

import Foundation
import Firebase

struct Anecdote: Identifiable, Hashable, Codable, Equatable {
    
    var id: String
    var category: Category
    var title: String
    var text: String
    var source: String?
    var index: Int
    
    // categories of the anecdotes
    enum Category: String, Codable, CaseIterable {
        case nouveautes = "Nouveautés"
        case favoris = "Favoris"
        case arts = "Art"
        case divertissement = "Divertissement"
        case geographie = "Géographie"
        case histoire = "Histoire"
        case inclassable = "Inclassable"
        case insolite = "Insolite"
        case litterature = "Littérature"
        case nature = "Nature"
        case science = "Science"
        case societe = "Société"
        case sport = "Sport"
        case viePratique = "Vie pratique"
    }
    
    static let fakeDatas = [Anecdote(id: "1", category: Category.science, title: "Un peu de politesse", text: "Un restaurant niçois vous fera payer plus cher votre café, si vous êtes malpoli. C'est en 2013, que le propriétaire du restaurant « la petite Syrah » a pris cette initiative. La commande formulée en disant simplement « un café » sera facturé 7 euros, dire « un café s'il vous plaît » vous coûtera 4,25 euros et enfin dire « bonjour, un café, s'il vous plaît » fera baisser l’addition à 1,40 €.\nD’autres restaurants avaient pris des initiatives du même genre. A Singapour, le restaurant « Angie's Oyster Bar & Grill » prévoyait une facturation supplémentaire de 7 euros si vos enfants étaient bruyants.\nEtre poli et bien élevé est payant.Un restaurant niçois vous fera payer plus cher votre café, si vous êtes malpoli. C'est en 2013, que le propriétaire du restaurant « la petite Syrah » a pris cette initiative. La commande formulée en disant simplement « un café » sera facturé 7 euros, dire « un café s'il vous plaît » vous coûtera 4,25 euros et enfin dire « bonjour, un café, s'il vous plaît » fera baisser l’addition à 1,40 €.\nD’autres restaurants avaient pris des initiatives du même genre. A Singapour, le restaurant « Angie's Oyster Bar & Grill » prévoyait une facturation supplémentaire de 7 euros si vos enfants étaient bruyants.\nEtre poli et bien élevé est payant.Un restaurant niçois vous fera payer plus cher votre café, si vous êtes malpoli. C'est en 2013, que le propriétaire du restaurant « la petite Syrah » a pris cette initiative. La commande formulée en disant simplement « un café » sera facturé 7 euros, dire « un café s'il vous plaît » vous coûtera 4,25 euros et enfin dire « bonjour, un café, s'il vous plaît » fera baisser l’addition à 1,40 €.\nD’autres restaurants avaient pris des initiatives du même genre. A Singapour, le restaurant « Angie's Oyster Bar & Grill » prévoyait une facturation supplémentaire de 7 euros si vos enfants étaient bruyants.\nEtre poli et bien élevé est payant.", source: "https://www.nicematin.com/faits-societe/dans-un-resto-de-nice-le-cafe-plus-cher-pour-les-clients-malpolis-357547", index: 0), Anecdote(id: "2", category: Category.viePratique, title: "Couleur marketing", text: "Pourquoi le papier toilette est souvent rose ? Il faut tout d’abord savoir qu’il s’agit d’une invention relativement récente. Crée en 1850 en Angleterre, il a été fabriqué de façon industrielle aux Etats-Unis à partir de 1857. Au XIXe siècle, il était réservé à une élite. En France, pays qui était plutôt adepte des bidets, le papier toilette voit son essor dans les années 1960.\n\nMais pourquoi rose ?\nLes premiers papiers étaient gris avant de devenir rose  dans les années 1960 pour des raisons marketings. Le rose serait la couleur se rapprochant le plus de la couleur de la peau et serait associé à la douceur, douceur qui semble indispensable pour l’usage qui en est fait.\n\nLe marketing est en train d’évoluer, le papier toilette rose laissant la place au blanc, couleur associée à la propreté et la pureté. Bref, tout n’est que marketing.", source: "https://www.bernard.fr/blog/pourquoi-le-papier-toilette-est-rose_cms_000298.html", index: 1), Anecdote(id: "3", category: Category.arts, title: "Troisième anecdote", text: "Au XIXe siècle, il était réservé à une élite. En France, pays qui était plutôt adepte des bidets, le papier toilette voit son essor dans les années 1960.\n\nMais pourquoi rose ?\nLes premiers papiers étaient gris avant de devenir rose  dans les années 1960 pour des raisons marketings. Le rose serait la couleur se rapprochant le plus de la couleur de la peau et serait associé à la douceur, douceur qui semble indispensable pour l’usage qui en est fait.\n\nLe marketing est en train d’évoluer, le papier toilette rose laissant la place au blanc, couleur associée à la propreté et la pureté. Bref, tout n’est que marketing.", source: "https://www.bernard.fr/blog/pourquoi-le-papier-toilette-est-rose_cms_000298.html", index: 2), Anecdote(id: "4", category: Category.divertissement, title: "Quatrième anecdote", text: "Mais pourquoi rose ?\nLes premiers papiers étaient gris avant de devenir rose  dans les années 1960 pour des raisons marketings. Le rose serait la couleur se rapprochant le plus de la couleur de la peau et serait associé à la douceur, douceur qui semble indispensable pour l’usage qui en est fait.\n\nLe marketing est en train d’évoluer, le papier toilette rose laissant la place au blanc, couleur associée à la propreté et la pureté. Bref, tout n’est que marketing.", source: "https://www.bernard.fr/blog/pourquoi-le-papier-toilette-est-rose_cms_000298.html", index: 3), Anecdote(id: "5", category: Category.histoire, title: "Cinquième anecdote", text: "Le marketing est en train d’évoluer, le papier toilette rose laissant la place au blanc, couleur associée à la propreté et la pureté. Bref, tout n’est que marketing.\n\nMais pourquoi rose ?\nLes premiers papiers étaient gris avant de devenir rose  dans les années 1960 pour des raisons marketings. Le rose serait la couleur se rapprochant le plus de la couleur de la peau et serait associé à la douceur, douceur qui semble indispensable pour l’usage qui en est fait.\n\nLe marketing est en train d’évoluer, le papier toilette rose laissant la place au blanc, couleur associée à la propreté et la pureté. Bref, tout n’est que marketing.", source: "https://www.bernard.fr/blog/pourquoi-le-papier-toilette-est-rose_cms_000298.html", index: 4), Anecdote(id: "6", category: Category.societe, title: "Sixième anecdote", text: "Une nouvelle anecdote pour la 6ème anecdote", source: "https://www.bernard.fr/blog/pourquoi-le-papier-toilette-est-rose_cms_000298.html", index: 5), Anecdote(id: "7", category: Category.geographie, title: "Septième anecdote", text: "Les premiers papiers étaient gris avant de devenir rose  dans les années 1960 pour des raisons marketings. Le rose serait la couleur se rapprochant le plus de la couleur de la peau et serait associé à la douceur, douceur qui semble indispensable pour l’usage qui en est fait. marketing est en train d’évoluer, le papier toilette rose laissant la place au blanc, couleur associée à la propreté et la pureté. Bref, tout n’est que marketing.\n\nMais pourquoi rose ?\nLes premiers papiers étaient gris avant de devenir rose  dans les années 1960 pour des raisons marketings. Le rose serait la couleur se rapprochant le plus de la couleur de la peau et serait associé à la douceur, douceur qui semble indispensable pour l’usage qui en est fait.\n\nLe marketing est en train d’évoluer, le papier toilette rose laissant la place au blanc, couleur associée à la propreté et la pureté. Bref, tout n’est que marketing.", source: "https://www.bernard.fr/blog/pourquoi-le-papier-toilette-est-rose_cms_000298.html", index: 6), Anecdote(id: "8", category: Category.nature, title: "Huitième anecdote", text: "A Singapour, le restaurant « Angie's Oyster Bar & Grill » prévoyait une facturation supplémentaire de 7 euros si vos enfants étaient bruyants.\nEtre poli et bien élevé est payant.Un restaurant niçois vous fera payer plus cher votre café, si vous êtes malpoli. C'est en 2013, que le propriétaire du restaurant « la petite Syrah » a pris cette initiative. La commande formulée en disant simplement « un café » sera facturé 7 euros, dire « un café s'il vous plaît » vous coûtera 4,25 euros et enfin dire « bonjour, un café, s'il vous plaît » fera baisser l’addition à 1,40 €.\nD’autres restaurants avaient pris des initiatives du même genre. A Singapour, le restaurant « Angie's Oyster Bar & Grill » prévoyait une facturation supplémentaire de 7 euros si vos enfants étaient bruyants.\nEtre poli et bien élevé est payant.", source: "https://www.bernard.fr/blog/pourquoi-le-papier-toilette-est-rose_cms_000298.html", index: 7)]

}



    
    
    

