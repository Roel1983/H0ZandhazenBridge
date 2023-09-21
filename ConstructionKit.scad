use <ArchPart.scad>
use <CrossBeamPart.scad>
use <CrossBeamTenon.scad>
use <SeparatorBeam0.scad>
use <SeparatorBeam1.scad>

explode_displacement = 25;

ArchPart     (0, explode_displacement = explode_displacement);
ArchPart     (1, explode_displacement = explode_displacement);
ArchPart     (2, explode_displacement = explode_displacement);
ArchPart     (3, explode_displacement = explode_displacement);
ArchPart     (4, explode_displacement = explode_displacement);

CrossBeamPart (0, explode_displacement = explode_displacement);
CrossBeamTenon(0, explode_displacement = explode_displacement);
CrossBeamPart (1, explode_displacement = explode_displacement);
CrossBeamTenon(1, explode_displacement = explode_displacement);
CrossBeamPart (2, explode_displacement = explode_displacement);
CrossBeamTenon(2, explode_displacement = explode_displacement);
CrossBeamPart (3, explode_displacement = explode_displacement);

SeparatorBeam0(explode_displacement = explode_displacement);
SeparatorBeam1(explode_displacement = explode_displacement);
