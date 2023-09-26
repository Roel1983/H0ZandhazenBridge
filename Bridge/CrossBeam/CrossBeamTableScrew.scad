include <../../Bridge.inc>
include <../../Misc/Utils.inc>
use     <../../Misc/M4CounterSunkScrew.scad>

%Bridge(colored = false);

CrossBeamTableScrew(0);
CrossBeamTableScrew(1);

screw_distance_y = round((bridge_width + bridge_arch_width) / mm(5)) * mm(5);
echo(str("Screw distance: ", screw_distance_y));

module CrossBeamTableScrew(index) {
    if (index == 0 || index == 1) {
        mirror_if(index == 1, VEC_X) {
            translate([0, screw_distance_y/2]) {
                translate([-bridge_bounding_length/2 + mm(10), 0]) {
                    translate([0, 0, bridge_cross_beam_top - mm(2)]) {
                        mirror(VEC_Z) cylinder(d = 4, h = bridge_cross_beam_height, $fn=32);
                    }
                    translate([0, 0, mm(1.5)]) {
                        rotate(90) M4NutSlot();
                    }
                }
                translate([-bridge_bounding_length/2 + mm(25), 0]) {
                    size = mm(8.5);
                    a    = size/1.5;
                    $fn=32;
                    translate([-a,0,-size/2]) cylinder(d = size, h = size);
                    hull() {
                        for (p=[[-a,0,size/2],[0,0,size/2],[0,0,size/4], [-a,0, 0]]) translate(p) {
                            mirror(VEC_Z) {
                                cylinder(d1 = size, d2 = size/3, h = size /4);
                            }
                        }
                    }
                    hull() {
                        cylinder(d = size/3, h = size, center = true);
                        translate([-a, 0]) cylinder(d = size/3, h = size, center = true);
                    }
                }
            }
        }
    }
}
