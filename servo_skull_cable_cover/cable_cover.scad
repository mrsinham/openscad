include <../BOSL2/std.scad>

// ===========================================
// Coffrage standard - Cache-cable Servo-crane W40K
// Demi-cylindre nervure style Mechanicus
// ===========================================

/* [Dimensions] */
// Longueur utile du segment
cover_length     = 280;   // mm
// Rayon exterieur du demi-cylindre
cover_radius     = 20;    // mm
// Epaisseur de paroi
cover_wall       = 2;     // mm
// Largeur des levres laterales
lip_width        = 8;     // mm
// Epaisseur des levres
lip_thick        = 2.4;   // mm

/* [Overlap] */
// Longueur de l'overlap en bas
overlap_h        = 20;    // mm
// Jeu supplementaire du rayon interieur de l'overlap
overlap_gap      = 0.5;   // mm

/* [Nervures] */
// Espacement des nervures
rib_spacing      = 20;    // mm
// Hauteur des nervures (relief)
rib_height       = 1;     // mm
// Largeur des nervures
rib_width        = 2;     // mm

/* [Rivets] */
// Diametre des rivets
rivet_d          = 2;     // mm
// Hauteur des rivets
rivet_h          = 0.8;   // mm
// Espacement des rivets
rivet_spacing    = 15;    // mm
// Distance du rivet au bord de la levre
rivet_inset      = 3;     // mm

/* [Vis decoratives M3] */
// Diametre passage vis
screw_d          = 3.4;   // mm
// Positions Y des vis (depuis le bas du segment sans overlap)
screw_y1         = 50;    // mm
screw_y2         = 230;   // mm

/* [Impression] */
nozzle = 0.4;
layer_h = 0.2;
$fn = 48;

// --- Dimensions calculees ---
total_length = cover_length + overlap_h;
// Largeur totale au mur
total_width = cover_radius * 2 + lip_width * 2;
// Position des vis (distance du centre)
screw_offset_x = cover_radius + lip_width / 2;

// --- Modules ---

module half_cylinder(radius, length, wall) {
    difference() {
        // Exterieur
        rotate([-90, 0, 0])
            cylinder(r = radius, h = length);
        // Interieur
        rotate([-90, 0, 0])
            cylinder(r = radius - wall, h = length + 0.02, $fn = $fn);
        // Couper la moitie inferieure
        translate([-radius - 1, -0.01, -radius * 2 - 1])
            cube([radius * 2 + 2, length + 0.02, radius * 2 + 1]);
    }
}

module ribs() {
    num_ribs = floor(cover_length / rib_spacing);
    start_y = overlap_h + (cover_length - num_ribs * rib_spacing) / 2;
    for (i = [0:num_ribs]) {
        translate([0, start_y + i * rib_spacing - rib_width / 2, 0])
            difference() {
                rotate([-90, 0, 0])
                    cylinder(r = cover_radius + rib_height, h = rib_width);
                rotate([-90, 0, 0])
                    cylinder(r = cover_radius - 0.01, h = rib_width + 0.02);
                // Couper moitie basse
                translate([-(cover_radius + rib_height + 1), -0.01, -(cover_radius + rib_height) * 2 - 1])
                    cube([(cover_radius + rib_height) * 2 + 2, rib_width + 0.02, (cover_radius + rib_height) * 2 + 1]);
            }
    }
}

module lips() {
    for (side = [-1, 1]) {
        translate([side * cover_radius, 0, -lip_thick])
            cube([side > 0 ? lip_width : -lip_width,
                  total_length,
                  lip_thick]);
    }
    // Correction: cube ne prend pas de negatif
}

module lips_correct() {
    for (side = [-1, 1]) {
        x = side > 0 ? cover_radius : -cover_radius - lip_width;
        translate([x, 0, -lip_thick])
            cube([lip_width, total_length, lip_thick]);
    }
}

module rivets() {
    num_rivets = floor(cover_length / rivet_spacing);
    start_y = overlap_h + (cover_length - num_rivets * rivet_spacing) / 2;
    for (side = [-1, 1])
        for (i = [0:num_rivets]) {
            rx = side * (cover_radius + rivet_inset);
            ry = start_y + i * rivet_spacing;
            translate([rx, ry, 0])
                // Rivet dome sur la levre
                translate([0, 0, -lip_thick])
                    cylinder(d1 = rivet_d, d2 = rivet_d * 0.7, h = rivet_h, $fn = 16);
        }
}

module screw_holes() {
    for (y = [overlap_h + screw_y1, overlap_h + screw_y2])
        for (side = [-1, 1])
            translate([side * screw_offset_x, y, -lip_thick - 0.01])
                cylinder(d = screw_d, h = lip_thick + 0.02, $fn = 24);
}

module overlap_section() {
    // Section basse avec rayon interieur agrandi pour chevaucher le segment inferieur
    difference() {
        half_cylinder(cover_radius + overlap_gap, overlap_h, cover_wall);
        // Pas de nervure dans l'overlap
    }
}

module cover_segment() {
    difference() {
        union() {
            // Partie overlap (bas)
            overlap_section();

            // Partie principale
            translate([0, overlap_h, 0])
                half_cylinder(cover_radius, cover_length, cover_wall);

            // Nervures
            ribs();

            // Levres laterales
            lips_correct();

            // Rivets
            rivets();
        }

        // Trous de vis decoratives
        screw_holes();
    }
}

// --- Rendu ---
cover_segment();

// --- Debug ---
echo(str("Coffrage: largeur totale=", total_width,
    " longueur=", total_length,
    " rayon=", cover_radius, " mm"));
