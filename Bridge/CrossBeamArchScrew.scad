include <../Bridge.inc>
use     <../Misc/M4CounterSunkScrew.scad>

%Bridge(colored = false);

position = 0.995;

CrossBeamArchScrewHole(0);
CrossBeamArchScrewHole(1);

module CrossBeamArchScrewHole(index, screw = true, nut = true, max_overhang_angle = 60) {
    CrossBeamArchScrewTranspose(index) {
        mirror_if(index == 1, VEC_Z) { 
            if (screw) translate([0,0, -8]) {
                rotate(index == 1 ? 90 : -90) {
                    M4CounterSunkScrewHole(length = mm(32), bias = 15, max_overhang_angle = max_overhang_angle);
                }
            }
            if (nut) translate([0,0,  18]) {
                rotate(180) M4NutSlot(slot_length = mm(5));
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
                        rotate(90, VEC_Y) translate([-1, 0]) children();
                    }
                }
            }
        }
    }
}
