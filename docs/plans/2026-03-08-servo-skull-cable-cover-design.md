# Cache-cable Servo-crane W40K

## Contexte
Un servo-crane electrifie (LEDs) est monte sur un mur. Un cable blanc de 10mm descend verticalement sur 1m30. Le cache-cable doit couvrir ce cable avec une esthetique Warhammer 40K melant style Mechanicus (conduits, engrenages, rivets) et Imperial (aquila, cranes, gothique).

## Architecture

Deux types de pieces :
- **Base murale** : rail plat visse au mur, maintient le cable
- **Coffrage decoratif** : demi-cylindre nervure qui se visse sur la base avec des vis M3 hex apparentes

5 segments de ~30cm couvrent 1m30. Les segments se chevauchent de 2cm (overlap) pour masquer les joints et donner un aspect "plaques de blindage".

## Base murale

- Bande plate 30mm x 280mm x 3mm
- Canal central en U : 11mm large x 6mm profond (cable 10mm + 1mm jeu)
- Clips souples tous les 7cm pour retenir le cable
- 2 trous de vis fraises (4mm, tete 8mm) pour fixation murale
- 4 inserts filetés M3 heat-set pour recevoir les vis du coffrage
- Impression : a plat, sans support, 3 perimetres, remplissage 30%

## Coffrage standard

- Demi-cylindre rayon ext 20mm, epaisseur paroi 2mm
- Longueur : 300mm (280mm utile + 20mm overlap bas)
- Deux levres laterales plates pour reposer sur la base
- Largeur totale au mur : ~45mm

### Nervures
- Anneaux en relief : 1mm haut, 2mm large, espaces de 20mm
- Rigidifient la piece + look conduit Mechanicus

### Rivets
- Domes 2mm diametre, 0.8mm haut
- Deux rangees le long des levres, espacement 15mm

### Vis decoratives
- 4 vis M3 tete hexagonale par segment (2 par cote)
- Traversent les levres, se vissent dans les inserts de la base
- Tetes hex apparentes = esthetique Mechanicus

### Overlap
- Les 20mm du bas ont un rayon interieur +0.5mm
- Glisse par-dessus le segment inferieur
- Simple a imprimer, pas de geometrie fine

### Impression
- Debout, ouverture vers le bas sur le lit
- Pas de support : angle du demi-cylindre <= 45 degres
- Nervures horizontales, s'impriment naturellement

## Decorations

Tous les details sont en relief positif (max 1mm), imprimables sans support.

| Segment | Position | Decoration |
|---------|----------|------------|
| 1 | Bas (terminal) | Embout ferme arrondi, plaque de blindage avec skull grave |
| 2 | Standard | Nervures + rivets uniquement |
| 3 | Milieu (focal) | Cog Mechanicus en relief (25mm), plaques de blindage, faux boulons hex |
| 4 | Standard | Nervures + rivets uniquement |
| 5 | Haut (terminal) | Demi-Aquila en bas-relief (20mm), col evase vers le servo-crane |

## Dimensions recapitulatives

| Element | Valeur |
|---------|--------|
| Rayon ext coffrage | 20mm |
| Epaisseur paroi | 2mm |
| Largeur totale au mur | ~45mm |
| Largeur base | 30mm |
| Epaisseur base | 3mm |
| Canal cable | 11 x 6mm |
| Overlap | 20mm |
| Hauteur segment | 300mm (280mm utile) |
| Nombre segments | 5 |
| Hauteur totale | ~1300mm |

## Assemblage

1. Visser les 5 bases au mur a intervalles reguliers, cable dans les canaux
2. Poser le coffrage terminal bas (segment 1), visser 4x M3
3. Poser segment 2, overlap recouvre le haut du segment 1, visser
4. Repeter jusqu'au segment 5
5. Le col evase du segment 5 rejoint le servo-crane

## Fichiers OpenSCAD

| Fichier | Description |
|---------|-------------|
| `cable_base.scad` | Base murale parametrique |
| `cable_cover.scad` | Coffrage standard (nervures, rivets) |
| `cable_cover_bottom.scad` | Terminal bas (embout ferme) |
| `cable_cover_top.scad` | Terminal haut (col evase) |
| `decorations.scad` | Modules decoratifs (cog, aquila, skull, plaques) |

## Parametres d'impression

- Imprimante : Prusa XL
- Buse : 0.4mm
- Couche : 0.2mm
- Perimetres : 3 (coffrage), 3 (base)
- Remplissage : 30% (base), 15% (coffrage)
- Support : aucun
