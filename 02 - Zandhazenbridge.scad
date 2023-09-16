include <01 - Zandhazenbridge.scad>

arch_crossbeam_tolerance_xz = mm(0.1);
arch_crossbeam_tolerance_y  = mm(0.1);

hide_bridge = true;

Arch03();
!CrossBeam03();

module Arch02(offset_xz = 0, offset_y = 0) {
    difference() {
        Arch(offset_xz = offset_xz, offset_y = offset_y);
        CrossBeamInterface();
    }
    module CrossBeamInterface() {
        mirror_copy(VEC_X)
        translate([bridge_length / 2, bridge_width / 2]) {
            rotate(-bridge_arch_angle, VEC_X) cube([
                bridge_arch_thickness_bottom * 4,
                2 * (bridge_cross_beam_top - mm(2.5) - offset_xz),
                2 * (bridge_cross_beam_width - mm(0.5) - offset_y)
            ], true);
        }
    }
}

module CrossBeam02() {
    difference() {
        CrossBeam();
        Arch02(
            offset_xz = arch_crossbeam_tolerance_xz,
            offset_y  = arch_crossbeam_tolerance_y
        );
    }
}

module Arch03() {
    difference() {
        Arch02();
        CableAtachments();
    }
    module CableAtachments() {
        for(cable_nr = [0:bridge_cable_count-1]) {
            cable_top_transpose(cable_nr) {
                CableAtachment(cable_nr);
            }
        }
        module CableAtachment(cable_nr) {
            // TODO Pause print layer to insert nut all at the same layer
            render() translate([0,0,-7]) {
                intersection() {
                    linear_extrude(2.5) {
                        hull() {
                            Hex(mm(5.5));
                            translate([0,-5.5]) Hex(mm(5.5));
                        }   
                    }
                    rotate(bridge_arch_angle, VEC_Y)
                    translate([0,-5.5/2])
                    rotate(-cable_top_angle_vec_y(cable_nr), VEC_Y) {
                    rotate(-cable_top_angle_vec_x(cable_nr), VEC_X) {
                    
                    translate([0, 5.5])cube(5.5 * 2, true);
                    }}
                }
                translate([0,0,mm(-6)]) cylinder(d=3.0, h= bridge_arch_thickness_bottom, $fn=32);
            }
        }
    }
    
   
}
module CrossBeam03() {
    difference() {
        CrossBeam02();
        for(cable_nr = [0:bridge_cable_count-1]) {
            cable_bottom_transpose(cable_nr) {
                mirror(VEC_Z) translate([0,0,-3.2]) cylinder(d=6.3, h=26, $fn = 32);
                translate([0,0,-3])
                cylinder(d=3, h=20, $fn = 32);
            }
            translate([0, (bridge_width + bridge_cross_beam_width) / 2 + 1.7, 3.1]) {
                rotate(90, VEC_Y) {
                    cylinder(d=3.2, h=1001, $fn=32, center=true);
                    translate([0,0,500 - 3]) linear_extrude(20) Hex(d=5.6);
                    mirror(VEC_Z)translate([0,0,500 - 5.5]) cylinder(d=6.3, h=20, $fn=32);
                }
            }
        }
    }
}

module Hex(d) {
    intersection_for(a = [30,90,150]) rotate(a) square([d, d*2], true);
}


