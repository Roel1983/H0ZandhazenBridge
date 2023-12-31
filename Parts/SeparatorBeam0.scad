include <../Bridge.inc>
use     <../Misc/PrintBed.scad>
use     <../Bridge/BridgeSegments.scad>
use     <../Bridge/SeparatorBeam/SeparatorBeam.scad>

SeparatorBeam0();

module SeparatorBeam0() {
    SEPARATOR_BEAM_NUMBER = 0;
    
    echo("PRINTING INSTRUCTIONS");
    echo("  Quantity            : 2");
    echo("  Layer height        : 0.1 mm");
    echo("  Infill              : 10%");
    echo("  Brim                : yes");
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
}