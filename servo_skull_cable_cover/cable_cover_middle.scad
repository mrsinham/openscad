include <../BOSL2/std.scad>
use <cable_cover.scad>
use <decorations.scad>

// ===========================================
// Coffrage milieu focal - Cache-cable W40K
// Segment 3 : cog Mechanicus + plaques blindage
// ===========================================

/* [Dimensions] */
cover_radius = 20;
cover_wall   = 2;

$fn = 48;

// --- Module ---

module middle_segment() {
    cover_length = 280;
    overlap_h = 20;
    total_length = cover_length + overlap_h;

    union() {
        // Coffrage standard
        cover_segment();

        // Cog Mechanicus au centre
        translate([0, total_length / 2, cover_radius + 0.5])
            half_cog_mechanicus(diameter=28, teeth=12, tooth_depth=3, thickness=1);

        // Plaques de blindage de chaque cote du cog
        for (dy = [-30, 30])
            translate([0, total_length / 2 + dy, cover_radius + 0.5])
                armor_plate(w=8, h=12, thickness=0.6, bolt_d=1.5);
    }
}

// --- Rendu ---
middle_segment();
