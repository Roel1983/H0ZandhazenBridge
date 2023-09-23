include <../../Bridge.inc>
include <../../Misc/Utils.inc>
use     <../../Misc/M3CounterSunkScrew.scad>

%Bridge(colored=false);
for (index = [0 : bridge_beam_count - 1]) {
    SeperateBeamScrewHole(index);
}

module SeperateBeamScrewHole(index) {
    SeperateBeamScrewTranspose(index) {
        bd = bridge_arch_separator_beam_diameter(index);
        translate([0,0,-bd/2]) {
            M3CounterSunkScrewHole(length = mm(10.2));
        }
        translate([0,0,mm(1)]) {
            M3NutHole();
        }
    }
}

module SeperateBeamScrewTranspose(index) {
    translate(arch_separator_beam_position(index)) {
        rotate(-bridge_arch_separator_beam_angle(index), VEC_Y) {
            mirror_copy(VEC_Y) {
                translate([0, (bridge_arch_separator_beam_length(index) - bridge_arch_width) / 4 + mm(0.4)]) {
                    children();
                }
            }
        }
    }
}