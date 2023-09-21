include <../Bridge.inc>

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
                        translate([0,-10]) Hex(mm(5.5));
                    }   
                }
            }
            translate([0,0,mm(-5.5)]) cylinder(d=3.0, h= bridge_arch_thickness_bottom, $fn=32);
        }
    }
}
