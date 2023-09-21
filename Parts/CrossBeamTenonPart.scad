include <../Bridge.inc>
use     <../Misc/PrintBed.scad>
use     <../Bridge/BridgeSegments.scad>
use     <../Bridge/CrossBeam/CrossBeamTenon.scad>

CrossBeamTenonPart(true);

module CrossBeamTenonPart(printable = false, explode_displacement = 0.0) {
    CROSS_BEAM_NUMBER = 0;
    
    if(printable) {
        echo("PRINTING INSTRUCTIONS");
        echo("  Quantity            : 3");
        echo("  Layer height        : 0.1 mm");
        echo("  Infill              : 10%");
        echo("  Brim                : no");
        echo("  Perimeters          : 3");
        echo("  Solid bottom layers : 8");
        echo("  Solid top layers    : 8");
        echo("  Modifiers           : TODO reenforcment");
        
        translate([mm(0), mm(0), mm(1)]) {
            rotate(90, VEC_X) {
                translate(-bridge_cross_beam_tenon_origin(0)) {
                    CrossBeamTenon(0);
                }
            }
        }
        PrintBed();
    } else {
        CrossBeamTenon(0, explode_displacement);
    }
}
