include <Utils.inc>
include <Bridge.inc>

Bridge();
Heads();

module Bridge(colored = true) {
    Report();
    Color("white")    Arches();
    Color("white")    ArchSeparatorBeams();
    Color("SteelBlue")CrossBeams();
    Color("white")    Cables();
    Color("DimGray")  Deck();
    
    module Color(c) {
        if (colored) {
            color(c) children();
        } else {
            children();
        }
    }
}

module Heads() {
    color("SaddleBrown", alpha = 0.25) {
        mirror_copy(VEC_X) {
            translate([bridge_length /2 + bridge_head_length, 0, -bridge_head_length/2]) {
                cube([2 * bridge_head_length, bridge_bounding_width * 1.5, bridge_head_length],true);
            }
        }
    }
}

// Arch functions
function bridge_arch_point_1(i) = [
    i * bridge_length / 2,
    (catenary(1, bridge_arch_catenary_a) - catenary(i, bridge_arch_catenary_a)) * bridge_length / 2
];
function bridge_arch(i, offset = 0) = (
    let(angle = bridge_arch_angle(i) + 90)
    bridge_arch_point_1(i)
    + [offset * cos(angle), offset * sin(angle)]
);
function bridge_arch_angle(i) = (
    let(
        d = 0.001,
        p1 = bridge_arch_point_1(i - d),
        p2 = bridge_arch_point_1(i + d)
    )
    atan((p2[Y] - p1[Y]) / (p2[X] - p1[X]))
);
function bridge_arch_thickness(i) = (
    let (f = bridge_arch_point_1(i)[Y] / bridge_arch_point_1(0)[Y])
    bridge_arch_thickness_top * f
    + bridge_arch_thickness_bottom * (1 - f)
);

function bridge_arch_outer_point(i, offset = 0)  = (
    assert(is_num(offset))
    bridge_arch(i, offset = bridge_arch_thickness(i) + offset)
);
function bridge_arch_center_point(i) = bridge_arch(i, offset = bridge_arch_thickness(i) / 2);
function bridge_arch_inner_point(i, offset = 0)  = (
    assert(is_num(offset))
    bridge_arch(i, offset = -offset)
);

function bridge_arch_center_center_distance(i) = (
    let(j = bridge_arch_center_point(i)[Y] / bridge_arch_outer_point(0)[Y])
    bridge_arch_distance_top * j + bridge_arch_distance_bottom * (1 - j) + bridge_arch_width
);
function bridge_arch_inner_center_distance(i) = (
    let(j = bridge_arch_inner_point(i)[Y] / bridge_arch_outer_point(0)[Y])
    bridge_arch_distance_top * j + bridge_arch_distance_bottom * (1 - j) + bridge_arch_width
);

// Arch separator beam functions
function arch_separator_beam_position(beam_nr) = (
    assert(beam_nr >= 0 && beam_nr < bridge_beam_count, str("beam_nr = ", beam_nr))
    let(p = bridge_arch_center_point(bridge_beam_locations[beam_nr]))
    [p[X], 0, p[Y]]
);
function bridge_arch_separator_beam_angle(beam_nr) = (
    bridge_arch_angle(bridge_beam_locations[beam_nr])
);
function bridge_arch_separator_beam_diameter(beam_nr) = (
    bridge_arch_thickness(bridge_beam_locations[beam_nr]) - 2 * bridge_beam_indent
);
function bridge_arch_separator_beam_length(beam_nr) = (
    bridge_arch_center_center_distance(bridge_beam_locations[beam_nr])
);

// Cable functions
function cable_bottom_position(cable_nr) = [
    -bridge_cable_distance1 * (bridge_cable_count - 2) / 4 +
    bridge_cable_distance1 * floor (cable_nr / 2) + 
    bridge_cable_distance2 * (((cable_nr % 2) == 0) ? -.5 : .5),
    (bridge_width + bridge_cross_beam_width) / 2,
    bridge_cross_beam_top / 2
];
function cable_top_position_i(cable_nr) = (
    let(
        ix = -bridge_cable_distance1 * (bridge_cable_count - 2) / 4 +
            bridge_cable_distance1 * floor (cable_nr / 2) + 
            (bridge_cable_distance1 - bridge_cable_distance2) * (((cable_nr % 2) == 0) ? -.5 : .5)
    ) 2 * ix / bridge_length
);
function cable_top_position(cable_nr) = (
    let(
        i = cable_top_position_i(cable_nr),
        xz = bridge_arch_inner_point(i)
        
    ) [
        xz[0],
        bridge_arch_inner_center_distance(i) / 2,
        xz[1]
    ]
);
function cable_length(cable_nr) = (
    norm(cable_top_position(cable_nr) - cable_bottom_position(cable_nr))
);
function cable_bottom_angle_vec_y(cable_nr) = (
    let(
        p1 = cable_bottom_position(cable_nr),
        p2 = cable_top_position(cable_nr),
        pd = p1 - p2
    )
    -asin(pd[X] / cable_length(cable_nr))
);
function cable_bottom_angle_vec_x(cable_nr) = (
    let(
        p1 = cable_bottom_position(cable_nr),
        p2 = cable_top_position(cable_nr),
        pd = p1 - p2
    )
    -atan(pd[Y] / pd[Z]) 
); 
function cable_top_angle_vec_y(cable_nr) = (
    assert(cable_nr >= 0 && cable_nr < bridge_cable_count, str("cable_nr = ", cable_nr))
    cable_bottom_angle_vec_y(cable_nr) - 180
);
function cable_top_angle_vec_x(cable_nr) = (
    assert(cable_nr >= 0 && cable_nr < bridge_cable_count, str("cable_nr = ", cable_nr))
    cable_bottom_angle_vec_x(cable_nr)
);

module cable_bottom_transpose(cable_nr) {
    assert(is_num(cable_nr));
    assert(cable_nr >= 0 && cable_nr < bridge_cable_count, str("cable_nr = ", cable_nr));
    translate(cable_bottom_position(cable_nr)) {
        rotate(cable_bottom_angle_vec_x(cable_nr), VEC_X) {
            rotate(cable_bottom_angle_vec_y(cable_nr), VEC_Y) {
                children();
            }
        }
    }
}
module cable_top_transpose(cable_nr) {
    translate(cable_top_position(cable_nr)) {
        rotate(cable_top_angle_vec_x(cable_nr), VEC_X) {
            rotate(cable_top_angle_vec_y(cable_nr), VEC_Y) {
                children();
            }
        }
    }
}

module Report() {
    function calc_cable_stats(cable_nr = 0) = (
        let(
            length = cable_length(cable_nr)
        ) (cable_nr < bridge_cable_count - 1) ? (
            let(
                cable_stats = calc_cable_stats(cable_nr + 1)
            )[
                min(length, cable_stats[0]),
                max(length, cable_stats[1]),
                length + cable_stats[2]
            ]
        ) : [
            length, // min
            length, // max
            length, // sum
        ]
    );
    cable_stats = calc_cable_stats();
    
    echo("---------------------------------------------");
    echo(str("Scale:            1/", round_decimals(1 / SCALE)));
    echo(str("Bridge length:    ", length_to_string(bridge_length)));
    echo(str("Bridge height:    ", length_to_string(bridge_height)));
    echo(str("Arch angle:       ", round_decimals(bridge_arch_angle), "°"));
    echo(str("Cable diameter:   ", length_to_string(bridge_cable_diameter)));
    echo(str("Shortest cable:   ", length_to_string(cable_stats[0])));
    echo(str("Longest cable:    ", length_to_string(cable_stats[1])));
    echo(str("Total cable:      ", length_to_string(cable_stats[2] * 2)));
    echo(str("Bounding length:  ", length_to_string(bridge_bounding_length)));
    echo(str("Bounding width:   ", length_to_string(bridge_bounding_width)));
    echo("---------------------------------------------");
}

module Arches() {
    mirror_copy(VEC_Y) {
        Arch();
    }
}

module Arch(offset_xz = 0, offset_y = 0, low_poly = false) {
    intersection() {
        ArchSideViewExtruded(offset_xz = offset_xz, offset_y = offset_y, low_poly = low_poly);
        ArchFrontViewExtruded(offset_xz = offset_xz, offset_y = offset_y);
    }
}
module ArchFrontViewExtruded(offset_xz = 0, offset_y = 0) {
    rotate(90, VEC_Y) rotate(90) {
        linear_extrude(
            bridge_bounding_length,
            center = true,
            convexity = 2
        ) {
            ArchFrontView(offset_xz = offset_xz, offset_y = 0);
        }
    }
    
    module ArchFrontView(offset_xz = 0, offset_y = 0) {
        length = norm([bridge_height, bridge_arch_overhang]);

        mirror(VEC_X) {
            translate([-bridge_arch_distance_bottom / 2, 0]) {
                rotate(bridge_arch_angle) {
                    translate([-bridge_arch_width, -offset_y]) {
                        square([length + bridge_arch_width, bridge_arch_width + 2 * offset_y]);
                    }
                }
            }
        }
    }
}

module ArchSideViewExtruded(offset_xz = 0, offset_y = 0, low_poly = false) {
    rotate(90, VEC_X) {
        linear_extrude(
            bridge_bounding_width * 1.1, center = true, convexity = 2
        ) {
            ArchSideView(low_poly = low_poly);
        }
    }
    module ArchSideView(low_poly = false) {
        f = 1.05;
        g = bridge_arch_outer_point(f)[X];
        step = (low_poly || $preview) ? 0.1 : 0.001;
        points = concat(
            [for(i = [-1.0 : step : 1.0]) bridge_arch_outer_point(i * f, offset = offset_xz)],
            [for(i = [ 1.0 :-step :-1.0]) bridge_arch_inner_point(i * f, offset = offset_xz)]
        );
        intersection() {
            polygon(points);
            translate([-g, -offset_xz]) square([2 * g, bridge_height + 2 * offset_xz]);
        }
    }
}

module ArchSeparatorBeams() {
    for (i = [0:bridge_beam_count-1]) {
        ArchSeparatorBeam(i);
    }
}
module ArchSeparatorBeam(beam_nr) {
    translate(arch_separator_beam_position(beam_nr)) {
        rotate(-bridge_arch_separator_beam_angle(beam_nr), VEC_Y) {
            d = bridge_arch_separator_beam_diameter(beam_nr);
            l = bridge_arch_separator_beam_length(beam_nr);
            cube([d, l, d], true);
        }
    }
}

module CrossBeams() {
    mirror_copy(VEC_Y) CrossBeam();
}
module CrossBeam() {
    translate([0, bridge_width / 2]) {
        difference() {
            rotate(90, VEC_Y)rotate(90) {
                linear_extrude(bridge_bounding_length, center=true, convexity = 3) {
                    CrossBeamProfile();
                }
            }
            mirror_copy(VEC_X) Head();
        }
    }
    
    module Head() {
        bias = 0.01;
        mirror(VEC_Z) linear_extrude(bridge_deck_thickness + bridge_deck_rim_thickness + bias)
        translate([bridge_length / 2, -bridge_deck_indent + bridge_deck_indent - bias]) {
            square([
                bridge_head_length + bias,
                bridge_cross_beam_width + bridge_deck_indent]);
        }
    }
}

module CrossBeamProfile() {
    polygon([
        [0, bridge_cross_beam_bottom],
        [0, -bridge_deck_thickness],
        [bridge_deck_indent, -bridge_deck_thickness],
        [bridge_deck_indent, 0],
        [0, 0],
        [0, bridge_cross_beam_top],
        [bridge_cross_beam_width, bridge_cross_beam_top],
        [bridge_cross_beam_width, 0],
        [bridge_cross_beam_width * 9/10, bridge_cross_beam_bottom],
    ]);
}

module Cables() {
    mirror_copy(VEC_Y) {
        for(cable_nr = [0:bridge_cable_count-1]) {
            cable_bottom_transpose(cable_nr) {
                Cable(cable_length(cable_nr));
            }
        }
    }
    module Cable(length) {
        translate([0, 0, -bridge_cable_diameter]) {
            cylinder(d = bridge_cable_diameter, h = length + 2 * bridge_cable_diameter, $fn = 16);
        }
    }
}

module Deck() {
    mirror(VEC_Z) linear_extrude(bridge_deck_thickness) {
        square([
            bridge_length,
            bridge_width + 2 * bridge_deck_indent
        ], center = true);
    }
}
