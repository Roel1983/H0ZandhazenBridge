include <Bridge.inc>
include <Utils.inc>

cut_offset = 0;
arch_crossbeam_tolerance_xz = mm(0.1);
arch_crossbeam_tolerance_y  = mm(0.1);

// Arch segments
arch_segment_cuts_i = [
    -1.1,
    between(
        cable_top_position_i(0),
        cable_top_position_i(1)
    ),
    0
];
arch_segment_count = len(arch_segment_cuts_i) - 1;
function arch_segment_center(number) = let(
    i_from = arch_segment_cuts_i[number + 0],
    i_to   = arch_segment_cuts_i[number + 1],
    i      = between(i_from, i_to),
    xz     = bridge_arch_inner_point(i)
) [
    xz[0],
    bridge_arch_center_center_distance(i) / 2,
    xz[1]
];
function arch_segment_explode_displacement(number, exploded_view) = let(
    p = arch_segment_center(number)
) [
    p[X],
    p[Y] * 4,
    p[Z] * 2
] * exploded_view;

// Cross beam segments
cross_beam_segment_cuts_x = [
    -bridge_bounding_length / 2 * 1.1,
    between(
        cable_bottom_position(1)[X],
        cable_bottom_position(2)[X]
    ),
    0
];
cross_beam_segment_count = len(cross_beam_segment_cuts_x) - 1;
function cross_beam_segment_center(number) = [
    between(
        cross_beam_segment_cuts_x[number + 0],
        cross_beam_segment_cuts_x[number + 1]
    ),
    cross_beam_center_center_distance / 2,
    0
];
function cross_beam_segment_explode_displacement(number, exploded_view) = let(
    p = cross_beam_segment_center(number)
) [
    p[X],
    p[Y] * 1,
    p[Z] * 2
] * exploded_view;

// Preview
exploded_view = 0.1;
mirror_copy(VEC_X) mirror_copy(VEC_Y) {
    for (i = [0 : cross_beam_segment_count - 1]) {
        translate(cross_beam_segment_explode_displacement(i, exploded_view)) {
            CrossBeamSegment(i);
        }
    }
    
    translate([0, 0, bridge_height * exploded_view]) {
        for (i = [0 : arch_segment_count - 1]) {
            translate(arch_segment_explode_displacement(i, exploded_view)) {
                ArchSegment(i);
            }
        }
    }
}

// Arch Segment
module ArchSegment(number, offset_xz = 0, offset_y = 0) {
    assert(number >= 0 && number < arch_segment_count);
    
    i_from = arch_segment_cuts_i[number + 0];
    i_to   = arch_segment_cuts_i[number + 1];
    assert(i_from < i_to);
    
    difference() {
        intersection() {
            render(2) Arch();
            render() CutArea();
        }
        if(number == 0) CrossBeamInterface();
    }
    
    module CutArea() {
        mirror(VEC_Y)rotate(90, VEC_X) {
            linear_extrude(bridge_bounding_width / 2) {
                hull() {
                    translate(bridge_arch_inner_point(i_from)) {
                        rotate(bridge_arch_angle(i_from)) {
                            translate([ 0, -bridge_height]) {
                                square([1, 2*bridge_height]);
                            }
                        }
                    }
                    translate(bridge_arch_inner_point(i_to)) {
                        rotate(bridge_arch_angle(i_to)) {
                            translate([-1, -bridge_height]) {
                                square([1, 2*bridge_height]);
                            }
                        }
                    }
                }
            }
        }  
    }
    
    module CrossBeamInterface() {
        mirror_copy(VEC_X)
        translate([bridge_length / 2, bridge_width / 2]) {
            rotate(-bridge_arch_angle, VEC_X) cube([
                bridge_arch_thickness_bottom * 4,
                2 * (bridge_cross_beam_top - mm(2.5) - offset_xz),
                2 * (bridge_cross_beam_width - mm(0.5) - offset_y)
            ], true);
        }
    }
}

module CrossBeamSegment(number) {
    assert(number >= 0 && number < cross_beam_segment_count);
    
    x_from = cross_beam_segment_cuts_x[number + 0];
    x_to   = cross_beam_segment_cuts_x[number + 1];
    assert(x_from < x_to);
    
    difference() {
        intersection() {
            render(2) CrossBeam();
            render() CutArea();
        }
        if(number == 0) ArchSegment(number = 0, 
            offset_xz = arch_crossbeam_tolerance_xz,
            offset_y  = arch_crossbeam_tolerance_y
        );
    }
    
    module CutArea() {
        translate([
            x_from - cut_offset,
            0,
            bridge_cross_beam_bottom - bridge_cross_beam_height * .1
        ]) linear_extrude(bridge_cross_beam_height * 1.2) {
            square([
                x_to - x_from + 2 * cut_offset,
                bridge_bounding_width * 0.6]);
        }
    }
}
