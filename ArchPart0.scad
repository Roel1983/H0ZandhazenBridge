use<BridgeSegments.scad>
include <Bridge.inc>
use <PrintBed.scad>

ArchPart0(true);

module ArchPart0(printable = false, exploded_view = 0.0) {
    CROSS_BEAM_NUMBER = 0;
    
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
        
        translate([mm(-15), mm(-10), bridge_arch_width / 2]) rotate(-32) {
            rotate(bridge_arch_angle - 180, VEC_X) {
                translate(-arch_segment_center(CROSS_BEAM_NUMBER)) Part();
            }
        }
        PrintBed();
    } else {
        translate(arch_segment_explode_displacement(CROSS_BEAM_NUMBER, exploded_view)) {
            Part();
        }
    }
    
    module Part() {
        ArchSegment(CROSS_BEAM_NUMBER);
    }
}
