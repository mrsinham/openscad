include <../BOSL2/std.scad>
use <cable_cover.scad>
use <decorations.scad>

// ===========================================
// Coffrage terminal haut - Cache-cable W40K
// Segment 5 : col evase + demi-aquila
// ===========================================

/* [Dimensions] */
cover_radius = 20;
cover_wall   = 2;
lip_width    = 8;
lip_thick    = 2.4;

// Col evase
flare_height = 25;    // hauteur de la transition evasee
flare_radius = 28;    // rayon au sommet du col

$fn = 48;

// --- Modules ---

module flared_collar() {
    // Transition demi-cylindre vers col evase
    difference() {
        // Exterieur evase
        rotate([-90, 0, 0])
            cylinder(r1=cover_radius, r2=flare_radius, h=flare_height);
        // Interieur evase
        rotate([-90, 0, 0])
            cylinder(r1=cover_radius - cover_wall, r2=flare_radius - cover_wall, h=flare_height + 0.02);
        // Couper moitie basse
        translate([-(flare_radius + 1), -0.01, -(flare_radius) * 2 - 1])
            cube([flare_radius * 2 + 2, flare_height + 0.02, flare_radius * 2 + 1]);
    }
    // Levre du col (anneau en haut)
    translate([0, flare_height, 0])
        difference() {
            rotate([-90, 0, 0])
                cylinder(r=flare_radius + 1.5, h=2);
            rotate([-90, 0, 0])
                cylinder(r=flare_radius - cover_wall, h=2.02);
            translate([-(flare_radius + 2), -0.01, -(flare_radius + 2) * 2])
                cube([(flare_radius + 2) * 2, 2.04, (flare_radius + 2) * 2]);
        }
}

module top_segment() {
    cover_length = 280;
    overlap_h = 20;
    total_length = cover_length + overlap_h;

    union() {
        // Coffrage standard
        cover_segment();

        // Col evase en haut
        translate([0, total_length, 0])
            flared_collar();

        // Decoration : demi-aquila
        translate([0, total_length * 0.55, cover_radius + 0.5])
            half_aquila(width=22, thickness=1);
    }
}

// --- Rendu ---
top_segment();
