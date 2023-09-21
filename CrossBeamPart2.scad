use<BridgeSegments.scad>
include <Bridge.inc>
use <PrintBed.scad>
use <CrossBeamPart.scad>

CrossBeamPart2(true);

module CrossBeamPart2(printable = false, explode_displacement = 0.0) {
    CROSS_BEAM_NUMBER = 2;
    
    if(printable) {
        echo("PRINTING INSTRUCTIONS");
        echo("  Quantity            : 2");
        echo("  Layer height        : 0.1 mm");
        echo("  Infill              : 10%");
        echo("  Perimeters          : 3");
        echo("  Solid bottom layers : 8");
        echo("  Solid top layers    : 8");
        echo("  Modifiers           : TODO reenforcment");
        
        translate([0, 0, bridge_cross_beam_width / 2]) {
            rotate(90, VEC_X) {
                translate(-bridge_cross_beam_segment_origin(CROSS_BEAM_NUMBER)) {
                    CrossBeamPart(CROSS_BEAM_NUMBER);
                }
            }
        }
        PrintBed();
    } else {
        CrossBeamPart(CROSS_BEAM_NUMBER, explode_displacement);
    }
}
