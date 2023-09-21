include <Bridge.inc>
include <Utils.inc>

// Preview
if ($preview) {
    %Bridge(colored = false);
    for (i = [0 : bridge_arch_segment_cut_count() - 1]) {
        bridge_arch_segment_cut_transform(i) OrientationArrows();
    }
    for (i = [0 : bridge_cross_beam_segment_cut_count() - 1]) {
        bridge_cross_beam_segment_cut_transform(i) OrientationArrows();
    }
}

// Cut positions
bridge_arch_segment_cut_i_array = [
    -1.05,
    between(
        cable_top_position_i(0),
        cable_top_position_i(1)),
    between(
        cable_top_position_i(4),
        cable_top_position_i(5)),
    between(
        cable_top_position_i(bridge_cable_count - 6),
        cable_top_position_i(bridge_cable_count - 5)),
    between(
        cable_top_position_i(bridge_cable_count - 2),
        cable_top_position_i(bridge_cable_count - 1)),
    1.05
];
bridge_cross_beam_segment_cut_x_array = [
    -bridge_bounding_length / 2 * 1.01,
    between(
        cable_bottom_position(1)[X],
        cable_bottom_position(2)[X]),
    0,
    between(
        cable_bottom_position(bridge_cable_count - 3)[X],
        cable_bottom_position(bridge_cable_count - 2)[X]
    ),
    bridge_bounding_length / 2 * 1.01
];

// Bridge arch (printable sized) segment cuts
function bridge_arch_segment_cut_count() = (
    len(bridge_arch_segment_cut_i_array)
);
function bridge_arch_segment_cut_location(index) = (
    let(
        p = bridge_arch_center_point(bridge_arch_segment_cut_i_array[index])
    ) [
        /* [X]= */ (
            p[X]
        ),
        /* [Y]= */ (
            bridge_arch_distance_bottom / 2 
            - cos(bridge_arch_angle) * p[Y]
            + sin(bridge_arch_angle) * bridge_arch_width / 2
        ),
        /* [Z]= */ (
            sin(bridge_arch_angle) * p[Y]
            + cos(bridge_arch_angle) * bridge_arch_width / 2
        )
    ]
);
function bridge_arch_segment_cut_rotation_1y(index) = (
    -bridge_arch_angle(bridge_arch_segment_cut_i_array[index])
);
function bridge_arch_segment_cut_rotation_2x(index) = (
    90 - bridge_arch_angle
);
module bridge_arch_segment_cut_transform(index) {
    translate(bridge_arch_segment_cut_location(index)) {
        rotate(bridge_arch_segment_cut_rotation_2x(index), VEC_X) {
            rotate(bridge_arch_segment_cut_rotation_1y(index), VEC_Y) {
                children();
            }
        }
    }
}

// Cross beam (printable sized) segment cuts
function bridge_cross_beam_segment_cut_count() = (
    len(bridge_cross_beam_segment_cut_x_array)
);
function bridge_cross_beam_segment_cut_location(index) = [
    bridge_cross_beam_segment_cut_x_array[index],
    (bridge_width + bridge_cross_beam_width) / 2,
    0
];
module bridge_cross_beam_segment_cut_transform(index) {
    translate(bridge_cross_beam_segment_cut_location(index)) {
        children();
    }
}
