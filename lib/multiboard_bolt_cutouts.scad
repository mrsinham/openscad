include <../BOSL2/std.scad>
include <../BOSL2/threading.scad>

// ===========================================
// Multiboard Bolt Cutouts - Profils négatifs filetés
// Pour découper des passages de vis dans des parois
// ===========================================
//
// Usage :
//   include <../lib/multiboard_bolt_cutouts.scad>
//
//   difference() {
//       my_part();
//       multiboard_big_bolt_cutout(wall=6);
//   }

// --- Dimensions Multiboard (source: multiboard_base.scad) ---

// Grille
MB_GRID = 25;

// Multi-hole (gros trou octogonal) - filetage trapézoïdal
MB_MULTI_THREAD_D1    = 22.6;   // diamètre ext filetage
MB_MULTI_THREAD_D2    = 21.4;   // diamètre int filetage
MB_MULTI_THREAD_PITCH = 2.5;    // pas
MB_MULTI_THREAD_DEPTH = (22.6 - 21.4) / 2;  // 0.6mm

// Peg hole (petit trou) - filetage trapézoïdal
MB_PEG_THREAD_D1    = 7.0;      // diamètre ext filetage
MB_PEG_THREAD_D2    = 6.0;      // diamètre int filetage
MB_PEG_THREAD_PITCH = 3.0;      // pas
MB_PEG_THREAD_DEPTH = (7.0 - 6.0) / 2;  // 0.5mm

// Épaisseur tuile
MB_TILE_H = 6.4;

// --- Tolérances ---
MB_CLEARANCE = 0.3;  // jeu général

// ===========================================
// MODULES - Profils négatifs filetés (à soustraire)
// ===========================================

// Trou fileté pour vis gros filetage (multi-hole)
// wall       = épaisseur de la paroi à traverser (= longueur du filetage)
// head_d     = diamètre de la tête de vis (0 = pas de logement tête)
// head_depth = profondeur du logement tête
module multiboard_big_bolt_cutout(wall, head_d=0, head_depth=0) {
    $slop = MB_CLEARANCE;
    trapezoidal_threaded_rod(
        d = MB_MULTI_THREAD_D1,
        l = wall + 0.02,
        pitch = MB_MULTI_THREAD_PITCH,
        thread_depth = MB_MULTI_THREAD_DEPTH,
        internal = true,
        $fn = 32,
        anchor = BOTTOM
    );
    if (head_d > 0 && head_depth > 0)
        translate([0, 0, -0.01])
            cylinder(d = head_d + 2*MB_CLEARANCE, h = head_depth + 0.01, $fn = 32);
}

// Trou fileté pour vis petit filetage (peg hole)
// wall       = épaisseur de la paroi à traverser (= longueur du filetage)
// head_d     = diamètre de la tête de vis (0 = pas de logement tête)
// head_depth = profondeur du logement tête
module multiboard_small_bolt_cutout(wall, head_d=0, head_depth=0) {
    $slop = MB_CLEARANCE;
    trapezoidal_threaded_rod(
        d = MB_PEG_THREAD_D1,
        l = wall + 0.02,
        pitch = MB_PEG_THREAD_PITCH,
        thread_depth = MB_PEG_THREAD_DEPTH,
        internal = true,
        $fn = 32,
        anchor = BOTTOM
    );
    if (head_d > 0 && head_depth > 0)
        translate([0, 0, -0.01])
            cylinder(d = head_d + 2*MB_CLEARANCE, h = head_depth + 0.01, $fn = 32);
}

// Grille de trous filetés gros filetage
module multiboard_big_bolt_grid(cols, rows, wall, head_d=0, head_depth=0) {
    for (ix = [0:cols-1])
        for (iy = [0:rows-1])
            translate([ix * MB_GRID, iy * MB_GRID, 0])
                multiboard_big_bolt_cutout(wall, head_d, head_depth);
}

// Grille de trous filetés petit filetage
module multiboard_small_bolt_grid(cols, rows, wall, head_d=0, head_depth=0) {
    for (ix = [0:cols-1])
        for (iy = [0:rows-1])
            translate([ix * MB_GRID, iy * MB_GRID, 0])
                multiboard_small_bolt_cutout(wall, head_d, head_depth);
}

// Grille mixte layout Multiboard réel
// Multi-holes au centre de chaque cellule, peg-holes aux intersections
module multiboard_mixed_grid(cols, rows, wall, head_d=0, head_depth=0) {
    for (ix = [0:cols-1])
        for (iy = [0:rows-1])
            translate([ix * MB_GRID + MB_GRID/2, iy * MB_GRID + MB_GRID/2, 0])
                multiboard_big_bolt_cutout(wall, head_d, head_depth);
    for (ix = [0:cols])
        for (iy = [0:rows])
            if (ix > 0 && iy > 0 && ix < cols && iy < rows)
                translate([ix * MB_GRID, iy * MB_GRID, 0])
                    multiboard_small_bolt_cutout(wall);
}
