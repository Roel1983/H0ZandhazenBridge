use<BridgeSegments.scad>
include <Bridge.inc>
use <PrintBed.scad>

SeparatorBeam0(true);

module SeparatorBeam0(printable = false, explode_displacement = 0.0) {
    SEPARATOR_BEAM_NUMBER = 0;
    
    if(printable) {
        rotate(90) {
            rotate(180 + bridge_arch_separator_beam_angle(SEPARATOR_BEAM_NUMBER), VEC_Y) {
                translate(-bridge_separator_beam_segment_origin(SEPARATOR_BEAM_NUMBER)) Part();
            }
        }
        PrintBed();
    } else {
        translate(bridge_separator_beam_segment_explode_displacement(SEPARATOR_BEAM_NUMBER) * explode_displacement) {
            Part();
        }
    }
    
    module Part() {
        SeparatorBeamSegment(SEPARATOR_BEAM_NUMBER);
    }
}