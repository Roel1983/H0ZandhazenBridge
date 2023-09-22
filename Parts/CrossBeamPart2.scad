include <../Bridge.inc>
use     <../Misc/PrintBed.scad>
use     <../Bridge/BridgeSegments.scad>
use     <../Bridge/CrossBeam/CrossBeamPart.scad>

CrossBeamPart2();

module CrossBeamPart2() {
    CROSS_BEAM_NUMBER = 2;
    
    echo("PRINTING INSTRUCTIONS");
    echo("  Quantity            : 2");
    echo("  Layer height        : 0.1 mm");
    echo("  Infill              : 10%");
    echo("  Brim                : yes");
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
}
