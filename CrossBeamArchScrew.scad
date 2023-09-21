include <Bridge.inc>

%Bridge(colored = false);

position = 0.995;

CrossBeamArchScrewHole(0);
CrossBeamArchScrewHole(1);

module CrossBeamArchScrewHole(index) {
    CrossBeamArchScrewTranspose(index) {
        cylinder(d = 3.1, h = 40, center = true, $fn = 32);
        translate([0, 0, mm(-5)]) mirror(VEC_Z)cylinder(d = 6.2, h = 20, $fn = 32);
        translate([0, 0, mm(7)]) linear_extrude(2.5) {
            hull() {
                Hex(mm(5.5));
                translate([-10, 0])Hex(mm(5.5));
            }
        }
    }
}

module CrossBeamArchScrewTranspose(index) {
    translate([0, (bridge_arch_distance_bottom + bridge_arch_width) / 2]) {
        rotate(180 -bridge_arch_angle, VEC_X) {
   
            if (index == 0) {
                translate(bridge_arch_center_point(-position)) {
                    rotate(bridge_arch_angle(-position), VEC_Z) {
                        rotate(90, VEC_Y) translate([-1, 0]) children();
                    }
                }
            } else if (index == 1) {
                translate(bridge_arch_center_point(position)) {
                    rotate(bridge_arch_angle(position), VEC_Z) {
                        rotate(90, VEC_Y) translate([-1, 0]) mirror(VEC_X) children();
                    }
                }
            }
        }
    }
}
