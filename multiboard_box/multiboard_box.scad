include <../BOSL2/std.scad>

// ===========================================
// Boite 100x100x20mm montable sur Multiboard
// Utilise le systeme MultiConnect (QuackWorks)
// ===========================================

/* [Dimensions intérieures] */
internalWidth  = 100;  // mm (X)
internalDepth  = 20;   // mm (Y, distance depuis le dos)
internalHeight = 100;  // mm (Z)

/* [Construction] */
wallThickness = 2;     // épaisseur parois (mm)
baseThickness = 1.6;   // épaisseur fond (mm)
Front_Chamfer = 2;     // chanfrein avant

/* [Slot Customization] */
Connection_Type = "Multiconnect - Multiboard"; // [Multiconnect - Multiboard, Multiconnect - openGrid]
multiConnectVersion = "v2"; // [v1, v2]
onRampHalfOffset = true;
customDistanceBetweenSlots = 25;
subtractedSlots = 0;
slotQuickRelease = false;
dimpleScale = 1;            // [0.5:0.05:1.5]
slotTolerance = 1.00;       // [0.925:0.005:1.075]
slotDepthMicroadjustment = 0; // [-0.5:0.05:0.5]
onRampEnabled = true;
On_Ramp_Every_X_Slots = 1;
Multiconnect_Stop_Distance_From_Back = 13;

/* [Hidden] */
onRampEveryXSlots = On_Ramp_Every_X_Slots;
totalWidth = internalWidth + wallThickness * 2;
totalHeight = internalHeight + baseThickness;
backThickness = 6.5;

distanceBetweenSlots =
    Connection_Type == "Multiconnect - openGrid" ? 28 : 25;

Connection_Standard = "Multiconnect";

// --- Assemblage ---

union() {
    // Panneau arrière avec slots Multiconnect
    translate([-max(totalWidth, distanceBetweenSlots) / 2, 0.01, -baseThickness])
        makebackPlate(
            backWidth = totalWidth,
            backHeight = totalHeight,
            distanceBetweenSlots = distanceBetweenSlots,
            backThickness = backThickness
        );

    // Bac
    back(0.01)
        Basket();
}

// --- Modules ---

module Basket() {
    translate([0, internalDepth / 2, 0])
        diff()
            down(baseThickness)
                rect_tube(
                    size = [totalWidth, internalDepth + wallThickness * 2],
                    h = totalHeight,
                    wall = wallThickness,
                    chamfer = [Front_Chamfer, Front_Chamfer, 0, 0],
                    ichamfer = [Front_Chamfer, Front_Chamfer, 0, 0]
                );
    // Fond
    cuboid(
        [internalWidth + 0.01, internalDepth + 0.01, baseThickness],
        chamfer = Front_Chamfer,
        edges = [BACK+RIGHT, BACK+LEFT],
        anchor = TOP + FRONT
    );
}

// Panneau arrière avec slots
module makebackPlate(backWidth, backHeight, distanceBetweenSlots, backThickness, slotStopFromBack = 13, edgeRounding = 1) {
    let (
        backWidth = max(backWidth, distanceBetweenSlots),
        backHeight = max(backHeight, 25),
        slotCount = floor(backWidth / distanceBetweenSlots) - subtractedSlots
    ) {
        difference() {
            translate([0, -backThickness, 0])
                cuboid(
                    size = [backWidth, backThickness, backHeight],
                    rounding = edgeRounding,
                    edges = FRONT, except_edges = BOT,
                    anchor = FRONT + LEFT + BOT, $fn = 25
                );
            for (slotNum = [0:1:slotCount - 1]) {
                translate([
                    distanceBetweenSlots / 2 +
                    (backWidth / distanceBetweenSlots - slotCount) * distanceBetweenSlots / 2 +
                    slotNum * distanceBetweenSlots,
                    -2.35 + slotDepthMicroadjustment,
                    backHeight - Multiconnect_Stop_Distance_From_Back
                ])
                    multiConnectSlotTool(totalHeight);
            }
        }
    }
}

// Outil de slot Multiconnect
module multiConnectSlotTool(totalHeight) {
    distanceOffset = onRampHalfOffset ? distanceBetweenSlots / 2 : 0;
    scale(slotTolerance)
    let (slotProfile = [[0,0],[10.15,0],[10.15,1.2121],[7.65,3.712],[7.65,5],[0,5]])
    difference() {
        union() {
            rotate([90, 0, 0])
                rotate_extrude($fn = 50)
                    polygon(points = slotProfile);
            rotate([180, 0, 0])
                union() {
                    difference() {
                        linear_extrude(height = totalHeight + 1)
                            polygon(points = slotProfile);
                        if (slotQuickRelease == false && multiConnectVersion == "v2")
                            translate([10.15, 0, 0])
                                rotate([-90, 0, 0])
                                    linear_extrude(height = 5)
                                        polygon(points = [[0,0],[-0.4,0],[0,-8]]);
                    }
                    mirror([1, 0, 0])
                        difference() {
                            linear_extrude(height = totalHeight + 1)
                                polygon(points = slotProfile);
                            if (slotQuickRelease == false && multiConnectVersion == "v2")
                                translate([10.15, 0, 0])
                                    rotate([-90, 0, 0])
                                        linear_extrude(height = 5)
                                            polygon(points = [[0,0],[-0.4,0],[0,-8]]);
                        }
                }
            if (onRampEnabled)
                for (y = [1:onRampEveryXSlots:totalHeight / distanceBetweenSlots])
                    translate([0, -5, (-y * distanceBetweenSlots) + distanceOffset])
                        rotate([-90, 0, 0])
                            cylinder(h = 5, r1 = 12, r2 = 10.15);
        }
        if (slotQuickRelease == false && multiConnectVersion == "v1")
            scale(dimpleScale)
                rotate([90, 0, 0])
                    rotate_extrude($fn = 50)
                        polygon(points = [[0,0],[0,1.5],[1.5,0]]);
    }
}

// --- Debug ---
echo(str("Dimensions extérieures: ", totalWidth, " x ",
    internalDepth + wallThickness + backThickness, " x ", totalHeight, " mm"));
echo(str("Slots Multiconnect: ", floor(totalWidth / distanceBetweenSlots) - subtractedSlots));
