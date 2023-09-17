use <ArchPart0.scad>
use <ArchPart1.scad>
use <CrossBeamPart0.scad>
use <CrossBeamPart1.scad>

exploded_view = 0.1;

ArchPart0     (exploded_view = exploded_view);
ArchPart1     (exploded_view = exploded_view);
CrossBeamPart0(exploded_view = exploded_view);
CrossBeamPart1(exploded_view = exploded_view);
