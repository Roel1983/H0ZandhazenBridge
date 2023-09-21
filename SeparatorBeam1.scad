use<BridgeSegments.scad>
include <Bridge.inc>

SeparatorBeam1(true);

module SeparatorBeam1(printable = false, explode_displacement = 0.0) {
    SEPARATOR_BEAM_NUMBER = 1;
    
    if(printable) {
        rotate(180 + bridge_arch_separator_beam_angle(SEPARATOR_BEAM_NUMBER), VEC_Y) {
            translate(-separator_beam_segment_center(SEPARATOR_BEAM_NUMBER)) Part();
        }
    } else {
        translate(bridge_separator_beam_segment_explode_displacement(SEPARATOR_BEAM_NUMBER) * explode_displacement) {
            Part();
        }
    }
    
    module Part() {
        SeparatorBeamSegment(SEPARATOR_BEAM_NUMBER);
    }
}