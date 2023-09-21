use <Arch/ArchPart.scad>
use <Arch/ArchTenon.scad>
use <CrossBeam/CrossBeamPart.scad>
use <CrossBeam/CrossBeamTenon.scad>
use <SeparatorBeam/SeparatorBeam.scad>

explode_displacement = 25;

ArchPart     (0, explode_displacement = explode_displacement);
ArchTenon    (0, explode_displacement = explode_displacement);
ArchPart     (1, explode_displacement = explode_displacement);
ArchTenon    (1, explode_displacement = explode_displacement);
ArchPart     (2, explode_displacement = explode_displacement);
ArchTenon    (2, explode_displacement = explode_displacement);
ArchPart     (3, explode_displacement = explode_displacement);
ArchTenon    (3, explode_displacement = explode_displacement);
ArchPart     (4, explode_displacement = explode_displacement);

CrossBeamPart (0, explode_displacement = explode_displacement);
CrossBeamTenon(0, explode_displacement = explode_displacement);
CrossBeamPart (1, explode_displacement = explode_displacement);
CrossBeamTenon(1, explode_displacement = explode_displacement);
CrossBeamPart (2, explode_displacement = explode_displacement);
CrossBeamTenon(2, explode_displacement = explode_displacement);
CrossBeamPart (3, explode_displacement = explode_displacement);

SeparatorBeam(0, explode_displacement = explode_displacement);
SeparatorBeam(1, explode_displacement = explode_displacement);
SeparatorBeam(2, explode_displacement = explode_displacement);
SeparatorBeam(3, explode_displacement = explode_displacement);
