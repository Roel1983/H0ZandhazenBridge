include <Bridge.inc>

%Bridge(colored = false);
for (index = [0 : bridge_cable_count - 1]) {
    CableBottomAttachment(index);
    CableTopAttachment(index);
}

module CableBottomAttachment(index) {
    cable_bottom_transpose(index) {
        mirror(VEC_Z) translate([0,0,-2.7]) cylinder(d=6.3, h=26, $fn = 32);
        translate([0,0,-3])
        cylinder(d=3, h=20, $fn = 32);
    }
}
module CableTopAttachment(index) {
    cable_top_transpose(index) {
        render() translate([0,0,-7]) {
            intersection() {
                linear_extrude(2.5) {
                    hull() {
                        Hex(mm(5.5));
                        translate([0,-5.5]) Hex(mm(5.5));
                    }   
                }
                rotate(bridge_arch_angle, VEC_Y) translate([0,-5.5/2]) { // TODO
                    rotate(-cable_top_angle_vec_y(index), VEC_Y) {
                        rotate(-cable_top_angle_vec_x(index), VEC_X) {
                            translate([0, 5.5]) {
                                cube(5.5 * 2, true);
                            }
                        }
                    }
                }
            }
            translate([0,0,mm(-5.5)]) cylinder(d=3.0, h= bridge_arch_thickness_bottom, $fn=32);
        }
    }
}

module Hex(d) {
    intersection_for(a = [30,90,150]) rotate(a) square([d, d*2], true);
}

