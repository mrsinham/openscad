include <../BOSL2/std.scad>
use <cable_cover.scad>
use <decorations.scad>

// ===========================================
// Coffrage terminal bas - Cache-cable W40K
// Segment 1 : embout ferme + skull + plaque
// ===========================================

/* [Dimensions] */
// Rayon du coffrage (doit correspondre a cable_cover.scad)
cover_radius = 20;
cover_wall   = 2;
lip_width    = 8;
lip_thick    = 2.4;
cap_thick    = 2;     // epaisseur de l'embout ferme

$fn = 48;

// --- Modules ---

module bottom_cap() {
    // Embout arrondi ferme en bas du demi-cylindre
    difference() {
        // Dome
        rotate([0, 0, 0])
            scale([1, 1, 1])
                intersection() {
                    sphere(r = cover_radius, $fn = 48);
                    // Garder seulement la moitie haute
                    translate([-cover_radius - 1, -cover_radius - 1, 0])
                        cube([cover_radius * 2 + 2, cover_radius * 2 + 2, cover_radius + 1]);
                    // Garder seulement le demi avant
                    translate([-cover_radius - 1, -0.01, -cover_radius - 1])
                        cube([cover_radius * 2 + 2, cover_radius + 1, cover_radius * 2 + 2]);
                }
        // Evider l'interieur
        scale([1, 1, 1])
            intersection() {
                sphere(r = cover_radius - cover_wall, $fn = 48);
                translate([-cover_radius, -cover_radius, 0])
                    cube([cover_radius * 2, cover_radius * 2, cover_radius]);
                translate([-cover_radius, -0.01, -cover_radius])
                    cube([cover_radius * 2, cover_radius, cover_radius * 2]);
            }
    }
}

module bottom_segment() {
    union() {
        // Coffrage standard (on utilise le module du cover)
        cover_segment();

        // Embout ferme en bas
        rotate([90, 0, 0])
            bottom_cap();

        // Decoration : plaque de blindage avec skull
        translate([0, 140, cover_radius + 0.5])
            rotate([0, 0, 0]) {
                armor_plate(w=10, h=18, thickness=0.6);
                translate([0, 0, 0.6])
                    skull_relief(width=6, thickness=0.5);
            }
    }
}

// --- Rendu ---
bottom_segment();
