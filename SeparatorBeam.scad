use<BridgeSegments.scad>
include <Bridge.inc>
use<SeperateBeamScrew.scad>

%Bridge(colored=false);
for (index = [0 : bridge_beam_count - 1]) {
    SeparatorBeam(index);
}

module SeparatorBeam(index, explode_displacement = 0.0) {
    translate(bridge_separator_beam_segment_explode_displacement(index) * explode_displacement) {
        difference() {
            SeparatorBeamSegment(index);
            SeperateBeamScrewHole(index);
        }
    }
}
