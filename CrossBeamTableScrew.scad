include <Bridge.inc>
include <Utils.inc>

%Bridge(colored = false);

CrossBeamTableScrew(0);
CrossBeamTableScrew(1);

module CrossBeamTableScrew(index) {
    if (index == 0 || index == 1) {
        mirror_if(index == 1, VEC_X) {
            translate([0, (bridge_width + bridge_arch_width)/2]) {
                translate([-bridge_bounding_length/2 + mm(10), 0]) {
                    translate([0, 0, bridge_cross_beam_top - mm(2)]) {
                        mirror(VEC_Z) cylinder(d = 4, h = bridge_cross_beam_height, $fn=32);
                    }
                    translate([0, 0, mm(2)]) {
                        linear_extrude(3.2) {
                            size = mm(7.0);
                            intersection() {
                                hull() {
                                    Hex(size);
                                    translate([0,size,0]) Hex(size);
                                }
                                square(size / cos(30), true);
                            }
                        }
                    }
                }
                translate([-bridge_bounding_length/2 + mm(20), 0]) {
                    size = mm(8.5);
                    $fn=32;
                    translate([0,0,-size/2]) cylinder(d = size, h = size);
                    hull() {
                        for (p=[[0,0,size/2],[size,0,size/2],[size,0,size/4], [0,0, 0]]) translate(p) {
                            mirror(VEC_Z) {
                                cylinder(d1 = size, d2 = size/3, h = size /4);
                            }
                        }
                    }
                    hull() {
                        cylinder(d = size/3, h = size, center = true);
                        translate([size, 0]) cylinder(d = size/3, h = size, center = true);
                    }
                }
            }
        }
    }
}
