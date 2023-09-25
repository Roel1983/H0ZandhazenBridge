include <../../Bridge.inc>
use     <../BridgeSegments.scad>
use     <../CableAttachment.scad>
use     <../CrossBeamArchScrew.scad>
use     <../SegmentCutPosition.scad>
use     <../Arch/ArchTenon.scad>
use     <../SeparatorBeam/SeperatorBeamScrew.scad>

explode_displacement = 2;
for (arch_index = [0 : bridge_arch_segment_count() - 1]) {
    ArchPart(arch_index, explode_displacement);
}

module ArchPart(arch_index, explode_displacement = 0.0) {
    translate(bridge_arch_segment_explode_displacement(arch_index) * explode_displacement) {
        difference() {
            ArchSegment(arch_index);
            Mortises();
            SeperateBeamScrews();
            intersection() {
                translate([0, mm(1), mm(-1)]) ArchSegment(arch_index, low_poly = true);
                union() {
                    CableAttachments();
                    ArchScrew();
                }
            }
        }
    }
    
    is_first_arch_segment = (arch_index == 0);
    is_last_arch_segment  = (arch_index == bridge_arch_segment_count() - 1);
    from_x = bridge_arch_segment_cut_location(arch_index + 0)[X];
    to_x   = bridge_arch_segment_cut_location(arch_index + 1)[X];
    
    module ArchScrew() {
        if (is_first_arch_segment) CrossBeamArchScrewHole(0, max_overhang_angle = 60);
        if (is_last_arch_segment)  CrossBeamArchScrewHole(1, max_overhang_angle = 60);
    }
    module Mortises() {
        if (!is_first_arch_segment) ArchMortise(arch_index - 1);
        if (!is_last_arch_segment)  ArchMortise(arch_index);
    }
    module CableAttachments() {
        for (cable_index = [0:bridge_cable_count-1]) {
            p = cable_top_position(cable_index);
            if (is_between(p[X], [from_x, to_x])) {
                CableTopAttachment(cable_index);
            }
        }
    }
    module SeperateBeamScrews() {
        for (index = [0:bridge_beam_count-1]) {
            p = arch_separator_beam_position(index);
            if (is_between(p[X], [from_x, to_x])) {
                SeperateBeamScrewHole(index);
            }
        }
    }
}
