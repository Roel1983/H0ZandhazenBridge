include <../Bridge.inc>
use     <../Misc/M3CounterSunkScrew.scad>

%Bridge(colored = false);
for (index = [0 : bridge_cable_count - 1]) {
    CableBottomAttachment(index);
    CableTopAttachment(index);
}

module CableBottomAttachment(index) {
    cable_bottom_transpose(index) {
        mirror(VEC_Z) translate([0,0,-2.7]) {
            linear_extrude(mm(20)) {
                Droplet(d = mm(6.3), a = 70, $fn=32);
            }
            //cylinder(d=6.3, h=26, $fn = 32);
        }
        translate([0,0,-3]) {
            linear_extrude(mm(20)) {
                Droplet(d = mm(3.1), a = 60, $fn=32);
            }
        }
    }
}
module CableTopAttachment(index) {
    cable_top_transpose(index) {
        render() translate([0,0,-7]) {
            rotate(-90) M3NutSlot(slot_length = mm(10));
            translate([0,0,mm(-5.5)]) {
                linear_extrude(bridge_arch_thickness_bottom) {
                    rotate(180) Droplet(d = mm(3.2), a = 60, $fn=32);
                }
            }
        }
    }
}
