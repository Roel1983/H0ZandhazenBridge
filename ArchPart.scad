use<BridgeSegments.scad>
use<SegmentCutPosition.scad>
include <Bridge.inc>
use <ArchTenon.scad>
use <CableAttachment.scad>

explode_displacement = 2;
for (arch_index = [0 : bridge_arch_segment_count() - 1]) {
    ArchPart(arch_index, explode_displacement);
}


module ArchPart(arch_index, explode_displacement = 0.0) {
    translate(bridge_arch_segment_explode_displacement(arch_index) * explode_displacement) {
        difference() {
            ArchSegment(arch_index);
        }
    }
}
