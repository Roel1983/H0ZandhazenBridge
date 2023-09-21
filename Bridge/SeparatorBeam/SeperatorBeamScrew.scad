include <../../Bridge.inc>
include <../../Misc/Utils.inc>

%Bridge(colored=false);
for (index = [0 : bridge_beam_count - 1]) {
    SeperateBeamScrewHole(index);
}

module SeperateBeamScrewHole(index) {
    SeperateBeamScrewTranspose(index) {
        bd = bridge_arch_separator_beam_diameter(index);
        d2 = mm(6.0);
        d1 = mm(3.0);
        rotate_extrude($fn = 32) polygon([
            [d2 / 2, -bd / 2 - mm(1)],
            [d2 / 2, -bd / 2 + mm(1)],
            [d1 / 2, -bd / 2 + mm(1) + (d2 - d1) / 2],
            [d1 / 2,  bd / 2 - mm(1)],
            [0,  bd /2 - mm(1)],
            [0, -bd / 2 - mm(1)]
        ]);
        translate([0, 0, mm(1.0)]) {
            linear_extrude(2.5) Hex(mm(5.5));
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