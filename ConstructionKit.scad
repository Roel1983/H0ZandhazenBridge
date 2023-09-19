use <ArchPart0.scad>
use <ArchPart1.scad>
use <ArchPart2.scad>
use <CrossBeamPart0.scad>
use <CrossBeamPart1.scad>
use <SeparatorBeam0.scad>
use <SeparatorBeam1.scad>

exploded_view = 0.01;

ArchPart0     (exploded_view = exploded_view);
ArchPart1     (exploded_view = exploded_view);
ArchPart2     (exploded_view = exploded_view);
CrossBeamPart0(exploded_view = exploded_view);
CrossBeamPart1(exploded_view = exploded_view);
SeparatorBeam0(exploded_view = exploded_view);
SeparatorBeam1(exploded_view = exploded_view);
