use<BridgeSegments.scad>
include <Bridge.inc>

SeparatorBeam0(true);

module SeparatorBeam0(printable = false, exploded_view = 0.0) {
    SEPARATOR_BEAM_NUMBER = 0;
    
    if(printable) {
        rotate(180 + bridge_arch_separator_beam_angle(SEPARATOR_BEAM_NUMBER), VEC_Y) {
            translate(-separator_beam_segment_center(SEPARATOR_BEAM_NUMBER)) Part();
        }
    } else {
        translate(separator_beam_segment_explode_displacement(SEPARATOR_BEAM_NUMBER, exploded_view)) {
            Part();
        }
    }
    
    module Part() {
        SeparatorBeamSegment(SEPARATOR_BEAM_NUMBER);
    }
}