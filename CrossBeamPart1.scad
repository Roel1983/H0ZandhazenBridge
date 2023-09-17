use<BridgeSegments.scad>
include <Bridge.inc>

CrossBeamPart1(true);

module CrossBeamPart1(printable = false, exploded_view = 0.0) {
    CROSS_BEAM_NUMBER = 1;
    
    if(printable) {
        rotate(90, VEC_X) {
            translate(-cross_beam_segment_center(CROSS_BEAM_NUMBER)) {
                Part();
            }
        }
    } else {
        Part();
    }
    
    module Part() {
        translate(cross_beam_segment_explode_displacement(CROSS_BEAM_NUMBER, exploded_view)) {
            CrossBeamSegment(CROSS_BEAM_NUMBER);
        }
    }
}
