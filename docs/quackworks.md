# QuackWorks - MultiConnectOpenSCAD

## Vue d'ensemble
Librairie OpenSCAD paramétrique pour objets fonctionnels montables sur grilles murales (Multiboard, openGrid, GOEWS).
Auteur : Andy Levesque (BlackjackDuck). Licence CC-BY-NC-SA 4.0.
Dépendance : BOSL2.

## Systèmes de connexion supportés

| Type | Grille | Epaisseur dos | Usage |
|------|--------|---------------|-------|
| Multiconnect (v1/v2) | 25mm | 6.5mm | Standard Multiboard |
| Multiconnect openGrid | 28mm | 6.5mm | Grilles openGrid |
| Multipoint | 25mm | 4.8mm | Multiboard (octogonal) |
| GOEWS | 25mm | 7mm | Système cleat angulé |

### Sélection dans le code
```
Connection_Type = "Multiconnect - Multiboard";
// Options: "Multiconnect - Multiboard", "Multiconnect - openGrid",
//          "Multiconnect - Custom Size", "Multipoint", "GOEWS"
```

### Multiconnect v1 vs v2
- **v1** : verrouillage par dimple (petite bosse conique)
- **v2** : verrouillage par snap (découpe triangulaire, meilleure tenue)

## Dimensions clés

### Slots Multiconnect Standard
- Profil receiver : `[[0,0],[10.15,0],[10.15,1.2121],[7.65,3.712],[7.65,4.15],[0,4.15]]`
- Profil connector : `[[0,0],[10,0],[10,1],[7.5,3.5],[7.5,4],[0,4]]`
- Dimple : rayon 1.5mm (v1), snap triangle [-0.4, 0, -8] (v2)
- On-ramp : cylindre h=5, r1=12, r2=10.15

### Profils disponibles
| Profil | Rayon | Usage |
|--------|-------|-------|
| Standard | 10mm | Objets normaux |
| Jr. | 5mm | Charges légères |
| Mini | 3.2mm | Très petits objets |

## Modules principaux

### makebackPlate() - Panneau arrière universel
```openscad
makebackPlate(
    backWidth,              // Largeur (mm)
    backHeight,             // Hauteur (mm)
    distanceBetweenSlots,   // 25 (Multiboard) ou 28 (openGrid)
    backThickness,          // 6.5 (Multiconnect), 4.8 (Multipoint), 7 (GOEWS)
    slotStopFromBack = 13,  // Distance dimple depuis le haut
    edgeRounding = 1        // Rayon arrondi bords
)
```
Variables globales requises : `subtractedSlots`, `slotDepthMicroadjustment`, `Connection_Standard`, `totalHeight`, `multiConnectVersion`, `slotQuickRelease`, `dimpleScale`, `slotTolerance`, `onRampEnabled`, `onRampEveryXSlots`, `onRampHalfOffset`, `distanceBetweenSlots`.

### multiConnectSlotTool(totalHeight) - Outil de slot
Crée un slot individuel avec dimple/snap et on-ramp optionnels.

### Basket() - Bac (MulticonnectBin.scad)
Bac rect_tube BOSL2 avec chanfrein avant et fond. Utilise `diff()` et `attach()`.

## Conventions de positionnement
- Le modèle commence à X=0 et va en positif
- Le dos commence à X=0 et va en négatif
- Centrer l'ensemble sur X en dernier :
```openscad
translate([-totalWidth/2, 0, -baseThickness])
    makebackPlate(...);
```

## Variables globales standard (Slot Customization)
```openscad
multiConnectVersion = "v2";              // "v1" ou "v2"
onRampHalfOffset = true;
customDistanceBetweenSlots = 25;
subtractedSlots = 0;
slotQuickRelease = false;
dimpleScale = 1;                         // [0.5:0.05:1.5]
slotTolerance = 1.00;                    // [0.925:0.005:1.075]
slotDepthMicroadjustment = 0;            // [-0.5:0.05:0.5]
onRampEnabled = true;
On_Ramp_Every_X_Slots = 1;
Multiconnect_Stop_Distance_From_Back = 13;
```

## Structure des répertoires

```
MultiConnectOpenSCAD/
├── Modules/                    # Générateurs de connecteurs (coeur de la lib)
│   ├── multiconnectGenerator.scad    # Générateur principal
│   ├── multiconnectSlotDesignBOSL.scad # Version BOSL2
│   └── multiconnectSlotDesign.scad   # Version simple
├── VerticalMountingSeries/     # Hooks, étagères, bacs muraux
│   ├── MulticonnectBin.scad          # Bac (meilleur exemple pour boîtes)
│   ├── MulticonnectShelf.scad        # Etagère
│   ├── MulticonnectHook.scad         # Crochets
│   ├── VerticalItemHolder.scad       # Porte-objets
│   └── MulticonnectGridfinity.SCAD   # Compatibilité Gridfinity
├── Underware/                  # Gestion de câbles modulaire
├── Deskware/                   # Système bureau modulaire
├── NeoGrid/                    # Organisateur de tiroirs
├── openGrid/                   # Générateur de tuiles openGrid (28mm)
├── Multiconnect Mounts/        # Montages spéciaux
├── ElectricalBoxes/            # Composants utilitaires
└── Misc/                       # Projets divers
```

## Utilisation rapide pour un nouveau projet

1. Inclure BOSL2 : `include <../BOSL2/std.scad>`
2. Définir les variables globales de slot (voir section ci-dessus)
3. Calculer `totalWidth`, `totalHeight`, `distanceBetweenSlots`, `Connection_Standard`
4. Créer votre objet
5. Ajouter le dos :
```openscad
translate([-max(totalWidth, distanceBetweenSlots)/2, 0.01, -baseThickness])
    makebackPlate(
        backWidth = totalWidth,
        backHeight = totalHeight,
        distanceBetweenSlots = 25,
        backThickness = 6.5
    );
```
6. Copier les modules `makebackPlate()` et `multiConnectSlotTool()` depuis `MulticonnectBin.scad`

## Tests
- Doit compiler sans erreur
- Tester avec dimensions < 5mm pour vérifier que le dos se génère
- Tester avec grandes dimensions pour la scalabilité
