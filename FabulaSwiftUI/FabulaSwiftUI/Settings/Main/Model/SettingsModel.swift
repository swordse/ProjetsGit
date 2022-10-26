//
//  SettingsModel.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 06/07/2022.
//

import Foundation
import SwiftUI

struct SettingTitleText {
    let title: String
    let text: String
    
//    static let confidentiality = [SettingTitleText(title: "Identité du responsable du traitement", text: "Raphaël Goupille, 25 rue Campagne Première, 75014 Paris"), SettingTitleText(title: "Données personelles", text: "Les données à caractère personnel sont des renseignements relatifs à la situation personnelle et matérielle d’une personne physique identifiée ou identifiable. C’est le cas par exemple des renseignements tels que le prénom, le nom, le numéro de téléphone et l’adresse électronique."), SettingTitleText(title: "Données collectées", text: "Pour le fonctionnement du compte utilisateur: le pseudo, l'adresse électronique, le mot de passe, la date d'inscription.\nPour le fonctionnement de la Plateforme: les anecdotes et les commentaires.\nPour la sécurité de la Plateforme: l'adresse IP."), SettingTitleText(title: "Finalités d'utilisation des données", text: "Les données collectées sont utilisées:\n\n- Pour la connexion au compte de l'utilisateur.\n\n- Pour la gestion des commentaires, pour la gestion des anecdotes/citations/mots du jour soumis par les Utilisateurs.\n\n- Pour le suivi de la fréquentation de la Plateforme"), SettingTitleText(title: "Google FireBase/FireAuth", text: "Pour le stockage des données (anecdotes, citations, mots du jour, commentaires) et la création des comptes des Utilisateurs, la Plateforme utilise les services FireBase et FireAuth proposés par la société  Google Inc., 1600 Amphitheatre Parkway, Mountain View, CA 94043, États-Unis.\n\nFireBase utilise des technologies de suivi qui permettent de collecter et d’analyser l’interaction entre l’Utilisateur de la Plateforme, par exemple, la fréquence et la durée des sessions.\nLa collecte et l’analyse des interactions entre l’utilisateur et la Plateforme ont pour but d’améliorer et de perfectionner la Plateforme grâce aux informations recueillies afin d’obtenir une application plus ergonomique et agréable. Elles permettent également d'identifier l'Utilisateur pour lui permettre de poster des commentaires ou de soumettre des propositions d'anecdotes, de citations ou de mots du jour."), SettingTitleText(title: "Vos droits", text: "S’agissant de vos données à caractère personnel, vous disposez des droits suivants :\na)  Le droit d’être informé, notamment sur les données que nous traitons vous concernant, sur les finalités du traitement, sur les catégories des données à caractère personnel concernées, sur les catégories des destinataires et sur la durée de sauvegarde prévue (art. 15 du RGPD).\nb) Le droit d’exiger du responsable la rectification de données à caractère personnel inexactes ou incomplètes (art. 16, 17 du RGPD).\nc)  Le droit à l’effacement ou à la limitation du traitement des données sauvegardées sur votre personne (art. 17, 18 du RGPD).\nd) Le droit à la portabilité des données (art. 20 du RGPD).\ne) Le droit de révoquer à tout moment votre consentement sans en indiquer la raison (art. 7 al. 3 du RGPD).\nf)  Le droit au recours auprès de l’autorité de surveillance compétente (art. 77 du RGPD).")]
    
//    static let termsAndConditions = [SettingTitleText(title: "Conditions d'accès", text: "L'application Fabula, ci-après\"la Plateforme\" est accessible depuis un smartphone.\nLa Plateforme est accessible gratuitement, sans condition d’abonnement, à tout Utilisateur ayant un accès internet. L'Utilisateur est responsable financièrement des frais permettant l’utilisation de la Plateforme (matériel informatique, logiciel, accès à internet, …)  \nL’accès à la Plateforme est valable pour une durée illimitée, sans préjudice pour notre équipe de la fermer unilatéralement, à tout moment et sans préavis, ni motif ou indemnité."), SettingTitleText(title: "Conditions d'utilisation", text: "La Plateforme est destinée uniquement à une utilisation personnelle de ces services, et exclut, toute utilisation professionnelle à but lucrative de ses services sauf, autorisation préalable expresse et écrite. \nL’Utilisateur, lors de sa navigation sur la Plateforme, s’engage à respecter l’ensemble de la législation applicable et des présentes conditions générales d’utilisation.\nL’Utilisateur s’engage à utiliser la Plateforme et ses services dans un but licite et privé. Tout mauvais usage, tentative de commission d’un acte frauduleux, des applications et/ou site et/ou services de la Plateforme est interdit."), SettingTitleText(title: "Propriété intellectuelle", text: "L'Editeur de Fabula déclare être titulaire de tous les droits de propriété intellectuelle relatif à la Plateforme.\nL’accès et l’utilisation de la Plateforme ne transfère aucun droit de propriété à l’Utilisateur.\nAinsi, conformément aux dispositions de l’article L122-4 du Code de la propriété intellectuelle, tous les éléments accessibles sur la Plateforme (texte, logo, plan, marque, icône, vidéo, sons, …) et tous les composants ne peuvent faire l’objet d’une quelconque représentation ou reproduction, intégrale ou partielle, sur quelque support que ce soit, sans l’autorisation expresse et préalable de l'Editeur.\nL'Editeur concède à l’Utilisateur de la Plateforme, le droit d’utiliser le site pour des besoins privés en excluant toute utilisation lucrative et à l’exclusion de tout autre droit. Pour toute utilisation professionnelle, l’Utilisateur devra obtenir l’autorisation préalable, expresse et écrite du propriétaire."), SettingTitleText(title: "Liens hypertextes", text: "La Plateforme présente des liens hypertextes pur les sources.\nL’Utilisateur est informé qu’en cliquant sur ces liens, il sortira de la Plateforme. L'Editeur invite donc l’Utilisateur à prendre connaissance des conditions générales d'utilisation de ces liens.\nL'Editeur n’ayant pas de contrôle sur le contenu de ces sites, il ne pourra en aucun cas être tenue responsable de leur contenu. De la même manière, l'Editeur ne pourra pas être tenu pour responsable des dommages de quelque nature découlant de la consultation de ces sites.\nEnfin, l'Editeur, dans la limite autorisée par la loi, ne pourra pas être tenue responsable dans le cas où le contenu desdits autres sites contreviendrait aux dispositions légales et réglementaires en vigueur."), SettingTitleText(title: "Exactitude des informations", text: "L'Editeur s’efforce de mettre en ligne des informations précises, exactes et à jour. Néanmoins il ne peut garantir une fiabilité totale.\nL’Utilisateur est invité à signaler toute information qui lui paraîtrait inexacte et, le cas échéant, à proposer toute amélioration qui lui paraîtrait utile en adressant un email à fabula@gmail.com")]
    
//    static let submitRulesText = [SettingTitleText(title: "Connexion:", text: "Pour soumettre une anecdote, une citation ou un mot du jour (ci-après une \"Contribution\", l'Utilisateur doit créer un compte et se connecter."), SettingTitleText(title: "Source", text: "L’Utilisateur s’engage à mettre en ligne des Contributions au contenu véridique, en faisant apparaitre la source et/ou l’auteur dans le cas d’un emprunt à une œuvre préexistante."), SettingTitleText(title: "Vérification et modification:", text: "La Contribution proposée par l'Utilisateur sera revue par nos équipes qui pourront en modifier la formulation ou la syntaxe."), SettingTitleText(title: "Non publication:", text: "Les informations redondantes, celles qui ne pourraient pas être vérifiées ou celles qui présentent peu d'intérêts ne seront pas publiées."), SettingTitleText(title: "Droits:", text: "L’Utilisateur garantit être le seul et unique titulaire des droits de propriété sur ces Contributions. L’Utilisateur garantit notamment qu’aucun litige ou procès n’est en cours ou sur le point d’être intenté quant aux Contributions mettent en cause son droit d’auteur.\nLa publication de ces Contributions n’entraine pas de transfert de droit de propriété. Toutefois, en publiant une contribution sur la Plateforme, l’Utilisateur accepte de céder à RSS le droit non exclusif de représenter, reproduire, adapter, modifier, diffuser et distribuer sa Contribution, directement ou par un tiers autorisé, dans le monde entier, sur tout support (numérique ou physique) pour la durée de la propriété intellectuelle")]
    
//    static let commentRules = [SettingTitleText(title: "Modération:", text: "Les commentaires sont soumis à une modération a posteriori. Nous nous réservons le droit de supprimer tout commentaire qui ne respecterait pas les présentes conditions."), SettingTitleText(title: "Règles générales", text: "Les commentaires doivent présenter une valeur ajoutée pour les lecteurs, par exemple, lorsqu'ils précisent une anecdote ou l'enrichissent d'informations.\nLes commentaires ne sont pas un chat ou un lieu de discussion entre les Utilisateurs.\nLes commentaires qui entendent ajouter des informations doivent être accompagnés de leurs sources.\nLes commentaires humoristiques sont autorisés dans la mesure du raisonnable et doivent être en lien avec l'anecdote.\n Tout contenu mis en ligne par l’Utilisateur, et le cas échant, conséquence en découlant sont de sa seule responsabilité. En outre, les contributions pouvant être vues de tout Utilisateur, l’Utilisateur s’engage à ne pas mettre en ligne de contenus pouvant porter atteinte aux intérêts des tierces personnes. Tout recours engagé par un tiers contre la Plateforme sera pris en charge par l’Utilisateur."), SettingTitleText(title: "Suppression", text: "Seront supprimés tous les commentaires injurieux, racistes, dénigrants, mensongers et, de façon générale, tous les commentaires contraires aux dispositions légales.")]
}

struct SettingsSection {
    var sectionTitle: String
    var settingsOptions: [SettingsOption]
    
    static var settings: [SettingsSection] = [
    SettingsSection(sectionTitle: "Gérez votre compte", settingsOptions: [
        SettingsOption(title: "Modifiez votre profil", image: Image(systemName: "camera") , iconBackgroundColor: .green, destination: .toChangePhoto),
        SettingsOption(title: "Supprimez votre compte", image: Image(systemName: "person"), iconBackgroundColor: .red, destination: .toDeleteAccount)
        ]),
    SettingsSection(sectionTitle: "Notez Fabula", settingsOptions: [
        SettingsOption(title: "Vous aimez Fabula, notez la.", image: Image(systemName: "star") , iconBackgroundColor: Color.purple, destination: .toReview)
        ]),
    SettingsSection(sectionTitle: "Favoris", settingsOptions: [
        SettingsOption(title: "Anecdote", image: Image("book"), iconBackgroundColor: .pink, destination: .toAnecdoteFav),
        SettingsOption(title: "Citations", image: Image("quote"), iconBackgroundColor: .purple, destination: .toCitationFav),
        SettingsOption(title: "Mot du jour", image: Image("bubble"), iconBackgroundColor: .blue, destination: .toMotduJourFav)
        ]),
    SettingsSection(sectionTitle: "Scores", settingsOptions: [
        SettingsOption(title: "Vos scores aux quizz", image: Image("game"), iconBackgroundColor: Color("orange"), destination: .toScores)]),
    SettingsSection(sectionTitle: "Juridique", settingsOptions: [SettingsOption(title: "Mentions légales/ GCU", image: Image(systemName: "doc.plaintext"), iconBackgroundColor: .gray, destination: .toLegal)]),
//    SettingsSection(sectionTitle: "Mentions légales", settingsOptions: [SettingsOption(title: "Règles soumission", image: Image(systemName: "info.circle"), iconBackgroundColor: .yellow, destination: .toSubmitRules), SettingsOption(title: "Commentaires", image: Image(systemName: "bubble.right"), iconBackgroundColor: Color("pink"), destination: .toCommentRules), SettingsOption(title: "CGU", image: Image(systemName: "doc.plaintext"), iconBackgroundColor: .gray, destination: .toCGU), SettingsOption(title: "Données personnelles", image: Image(systemName: "person"), iconBackgroundColor: Color.black, destination: .toRGPD)]),
    SettingsSection(sectionTitle: "Contact", settingsOptions: [SettingsOption(title: "Email", image: Image(systemName: "mail"), iconBackgroundColor: Color("nature"), destination: .toEmail)])
    
    ]
}

struct SettingsOption {
    var title: String
    var image: Image?
    var iconBackgroundColor: Color
    var destination: Destination
}

enum Destination {
    case toDeleteAccount
    case toChangePhoto
    case toReview
    case toAnecdoteFav
    case toCitationFav
    case toMotduJourFav
    case toScores
    case toLegal
    case toEmail
//    case toSubmitRules
//    case toCommentRules
//    case toCGU
//    case toRGPD
}
