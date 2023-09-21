use<BridgeSegments.scad>
include <Bridge.inc>
use <PrintBed.scad>
use <SeparatorBeam.scad>

SeparatorBeam1(true);

module SeparatorBeam1(printable = false, explode_displacement = 0.0) {
    SEPARATOR_BEAM_NUMBER = 1;
    
    if(printable) {
        echo("PRINTING INSTRUCTIONS");
        echo("  Quantity            : 2");
        echo("  Layer height        : 0.1 mm");
        echo("  Infill              : 10%");
        echo("  Perimeters          : 3");
        echo("  Solid bottom layers : 8");
        echo("  Solid top layers    : 8");
        echo("  Pause to add nuts   : ???");
        echo("  Modifiers           : TODO reenforcment");
        
        translate([0, 0, bridge_arch_separator_beam_diameter(SEPARATOR_BEAM_NUMBER) / 2]) {
            rotate(90) {
                rotate(180 + bridge_arch_separator_beam_angle(SEPARATOR_BEAM_NUMBER), VEC_Y) {
                    translate(-bridge_separator_beam_segment_origin(SEPARATOR_BEAM_NUMBER)) {
                        SeparatorBeam(SEPARATOR_BEAM_NUMBER);
                    }
                }
            }
        }
        PrintBed();
    } else {
        SeparatorBeam(SEPARATOR_BEAM_NUMBER, explode_displacement);
    }
}