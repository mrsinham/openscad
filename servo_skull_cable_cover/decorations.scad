include <../BOSL2/std.scad>

// ===========================================
// Decorations W40K - Modules reutilisables
// Style Mechanicus / Imperial
// ===========================================

/* [Parametres generaux] */
detail_h = 1;  // hauteur du relief des decorations

// --- Cog Mechanicus (roue dentee) ---

module cog_mechanicus(diameter=25, teeth=12, tooth_depth=3, thickness=1) {
    // Demi-roue dentee Mechanicus (pour surface courbe, projeter apres)
    difference() {
        union() {
            // Disque central
            cylinder(d=diameter - tooth_depth*2, h=thickness, $fn=48);
            // Dents
            for (i = [0:teeth-1]) {
                angle = i * 360 / teeth;
                rotate([0, 0, angle])
                    translate([diameter/2 - tooth_depth, -1.2, 0])
                        cube([tooth_depth, 2.4, thickness]);
            }
        }
        // Trou central (skull placeholder)
        cylinder(d=diameter * 0.3, h=thickness + 0.02, $fn=24);
    }
}

// Version demi-cog pour surface demi-cylindrique
module half_cog_mechanicus(diameter=25, teeth=12, tooth_depth=3, thickness=1) {
    difference() {
        cog_mechanicus(diameter, teeth, tooth_depth, thickness);
        translate([-diameter/2 - 1, -diameter/2 - 1, -0.01])
            cube([diameter + 2, diameter/2 + 1, thickness + 0.02]);
    }
}

// --- Skull (crane) ---

module skull(width=8, thickness=0.8) {
    h = width * 1.2;
    // Cranium (ellipse)
    scale([1, 1, thickness/width])
        resize([width, 0, 0], auto=true)
            sphere(d=width, $fn=32);
    // Machoire
    translate([0, -width*0.3, 0])
        scale([0.7, 0.5, thickness/width])
            sphere(d=width*0.6, $fn=24);
    // Yeux (creux)
}

module skull_relief(width=8, thickness=0.6) {
    // Skull en bas-relief pour surface plane
    difference() {
        // Forme pleine
        intersection() {
            skull(width, width);
            translate([-width, -width, 0])
                cube([width*2, width*2, thickness]);
        }
        // Orbites
        for (side = [-1, 1])
            translate([side * width * 0.18, width * 0.1, -0.01])
                cylinder(d=width*0.22, h=thickness+0.02, $fn=16);
    }
}

// --- Aquila (aigle imperial) ---

module half_aquila(width=20, thickness=1) {
    // Aile simplifiee en relief
    h = width * 0.6;
    // Aile deployee (forme triangulaire arrondie)
    hull() {
        // Centre
        cylinder(d=3, h=thickness, $fn=16);
        // Bout d'aile
        translate([width/2, h*0.3, 0])
            cylinder(d=2, h=thickness, $fn=16);
        // Bas de l'aile
        translate([width*0.4, -h*0.2, 0])
            cylinder(d=2, h=thickness, $fn=16);
    }
    // Deuxieme aile (miroir)
    mirror([1,0,0])
    hull() {
        cylinder(d=3, h=thickness, $fn=16);
        translate([width/2, h*0.3, 0])
            cylinder(d=2, h=thickness, $fn=16);
        translate([width*0.4, -h*0.2, 0])
            cylinder(d=2, h=thickness, $fn=16);
    }
    // Tete centrale
    translate([0, h*0.15, 0])
        cylinder(d=3, h=thickness*1.2, $fn=16);
}

// --- Plaque de blindage ---

module armor_plate(w=8, h=15, thickness=0.6, bolt_d=2) {
    // Plaque rectangulaire avec boulons aux coins
    difference() {
        // Plaque
        translate([-w/2, -h/2, 0])
            cube([w, h, thickness]);
        // Optionnel : bord biseaute
    }
    // Boulons hex aux coins
    inset = 2;
    for (x = [-1, 1])
        for (y = [-1, 1])
            translate([x*(w/2 - inset), y*(h/2 - inset), thickness - 0.01])
                cylinder(d=bolt_d, h=0.5, $fn=6);
}

// --- Demo ---
// Decommenter pour visualiser :
// translate([0, 0, 0]) half_cog_mechanicus();
// translate([35, 0, 0]) skull_relief();
// translate([60, 0, 0]) half_aquila();
// translate([90, 0, 0]) armor_plate();
