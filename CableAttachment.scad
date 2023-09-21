include <Bridge.inc>

%Bridge(colored = false);
%for (index = [0 : bridge_cable_count - 1]) {
    CableBottomAttachment(index);
}

module CableBottomAttachment(index) {
    cable_bottom_transpose(index) {
        mirror(VEC_Z) translate([0,0,-2.7]) cylinder(d=6.3, h=26, $fn = 32);
        translate([0,0,-3])
        cylinder(d=3, h=20, $fn = 32);
    }
}
