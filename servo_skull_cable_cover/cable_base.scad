include <../BOSL2/std.scad>

// ===========================================
// Base murale - Cache-cable Servo-crane W40K
// Rail visse au mur avec canal pour cable
// ===========================================

/* [Dimensions] */
// Longueur du segment
base_length    = 280;   // mm
// Largeur totale de la base (= largeur coffrage avec levres)
base_width     = 56;    // mm
// Epaisseur de la base
base_thick     = 3;     // mm

/* [Canal cable] */
// Largeur du canal (cable 10mm + jeu)
channel_w      = 11;    // mm
// Profondeur du canal
channel_d      = 6;     // mm

/* [Clips cable] */
// Espacement des clips
clip_spacing   = 70;    // mm
// Largeur du clip (dans le sens Y)
clip_w         = 2;     // mm
// Epaisseur du clip (paroi)
clip_t         = 1.2;   // mm
// Hauteur de la languette au-dessus du canal
clip_h         = 2;     // mm
// Depassement de la languette dans le canal
clip_overhang  = 2;     // mm

/* [Fixation murale] */
// Diametre trou de vis
screw_d        = 4;     // mm
// Diametre tete de vis (pour fraisage conique)
screw_head_d   = 8;     // mm
// Distance du bord
screw_inset    = 15;    // mm

/* [Inserts coffrage] */
// Diametre insert M3 heat-set
insert_d       = 4.2;   // mm (trou pour insert M3)
// Profondeur insert
insert_h       = 5;     // mm
// Distance du centre de la base au centre de l'insert
// Doit correspondre a screw_offset_x dans cable_cover.scad (cover_radius + lip_width/2 = 24mm)
insert_offset_x = 24;   // mm
// Positions Y des inserts (depuis le bas du segment)
insert_y1      = 50;    // mm
insert_y2      = 230;   // mm

/* [Impression] */
nozzle = 0.4;
layer_h = 0.2;

// --- Construction ---

module base_plate() {
    difference() {
        // Plaque principale
        cube([base_width, base_length, base_thick + channel_d]);

        // Canal central
        translate([(base_width - channel_w) / 2, -0.01, base_thick])
            cube([channel_w, base_length + 0.02, channel_d + 0.01]);

        // Trous de vis murales avec fraisage conique (de chaque cote du canal)
        for (y = [screw_inset, base_length - screw_inset])
            for (side = [-1, 1])
                translate([base_width / 2 + side * (channel_w / 2 + 5), y, 0])
                    countersunk_hole();

        // Trous pour inserts M3 heat-set (4 inserts par base)
        // Inserts enfonces depuis le dessus (face avant), dans les ailes laterales
        for (y = [insert_y1, insert_y2])
            for (side = [-1, 1]) {
                ix = base_width / 2 + side * insert_offset_x;
                translate([ix, y, base_thick - insert_h])
                    cylinder(d = insert_d, h = insert_h + 0.01, $fn = 24);
            }
    }
}

module countersunk_hole() {
    total_h = base_thick + channel_d;
    cone_h = (screw_head_d - screw_d) / 2;
    // Trou traversant
    translate([0, 0, -0.01])
        cylinder(d = screw_d, h = total_h + 0.02, $fn = 24);
    // Cone de fraisage en haut (cote visible/coffrage, la vis entre par le dessus)
    translate([0, 0, total_h - cone_h])
        cylinder(d1 = screw_d, d2 = screw_head_d, h = cone_h + 0.01, $fn = 24);
}

module cable_clips() {
    num_clips = floor((base_length - 2 * screw_inset) / clip_spacing);
    start_y = (base_length - num_clips * clip_spacing) / 2;

    for (i = [0:num_clips])
        translate([0, start_y + i * clip_spacing, 0])
            cable_clip();
}

module cable_clip() {
    // Deux languettes simples qui depassent dans le canal pour retenir le cable
    top_z = base_thick + channel_d;
    for (side = [-1, 1]) {
        cx = base_width / 2 + side * (channel_w / 2);
        translate([cx - (side > 0 ? 0 : clip_overhang),
                   -clip_w / 2,
                   top_z - clip_h])
            cube([clip_overhang, clip_w, clip_h]);
    }
}

// --- Rendu ---
base_plate();
cable_clips();

// --- Debug ---
echo(str("Base: ", base_width, " x ", base_length, " x ", base_thick + channel_d, " mm"));
