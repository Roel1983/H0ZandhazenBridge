include <Bridge.inc>
include <Utils.inc>
use <SegmentCutPosition.scad>

explode_displacement = 2.0;

if ($preview) {
    
    for (index = [0 : bridge_arch_segment_count() - 1]) {
        translate(bridge_arch_segment_explode_displacement(index) * explode_displacement) {
            ArchSegment(index);
        }
    }
    for (index = [0 : bridge_cross_beam_segment_count() - 1]) {
        translate(bridge_cross_beam_segment_explode_displacement(index) * explode_displacement) {
            CrossBeamSegment(index);
        }
    }
    for (index = [0 : bridge_separator_beam_segment_count() - 1]) {
        translate(bridge_separator_beam_segment_explode_displacement(index) * explode_displacement) {
            SeparatorBeamSegment(index);
        }
    }
}

// Config
separator_beam_wall         = nozzle(2);
separator_beam_tolerance    = mm(0.1);
arch_crossbeam_tolerance_xz = mm(0.1);
arch_crossbeam_tolerance_y  = mm(0.1);

// Bridge arch (printable sized) segment
function bridge_arch_segment_count() = bridge_arch_segment_cut_count() - 1;
function bridge_arch_segment_origin(index) = between(
    bridge_arch_segment_cut_location(index + 0),
    bridge_arch_segment_cut_location(index + 1)
);
function bridge_arch_segment_explode_displacement(index) = (
    assert(bridge_arch_segment_count() % 2 == 1, "not implemented for odd number of segments")
    let(center_index = (bridge_arch_segment_count() - 1) / 2)
    (index == center_index) ? [
        0,
        2,
        3
    ] : (index < center_index) ? (
        bridge_arch_segment_explode_displacement(index + 1)
        + (let(
            ay = bridge_arch_segment_cut_rotation_1y(index + 1),
            ax = bridge_arch_segment_cut_rotation_2x(index + 1)
        ) [
            2 * -cos(ay),
            2 * -sin(ax) * sin(ay),
            2 *  cos(ax) * sin(ay)
        ])
    ) : (
        bridge_arch_segment_explode_displacement(index - 1)
        + (let(
            ay = bridge_arch_segment_cut_rotation_1y(index),
            ax = bridge_arch_segment_cut_rotation_2x(index)
        ) [
            2 *  cos(ay),
            2 *  sin(ax) * sin(ay),
            2 * -cos(ax) * sin(ay)
        ])
    )
);

module ArchSegment(index, offset_xz = 0, offset_y = 0) {
    assert(index >= 0 && index < bridge_arch_segment_count());

    difference() {
        intersection() {
            render(2) Arch(offset_xz = offset_xz);
            render(0) CutArea();
        }
        if(index == 0 || index == bridge_arch_segment_count() - 1) {
            CrossBeamInterface();
        }
    }
    SeparatorBeams();
    
    module CutArea() {
        hull() {
            bridge_arch_segment_cut_transform(index) {
                rotate(90, VEC_Y) {
                    linear_extrude(1) square([
                        bridge_height * 2,
                        bridge_arch_width * 2
                    ], true);
                }
            }
            bridge_arch_segment_cut_transform(index + 1) {
                rotate(90, VEC_Y) {
                    mirror(VEC_Z) linear_extrude(1) square([
                        bridge_height * 2,
                        bridge_arch_width * 2
                    ], true);
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
    
    module SeparatorBeams() {
        for (beam_nr = [0:bridge_beam_count-1]) {
            if (is_between(
                    arch_separator_beam_position(beam_nr)[X],
                    [bridge_arch_segment_cut_location(index + 0)[X],
                     bridge_arch_segment_cut_location(index + 1)[X]]
            )) {
                Beam(beam_nr);
            }
        }
        
        module Beam(beam_nr) {
            intersection() {
                ArchSeparatorBeam(beam_nr);
                translate(arch_separator_beam_position(beam_nr)) {
                    rotate(-bridge_arch_separator_beam_angle(beam_nr), VEC_Y) {
                        
                        d1 = bridge_arch_separator_beam_diameter(beam_nr);
                        d2 = d1 - 2 * (separator_beam_wall + separator_beam_tolerance);
                        l = bridge_arch_separator_beam_length(beam_nr);
                        
                        translate([-d2 / 2, 0]) {
                            mirror(VEC_Z)linear_extrude(d1 * 0.6) square([
                                d2,
                                l / 2 * 1.1
                            ]);
                        }
                    }
                }
            }
        }
    }
}

// Bridge cross beam (printable sized) segment
function bridge_cross_beam_segment_count() = bridge_cross_beam_segment_cut_count() - 1;
function bridge_cross_beam_segment_origin(index) = between(
    bridge_cross_beam_segment_cut_location(index + 0),
    bridge_cross_beam_segment_cut_location(index + 1)
);
function bridge_cross_beam_segment_explode_displacement(index) = [
    4.2 * (index - (bridge_cross_beam_segment_cut_count() - 2) / 2),
    .5,
    0
];

module CrossBeamSegment(index) {
    difference() {
        intersection() {
            render(2) CrossBeam();
            render() CutArea();
        }
        if(index == 0) {
            ArchSegment(
                index = 0, 
                offset_xz = arch_crossbeam_tolerance_xz,
                offset_y  = arch_crossbeam_tolerance_y
            );
        }
        if(index == bridge_cross_beam_segment_count() - 1) {
            ArchSegment(
                index = bridge_arch_segment_count() - 1, 
                offset_xz = arch_crossbeam_tolerance_xz,
                offset_y  = arch_crossbeam_tolerance_y
            );
        }
    }
    
    module CutArea() {
        hull() {
            bridge_cross_beam_segment_cut_transform(index) {
                rotate(90, VEC_Y) {
                    linear_extrude(1) square([
                        bridge_height * 2,
                        bridge_arch_width * 2
                    ], true);
                }
            }
            bridge_cross_beam_segment_cut_transform(index + 1) {
                rotate(90, VEC_Y) {
                    mirror(VEC_Z) linear_extrude(1) square([
                        bridge_height * 2,
                        bridge_arch_width * 2
                    ], true);
                }
            }
        }
    }
}

// Bridge separator beam (printable sized) segment
function bridge_separator_beam_segment_count() = bridge_beam_count;
function bridge_separator_beam_segment_origin(index) = arch_separator_beam_position(index);
function bridge_separator_beam_arch_index(index) = (
    [for (arch_index = [0 : bridge_arch_segment_count() - 1])
     if (is_between(
            arch_separator_beam_position(index)[X],
            [bridge_arch_segment_cut_location(arch_index + 0)[X],
             bridge_arch_segment_cut_location(arch_index + 1)[X]]
      )) arch_index][0]
);

function bridge_separator_beam_segment_explode_displacement(index) = (
    let (
        p = bridge_arch_segment_explode_displacement(bridge_separator_beam_arch_index(index)),
        a = bridge_arch_separator_beam_angle(index)
    ) [
        p[X] - sin(a) * .5,
        0,
        p[Z] + cos(a) * .5
    ]
);
module SeparatorBeamSegment(index) {
    difference() {
        ArchSeparatorBeam(index);
        mirror_copy(VEC_Y) ArchFrontViewExtruded();
        translate(arch_separator_beam_position(index)) {
            rotate(-bridge_arch_separator_beam_angle(index), VEC_Y) {
                
                d1 = bridge_arch_separator_beam_diameter(index);
                d2 = d1 - 2 * (separator_beam_wall);
                l = bridge_arch_separator_beam_length(index);
                
                translate([-d2 / 2, -l*.6]) {
                    mirror(VEC_Z)linear_extrude(d1 * 0.6) square([
                        d2,
                        l * 1.2
                    ]);
                }
            }
        }
    }
}



    
//CutArea(2);


//
//cut_offset = 0;
//arch_crossbeam_tolerance_xz = mm(0.1);
//arch_crossbeam_tolerance_y  = mm(0.1);
//
//// Arch segments
//function bridge_arch_segment_cut_i(number) = (
//    [
//        -1.1,
//        between(
//            cable_top_position_i(0),
//            cable_top_position_i(1)
//        ), between(
//            cable_top_position_i(4),
//            cable_top_position_i(5)
//        ),between(
//            cable_top_position_i(6),
//            cable_top_position_i(7)
//        )
//    ][number]
//);
//function bridge_arch_segment_cut_count()     = 4;
//function bridge_arch_segment_count() = (
//    bridge_arch_segment_cut_count() - 1
//);
//function bridge_arch_segment_cut_loc(number) = (
//    bridge_arch_center_point(bridge_arch_segment_cut_i(number))
//);
//function bridge_arch_segment_cut_rotate(number) = (
//    bridge_arch_angle(bridge_arch_segment_cut_i(number))
//);
//
//function arch_segment_center(number) = let(
//    i_from = bridge_arch_segment_cut_i(number + 0),
//    i_to   = bridge_arch_segment_cut_i(number + 1),
//    i      = between(i_from, i_to),
//    xz     = bridge_arch_center_point(i)
//) [
//    xz[0],
//    bridge_arch_center_center_distance(i) / 2,
//    xz[1]
//];
//function arch_segment_explode_displacement(number, exploded_view) = let(
//    p = arch_segment_center(number)
//) [
//    p[X],
//    p[Y] * 4,
//    p[Z] * 2
//] * exploded_view;
//
//// Cross beam segments
//cross_beam_segment_cuts_x = [
//    -bridge_bounding_length / 2 * 1.1,
//    between(
//        cable_bottom_position(1)[X],
//        cable_bottom_position(2)[X]
//    ),
//    0
//];
//cross_beam_segment_count = len(cross_beam_segment_cuts_x) - 1;
//function cross_beam_segment_center(number) = [
//    between(
//        cross_beam_segment_cuts_x[number + 0],
//        cross_beam_segment_cuts_x[number + 1]
//    ),
//    cross_beam_center_center_distance / 2,
//    0
//];
//function cross_beam_segment_explode_displacement(number, exploded_view) = let(
//    p = cross_beam_segment_center(number)
//) [
//    p[X],
//    p[Y] * 1,
//    p[Z] * 2
//] * exploded_view;
//
//// Separator beam segments
//separator_beam_wall      = nozzle(2);
//separator_beam_tolerance = 0.1;
//separator_beam_segment_count = ceil(bridge_beam_count / 2);
//function separator_beam_segment_center(number) = arch_separator_beam_position(number);
//function separator_beam_segment_explode_displacement(number, exploded_view) = let (
//    p = separator_beam_segment_center(number)
//) [
//    p[X],
//    p[Y] * 4,
//    p[Z] * 4
//] * exploded_view;
//
//// Preview
//exploded_view = 0.1;
//mirror_copy(VEC_X) mirror_copy(VEC_Y) {
//    for (i = [0 : cross_beam_segment_count - 1]) {
//        translate(cross_beam_segment_explode_displacement(i, exploded_view)) {
//            CrossBeamSegment(i);
//        }
//    }
//    
//    for (i = [0 : bridge_arch_segment_count() - 1]) {
//        translate(arch_segment_explode_displacement(i, exploded_view)) {
//            ArchSegment(i);
//        }
//    }
//    
//    for (i = [0 : separator_beam_segment_count - 1]) {
//        translate(separator_beam_segment_explode_displacement(i, exploded_view)) {
//            SeparatorBeamSegment(i);
//        }
//    }
//}
//
//// Arch Segment
//module ArchSegment(number, offset_xz = 0, offset_y = 0) {
//    assert(number >= 0 && number < bridge_arch_segment_count());
//    
//    difference() {
//        intersection() {
//            render(2) Arch();
//            render() CutArea();
//        }
//        if(number == 0) CrossBeamInterface();
//    }
//    for (beam_nr = [0:bridge_beam_count-1]) {
//        if (is_between(
//                bridge_beam_locations[beam_nr],
//                [bridge_arch_segment_cut_i(number + 0),
//                 bridge_arch_segment_cut_i(number + 1)]
//        )) {
//            Beam(beam_nr);
//        }
//    }
//    
//    module CutArea() {
//        mirror(VEC_Y)rotate(bridge_arch_angle, VEC_X) {
//            linear_extrude(bridge_bounding_width) {
//                hull() {
//                    translate(bridge_arch_segment_cut_loc(number + 0)) {
//                        rotate(bridge_arch_segment_cut_rotate(number + 0)) {
//                            translate([ 0, -bridge_height]) {
//                                square([1, 2*bridge_height]);
//                            }
//                        }
//                    }
//                    translate(bridge_arch_segment_cut_loc(number + 1)) {
//                        rotate(bridge_arch_segment_cut_rotate(number + 1)) {
//                            translate([-1, -bridge_height]) {
//                                square([1, 2*bridge_height]);
//                            }
//                        }
//                    }
//                }
//            }
//        }  
//    }
//    
//    module CrossBeamInterface() {
//        mirror_copy(VEC_X)
//        translate([bridge_length / 2, bridge_width / 2]) {
//            rotate(-bridge_arch_angle, VEC_X) cube([
//                bridge_arch_thickness_bottom * 4,
//                2 * (bridge_cross_beam_top - mm(2.5) - offset_xz),
//                2 * (bridge_cross_beam_width - mm(0.5) - offset_y)
//            ], true);
//        }
//    }
//    module Beam(beam_nr) {
//        intersection() {
//            ArchSeparatorBeam(beam_nr);
//            translate(arch_separator_beam_position(beam_nr)) {
//                rotate(-bridge_arch_separator_beam_angle(beam_nr), VEC_Y) {
//                    
//                    d1 = bridge_arch_separator_beam_diameter(beam_nr);
//                    d2 = d1 - 2 * (separator_beam_wall + separator_beam_tolerance);
//                    l = bridge_arch_separator_beam_length(beam_nr);
//                    
//                    translate([-d2 / 2, 0]) {
//                        mirror(VEC_Z)linear_extrude(d1 * 0.6) square([
//                            d2,
//                            l / 2 * 1.1
//                        ]);
//                    }
//                }
//            }
//        }
//    }
//}
//
//module CrossBeamSegment(number) {
//    assert(number >= 0 && number < cross_beam_segment_count);
//    
//    x_from = cross_beam_segment_cuts_x[number + 0];
//    x_to   = cross_beam_segment_cuts_x[number + 1];
//    assert(x_from < x_to);
//    
//    difference() {
//        intersection() {
//            render(2) CrossBeam();
//            render() CutArea();
//        }
//        if(number == 0) ArchSegment(number = 0, 
//            offset_xz = arch_crossbeam_tolerance_xz,
//            offset_y  = arch_crossbeam_tolerance_y
//        );
//    }
//    
//    module CutArea() {
//        translate([
//            x_from - cut_offset,
//            0,
//            bridge_cross_beam_bottom - bridge_cross_beam_height * .1
//        ]) linear_extrude(bridge_cross_beam_height * 1.2) {
//            square([
//                x_to - x_from + 2 * cut_offset,
//                bridge_bounding_width * 0.6]);
//        }
//    }
//}
//
//module SeparatorBeamSegment(number)  {
//    difference() {
//        ArchSeparatorBeam(number);
//        mirror_copy(VEC_Y) ArchFrontViewExtruded();
//        translate(arch_separator_beam_position(number)) {
//            rotate(-bridge_arch_separator_beam_angle(number), VEC_Y) {
//                
//                d1 = bridge_arch_separator_beam_diameter(number);
//                d2 = d1 - 2 * (separator_beam_wall);
//                l = bridge_arch_separator_beam_length(number);
//                
//                translate([-d2 / 2, -l*.6]) {
//                    mirror(VEC_Z)linear_extrude(d1 * 0.6) square([
//                        d2,
//                        l * 1.2
//                    ]);
//                }
//            }
//        }
//    }
//}