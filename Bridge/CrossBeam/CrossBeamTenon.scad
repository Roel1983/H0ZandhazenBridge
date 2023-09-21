use     <../../Misc/Mortise.scad>
include <../../Misc/Utils.inc>
include <../../Bridge.inc>
use     <../BridgeSegments.scad>
use     <../SegmentCutPosition.scad>

mortise_config = mortise_config(
    length  = 45,
    width_1 = 13, width_2 = 8,
    thickness_1 = 6, thickness_2 = 4
);

%Bridge(colored = false);
CrossBeamTenon(0);
CrossBeamTenon(1);
CrossBeamTenon(2);

module CrossBeamTenon(index = 0, explode_displacement = 0.0) {
    translate(bridge_cross_beam_tenon_explode_displacement(index) * explode_displacement) {
        cross_beam_mortise_transform(index) {
            render() union() {
                Tenon(mortise_config);
                mirror(VEC_Y) Tenon(mortise_config);
            }
        }
    }
}

module CrossBeamMortise(index) {
    cross_beam_mortise_transform(index) {
        render() union() {
            Mortise(mortise_config);
            mirror(VEC_Y)Mortise(mortise_config);
        }
    }
}

module cross_beam_mortise_transform(index) {
    bridge_cross_beam_segment_cut_transform(index + 1) {
        translate([0,-1,2.75]) {
            rotate(-90, VEC_X) {
                rotate(90) {
                    children();
                }
            }
        }
    }
}

function bridge_cross_beam_tenon_explode_displacement(index) = between(
    bridge_cross_beam_segment_explode_displacement(index),
    bridge_cross_beam_segment_explode_displacement(index + 1)
);
function bridge_cross_beam_tenon_origin(index) = (
    bridge_cross_beam_segment_cut_location(index + 1)
);



