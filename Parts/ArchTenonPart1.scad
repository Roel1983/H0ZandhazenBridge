include <../Bridge.inc>
use     <../Misc/PrintBed.scad>
use     <../Bridge/BridgeSegments.scad>
use     <../Bridge/Arch/ArchTenon.scad>

ArchTenonPart1();

module ArchTenonPart1() {
    CROSS_BEAM_NUMBER = 1;
    
    echo("PRINTING INSTRUCTIONS");
    echo("  Quantity            : 4");
    echo("  Layer height        : 0.15 mm");
    echo("  Infill              : 15%");
    echo("  Brim                : no");
    echo("  Perimeters          : 3");
    echo("  Solid bottom layers : 8");
    echo("  Solid top layers    : 8");
    echo("  Modifiers           : TODO reenforcment");
    
    translate([mm(0), mm(-5), mm(5)]) rotate(-6) {
        rotate(bridge_arch_angle - 180, VEC_X) {
            translate(-bridge_arch_tenon_origin(CROSS_BEAM_NUMBER)) {
                ArchTenon(CROSS_BEAM_NUMBER);
            }
        }
    }
    PrintBed();
}
