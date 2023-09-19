use<BridgeSegments.scad>
include <Bridge.inc>
use <PrintBed.scad>

CrossBeamPart1(true);

module CrossBeamPart1(printable = false, exploded_view = 0.0) {
    CROSS_BEAM_NUMBER = 1;
    
    if(printable) {
        echo("QUANTITY");
        echo("  2 x normal");
        echo("  2 x mirrored on x-axis");
        echo();
        echo("PRINTING INSTRUCTIONS");
        echo("  Layer height        : 0.1 mm");
        echo("  Infill              : 10%");
        echo("  Perimeters          : 3");
        echo("  Solid bottom layers : 8");
        echo("  Solid top layers    : 8");
        echo("  Modifiers           : TODO reenforcment");
        
        translate([0, 0, bridge_cross_beam_width / 2]) {
            rotate(90, VEC_X) {
                translate(-cross_beam_segment_center(CROSS_BEAM_NUMBER)) {
                    Part();
                }
            }
        }
        PrintBed();
    } else {
        Part();
    }
    
    module Part() {
        translate(cross_beam_segment_explode_displacement(CROSS_BEAM_NUMBER, exploded_view)) {
            CrossBeamSegment(CROSS_BEAM_NUMBER);
        }
    }
}
