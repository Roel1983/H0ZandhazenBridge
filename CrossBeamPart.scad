use<BridgeSegments.scad>
use<SegmentCutPosition.scad>
include <Bridge.inc>
use <CrossBeamTenon.scad>
use <CableAttachment.scad>
use <CrossBeamArchScrew.scad>

explode_displacement = 2;
for (cross_beam_index = [0 : bridge_cross_beam_segment_count() - 1]) {
    CrossBeamPart(cross_beam_index, explode_displacement);
}

module CrossBeamPart(cross_beam_index, explode_displacement = 0.0) {
    translate(bridge_cross_beam_segment_explode_displacement(cross_beam_index) * explode_displacement) {
        difference() {
            CrossBeamSegment(cross_beam_index);
            Mortises();
            CableAttachments();
            ArchScrew();
            TableScrew();
        }
    }
    
    is_first_cross_beam_segment = (cross_beam_index == 0);
    is_last_cross_beam_segment  = (cross_beam_index == bridge_cross_beam_segment_count() - 1);
    from_x = bridge_cross_beam_segment_cut_location(cross_beam_index + 0)[X];
    to_x   = bridge_cross_beam_segment_cut_location(cross_beam_index + 1)[X];
    
    module ArchScrew() {
        if (is_first_cross_beam_segment) CrossBeamArchScrewHole(0);
        if (is_last_cross_beam_segment)  CrossBeamArchScrewHole(1);
    }
    module Mortises() {
        if (!is_first_cross_beam_segment) CrossBeamMortise(cross_beam_index - 1);
        if (!is_last_cross_beam_segment)  CrossBeamMortise(cross_beam_index);
    }
    module CableAttachments() {
        for (cable_index = [0:bridge_cable_count-1]) {
            p = cable_bottom_position(cable_index);
            if (is_between(p[X], [from_x, to_x])) {
                CableBottomAttachment(cable_index);
            }
        }
    }
    module TableScrew() {
        //if (is_first_cross_beam_segment) CrossBeamTableScrew(0);
        //if (is_last_cross_beam_segment)  CrossBeamTableScrew(1);
    }
}
