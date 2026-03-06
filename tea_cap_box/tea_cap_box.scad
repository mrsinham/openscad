include <../BOSL2/std.scad>

// ===========================================
// Boîte de rangement pour chapeaux d'infuseur
// Fixation murale magnétique sur chaudière
// ===========================================

// --- Chapeaux d'infuseur ---
cap_diameter  = 75;   // diamètre max (mm)
cap_thickness = 15;   // épaisseur max (mm)
num_caps      = 5;    // nombre de chapeaux à stocker

// --- Aimants 8 x 18 x 1.5 mm ---
mag            = [8, 18, 1.5];
mag_stack      = 2;   // aimants empilés par logement
num_mag_pockets = 2;  // nombre de logements

// --- Impression 3D (buse 0.4, couche 0.2) ---
nozzle  = 0.4;
layer_h = 0.2;
tol     = 0.3;    // tolérance générale par côté
mag_tol = 0.15;   // tolérance aimants (ajustement serré)

// --- Construction ---
wall      = 2.4;   // parois latérales (6 périmètres)
floor_t   = 2.0;   // fond (10 couches)
divider_t = 1.6;   // épaisseur séparateurs (4 périmètres)
fillet_r  = 3;     // rayon congé haut des parois
scoop_r   = 12;    // rayon découpe arrondie paroi avant
drain_slot_w = 1.2; // largeur fente grillage (3 lignes à 0.4)
drain_bar_w  = 1.2; // largeur barreau entre fentes
drain_margin = 3;   // marge autour du grillage

// --- Dimensions calculées ---

// Logement aimant
mag_pw = mag.x + 2 * mag_tol;           // largeur poche (X)
mag_ph = mag.y + 2 * mag_tol;           // hauteur poche (Z)
mag_pd = mag.z * mag_stack + 2 * mag_tol; // profondeur poche (Y)

// Intérieur boîte
inner_w = num_caps * (cap_thickness + tol) + tol;  // largeur
inner_d = cap_diameter;                                // profondeur = diamètre complet
inner_h = cap_diameter * 0.6;                          // hauteur (~45mm, chapeaux dépassent d'1/3)

// Épaisseur paroi arrière : paroi intérieure pleine + logement aimants ouvert à l'arrière
back_wall = wall + mag_pd;

// Extérieur boîte
outer_w = inner_w + 2 * wall;
outer_d = inner_d + wall + back_wall;
outer_h = inner_h + floor_t;

// --- Modules ---

module magnet_pocket() {
    cube([mag_pw, mag_pd, mag_ph]);
}

module magnet_pockets() {
    spacing = outer_w / (num_mag_pockets + 1);
    for (i = [1:num_mag_pockets]) {
        translate([
            spacing * i - mag_pw / 2,
            outer_d - mag_pd,
            outer_h / 2 - mag_ph / 2
        ])
            // Traverse toute la paroi arrière (aimants affleurants)
            cube([mag_pw, mag_pd + 1, mag_ph]);
    }
}

module dividers() {
    for (i = [1:num_caps - 1]) {
        translate([
            wall + i * (cap_thickness + tol) + tol/2 - divider_t/2,
            wall,
            floor_t
        ])
            cube([divider_t, inner_d, inner_h]);
    }
}

module drain_grid() {
    // Fentes parallèles d'écoulement au fond de chaque logement
    slot_w = cap_thickness + tol;
    grid_d = inner_d - 2 * drain_margin;
    pitch = drain_slot_w + drain_bar_w;

    for (i = [0:num_caps - 1]) {
        slot_x = wall + tol/2 + i * slot_w;
        for (sx = [0 : pitch : slot_w - 2 * drain_margin])
            if (sx + drain_slot_w <= slot_w - 2 * drain_margin)
                translate([slot_x + drain_margin + sx, wall + drain_margin, -1])
                    cube([drain_slot_w, grid_d, floor_t + 2]);
    }
}

module grip_scoops() {
    // Découpes arrondies au milieu du haut de chaque séparateur
    for (i = [1:num_caps - 1]) {
        divider_x = wall + i * (cap_thickness + tol) + tol/2;
        translate([divider_x, wall + inner_d/2, outer_h])
            rotate([0, 90, 0])
                cylinder(r=scoop_r, h=divider_t + 2, center=true, $fn=32);
    }
}

module box() {
    difference() {
        union() {
            difference() {
                // Coque extérieure avec congés sur les arêtes du haut uniquement
                translate([outer_w/2, outer_d/2, outer_h/2])
                    cuboid([outer_w, outer_d, outer_h],
                        rounding=fillet_r, edges=[TOP+FRONT, TOP+LEFT, TOP+RIGHT], $fn=32,
                        anchor=CENTER);

                // Cavité intérieure (ouverte en haut)
                translate([wall, wall, floor_t])
                    cube([inner_w, inner_d, inner_h + fillet_r + 1]);

                // Logements aimants (traversants à l'arrière)
                magnet_pockets();
            }

            // Séparateurs
            dividers();
        }

        // Découpes arrondies dans les séparateurs (après union)
        grip_scoops();

        // Grillage d'écoulement au fond
        drain_grid();
    }
}

// --- Rendu ---
box();

// --- Info debug ---
echo(str("Dimensions extérieures: ",
    outer_w, " x ", outer_d, " x ", outer_h, " mm"));
echo(str("Poche aimant: ",
    mag_pw, " x ", mag_pd, " x ", mag_ph, " mm"));
