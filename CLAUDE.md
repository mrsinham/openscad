# Projet OpenSCAD

## Structure du dépot
- `BOSL2/` - Librairie BOSL2 (submodule git) - https://github.com/BelfrySCAD/BOSL2
- `libs/` - Librairies Multiboard (submodules git)
  - `libs/multiboard-parametric-stacked/` - Tuiles empilées paramétriques
  - `libs/MultiConnectOpenSCAD/` - QuackWorks, prints fonctionnels paramétriques avec interfaces de montage
  - `libs/mb-tile-generator/` - Générateur de tuiles Multiboard (OpenSCAD + Python GUI)
  - `libs/multiboard-storage-solution/` - Solution de rangement modulaire Multiboard
- `tea_cap_box/` - Boite de rangement pour chapeaux d'infuseur a the
- Chaque projet est dans son propre répertoire
- Les fichiers .scad incluent BOSL2 via chemin relatif : `include <../BOSL2/std.scad>`

## Conventions impression 3D
- Buse 0.4mm, couches 0.2mm
- Parois : multiples de 0.4mm (ex: 1.6mm = 4 périmètres, 2.4mm = 6 périmètres)
- Epaisseur fond/plancher : multiple de 0.2mm (ex: 2.0mm = 10 couches)
- Tolérance générale : 0.3mm par côté
- Tolérance aimants : ajuster selon mesure réelle, ne pas se fier aux dimensions théoriques
- Congés/filets : uniquement en haut (imprimable sans support), pas en bas
- Grillages : fentes parallèles avec barreau central perpendiculaire pour rigidité, éviter les grilles croisées (blocs non reliés)

## Conventions OpenSCAD
- Utiliser BOSL2 quand possible (cuboid avec rounding/edges, etc.)
- Paramètres en haut du fichier, dimensions calculées ensuite
- Les séparateurs/dividers doivent être ajoutés dans un union() puis les découpes soustraites après, sinon le difference() de la cavité les supprime
- echo() en fin de fichier pour debug des dimensions

## Librairies externes disponibles
- BOSL2 : librairie OpenSCAD généraliste (submodule)
- Multiboard/MultiBuild : standard de grille modulaire murale (pas = 25mm)

## Projets

### tea_cap_box
- Boite murale magnétique pour chapeaux d'infuseur a thé
- Caps : disques circulaires 80mm diamètre, 20mm épaisseur
- 5 logements avec séparateurs
- Fixation par aimants 8x18x1.5mm (2 empilés par logement, ouverts à l'arrière, surface intérieure fermée)
- Poches aimants : 10mm x 19mm (surdimensionnées car aimants irréguliers)
- Découpes arrondies (scoop) en haut des séparateurs pour saisir les caps
- Grillage d'écoulement au fond de chaque logement
