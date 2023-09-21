use<BridgeSegments.scad>
include <Bridge.inc>
use <PrintBed.scad>
use <ArchPart.scad>

ArchPart4(true);

module ArchPart4(printable = false, explode_displacement = 0.0) {
    CROSS_BEAM_NUMBER = 4;
    
    if(printable) {
        echo("PRINTING INSTRUCTIONS");
        echo("  Quantity            : 2");
        echo("  Layer height        : 0.1 mm");
        echo("  Infill              : 10%");
        echo("  Perimeters          : 3");
        echo("  Solid bottom layers : 8");
        echo("  Solid top layers    : 8");
        echo("  pause to add nuts   : 13mm");
        echo("  Modifiers           : TODO reenforcment");
        
        translate([mm(0), mm(-5), bridge_arch_width / 2]) rotate(32) {
            rotate(bridge_arch_angle - 180, VEC_X) {
                translate(-bridge_arch_segment_origin(CROSS_BEAM_NUMBER)) {
                    ArchPart(CROSS_BEAM_NUMBER);
                }
            }
        }
        PrintBed();
    } else {
        ArchPart(CROSS_BEAM_NUMBER, explode_displacement);
    }
}
