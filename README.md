# Open42 [![Stories in Ready](https://badge.waffle.io/emericspiroux/Open42.png?label=ready&title=Ready)](https://waffle.io/emericspiroux/Open42) [![Status Api 42](http://statusbadge.spiroux-web.fr/api42)](http://api.intra.42.fr/apidoc/2.0.html)

Application IOS de l'intranet de l'École 42, ouverte à tous les élèves souhaitant contribuer. Application basée sur l'API 42.

## Installation
1. Création du token d'application :
  - Rendez-vous dans les settings de votre profil sur l'intra de 42, onglet application et ajoutez une nouvelle application ([ou plus simplement ici](https://profile.intra.42.fr/oauth/applications/new)). Placez dans le champ Redirect uri: "correct42://oauth-callback/intra". Vous recevrez deux tokens qui correspondront à votre clientId (UID) ainsi que votre secretKey (SECRET). 
2. Ouvrir Open42.xcworkspace avec Xcode pour avoir accès aux [pods](https://cocoapods.org), plutôt que le Open42.xcodeproj qui vous demandera d'inclure les frameworks (cf Tools et documentation).
3. Inserez dans la class /correct42/Library/Api/[DuoQuadraLoader](https://github.com/emericspiroux/Open42/blob/master/correct42/Library/Api/Loaders/DuoQuadraLoader.swift) votre clientId et secretKey dans l'init d'oAuth2.
4. Trouvez un ticket ou crée en un sur notre [waffle](https://waffle.io/emericspiroux/Open42).
5. Créez une branche selon les rêgles du suivi de projet.
6. Coder (ouf ce n'est pas trop tôt).
6. Crée une pull-request.

## Code de conduite des contributions
- La position de vos fichiers devra correspondre au pattern design MVC dans les groupes d'Xcode et dans les répertoires. L'organisation sera surement renouvelée au fur et à mesure des contributions.
- Les commentaires explicitent respectant les [headers doc d'Xcode](https://developer.apple.com/library/mac/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html#//apple_ref/doc/uid/TP40016497) sont <b>obligatoires</b>. La raison est l'utilisation de [jazzy](https://github.com/realm/jazzy) qui parsera vos commentaires pour en faire une documentation consultable sur notre [site](http://docopen42.spiroux-web.fr).
- Nous ne devrions pas avoir à le préciser mais soyez au fait que tout language ou image relevant de la sexualité, les attaques personnelles, les trolls, les insultes, les harcelements, publier d'autres informations personnelles que son adresse email ainsi que son login 42 sans la permission explicite, toutes choses relevant du non-professionnalisme ainsi que du manque d'éthique, exclurons la contributions et entraînera le bannissement illimité de l'utilisateur. Cependant le reste est encouragé ! :)

## Suivi de projet
Nous suivons le projet à l'aide de [waffle.io](https://waffle.io/emericspiroux/Open42), si vous voulez ajouter des issues ou si vous cherchez des idées pour contribuer. Pour résoudre un ticket il suffit de créer une branche sur l'exemple : myTicket-#id où id est l'id du ticket. Après votre modification, ajoutez une pull request sur le gihub du projet.

## Tools et documentation

- [API 42 v2](https://api.intra.42.fr/apidoc/2.0.html)
- [Alamofire v3.4.0](https://github.com/Alamofire/Alamofire)
- [OAuthSwift v0.5.0](https://github.com/OAuthSwift/OAuthSwift) 
- [Jazzy v0.6.0](https://github.com/realm/jazzy)
- [CocoaPods v1.0.0.beta.8](https://guides.cocoapods.org/)
- [SwiftyJSON v2.3.2](https://github.com/SwiftyJSON/SwiftyJSON.git)
- [Crashlytics v3.7.1](https://try.crashlytics.com/)

L'ajout de pods est fortement déconseillé sans demande faite au préalable via l'issue correspondante (cf. Suivis de projet).

### Autre
Nous nous excusons du caractère quelque peu trivial de ce Readme, il a été écrit le plus simplement et le plus détaillé possible pour que tout le monde puisse contribuer au projet. Si vous avez des conseils pour améliorer notre organisation n'hésitez pas à nous écrire !
