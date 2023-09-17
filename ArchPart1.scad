use<BridgeSegments.scad>
include <Bridge.inc>

ArchPart1(true);

module ArchPart1(printable = false, exploded_view = 0.0) {
    CROSS_BEAM_NUMBER = 1;
    
    if(printable) {
        rotate(bridge_arch_angle - 180, VEC_X) {
            translate(-arch_segment_center(CROSS_BEAM_NUMBER)) Part();
        }
    } else {
        translate(arch_segment_explode_displacement(CROSS_BEAM_NUMBER, exploded_view)) {
            Part();
        }
    }
    
    module Part() {
        ArchSegment(CROSS_BEAM_NUMBER);
    }
}
