include <../Bridge.inc>
use     <../Misc/PrintBed.scad>
use     <../Bridge/BridgeSegments.scad>
use     <../Bridge/Arch/ArchTenon.scad>

ArchTenonPart(true);

module ArchTenonPart(printable = false, explode_displacement = 0.0) {
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
            // TODO rotate flat
            rotate(90, VEC_X) {
                translate(-bridge_arch_tenon_origin(0)) {
                    ArchTenon(0);
                }
            }
        }
        PrintBed();
    } else {
        ArchTenon(0, explode_displacement);
    }
}
