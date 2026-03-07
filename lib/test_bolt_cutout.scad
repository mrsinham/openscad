include <multiboard_bolt_cutouts.scad>

// Test : paroi verticale avec un trou fileté petit bolt

wall = 6;
panel_w = 30;
panel_h = 30;

difference() {
    // Paroi verticale
    cube([panel_w, wall, panel_h]);

    // Petit bolt fileté au centre, orienté en Y (traverse la paroi)
    translate([panel_w/2, 0, panel_h/2])
        rotate([-90, 0, 0])
            multiboard_small_bolt_cutout(wall=wall);
}
