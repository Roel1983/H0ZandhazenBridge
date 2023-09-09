// Constants
X = 0;
Y = 1;
Z = 2;

VEC_X = [1,0,0];
VEC_Y = [0,1,0];
VEC_Z = [0,0,1];

E = 2.7182818284;

SCALE = 1/283.34;

// Util functions
function round_decimals(x, decimal = 4, base = 10) = (
    let(k = pow(base, ceil(ln(x) / ln(base)) - decimal))
    round(x / k) * k
);

// Units
function mm(x)     = x;
function cm(x)     = x * mm(10);
function m(x)      = x * mm(1000);
function nozzle(x) = x * mm(0.4);

function scaled(x)   = x * SCALE;
function unscaled(x) = x / SCALE;

function as_string1(x) = (
    (x < 100)
    ? str(x / mm(1), "mm")
    : (x < 1000)
    ? str(x / cm(1), "cm")
    : str(x / m(1), "m")
);
function as_string(x) = str(
    as_string1(round_decimals(x)),
    " (", as_string1(round_decimals(unscaled(x))), ")"
);

// Dimentions
bridge_length                = scaled(m(255));
bridge_width                 = scaled(m( 18));
bridge_arch_distance_bottom  = scaled(m( 20));
bridge_arch_distance_top     = scaled(m(  3));

bridge_arch_catenary_a       = 1.3866;
bridge_arch_width            = scaled(m(4));
bridge_arch_thickness_top    = scaled(m(4));
bridge_arch_thickness_bottom = scaled(m(5));

bridge_beam_locations        = [-3/5, -1/5, 1/5, 3/5];
bridge_beam_indent           = scaled(m(.5));

bridge_cross_beam_width      = scaled(m(3.0));
bridge_cross_beam_height     = scaled(m(4.0));

bridge_deck_thickness        = mm( 4.0);
bridge_deck_indent           = mm( 5.0);
bridge_deck_rim_thickness    = mm( 1.5);

bridge_cable_count           = 12;
bridge_cable_distance1       = bridge_length / 8;
bridge_cable_distance2       = scaled(m(2));
bridge_cable_diameter        = mm(3.0);

bridge_head_length           = cm(5);

// Catenary curve
function cosh(x)        = (pow(E, x) + pow(E, -x)) / 2;
function catenary(x, a) = a * cosh(x / a);

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

function bridge_arch_outer_point(i)  = bridge_arch(i, offset = bridge_arch_thickness(i));
function bridge_arch_center_point(i) = bridge_arch(i, offset = bridge_arch_thickness(i) / 2);
function bridge_arch_inner_point(i)  = bridge_arch(i, offset = 0);

function bridge_arch_center_distance(i) = (
    let(j = bridge_arch_center_point(i)[Y] / bridge_arch_center_point(0)[Y])
    bridge_arch_distance_top * j + bridge_arch_distance_bottom * (1 - j) + bridge_arch_width
);

// Arch separator beam functions
bridge_beam_count     = len(bridge_beam_locations);
function arch_separator_beam_position(beam_nr) = (
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
    bridge_arch_center_distance(bridge_beam_locations[beam_nr])
);

// Cable functions
function cable_bottom_position(cable_nr) = [
    -bridge_cable_distance1 * (bridge_cable_count - 2) / 4 +
    bridge_cable_distance1 * floor (cable_nr / 2) + 
    bridge_cable_distance2 * (((cable_nr % 2) == 0) ? -.5 : .5),
    (bridge_width + bridge_cross_beam_width) / 2,
    0
];
function cable_top_position(cable_nr) = (
    let(
        ix = -bridge_cable_distance1 * (bridge_cable_count - 2) / 4 +
            bridge_cable_distance1 * floor (cable_nr / 2) + 
            (bridge_cable_distance1 - bridge_cable_distance2) * (((cable_nr % 2) == 0) ? -.5 : .5),
        i  = 2 * ix / bridge_length,
        xz = bridge_arch_center_point(i)
        
    ) [
        xz[0],
        bridge_arch_center_distance(i) / 2,
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
function cable_top_angle_vec_y(cable_nr) = (cable_bottom_angle_vec_y(cable_nr) - 180);
function cable_top_angle_vec_x(cable_nr) = (cable_bottom_angle_vec_x(cable_nr));

// Derived
bridge_height          = bridge_arch_outer_point(i = 0)[Y];
bridge_bounding_width  = bridge_arch_distance_bottom  + 2 * bridge_arch_width;
bridge_bounding_length = bridge_length + 2 * bridge_head_length;
bridge_arch_overhang   = (bridge_arch_distance_bottom - bridge_arch_distance_top) / 2;
bridge_arch_angle      = atan(bridge_height / bridge_arch_overhang);

// Construct
Report();
Arch();
ArchSeparatorBeams();
CrossBeams();
Cables();
%Deck();

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
    echo(str("Bridge length:    ", as_string(bridge_length)));
    echo(str("Bridge height:    ", as_string(bridge_height)));
    echo(str("Bounding length:  ", as_string(bridge_bounding_length)));
    echo(str("Bounding width:   ", as_string(bridge_bounding_width)));
    echo(str("Cable diameter:   ", as_string(bridge_cable_diameter)));
    echo(str("Shortest cable:   ", as_string(cable_stats[0])));
    echo(str("Longest cable:    ", as_string(cable_stats[1])));
    echo(str("Total cable:      ", as_string(cable_stats[2] * 2)));
    echo("---------------------------------------------");
}

module Arch() {
    intersection() {
        rotate(90, VEC_X) {
            linear_extrude(
                bridge_bounding_width, center = true, convexity = 2
            ) {
                ArchSideView();
            }
        }
        rotate(90, VEC_Y) rotate(90) {
            linear_extrude(
                bridge_bounding_length,
                center = true,
                convexity = 2
            ) {
                ArchFrontView();
            }
        }
    }
    
    module ArchFrontView() {
        length = norm([bridge_height, bridge_arch_overhang]);
        mirror_copy(VEC_X) {
            translate([-bridge_arch_distance_bottom / 2, 0]) {
                rotate(bridge_arch_angle) {
                    translate([-bridge_arch_width, 0]) {
                        square([length + bridge_arch_width, bridge_arch_width]);
                    }
                }
            }
        }
    }

    module ArchSideView() {
        f = 1.05;
        g = bridge_arch_outer_point(f)[X];
        step = $preview ? 0.1 : 0.001;
        points = concat(
            [for(i = [-1.0 : step : 1.0]) bridge_arch_outer_point(i * f)],
            [for(i = [ 1.0 :-step :-1.0]) bridge_arch_inner_point(i * f)]
        );
        intersection() {
            polygon(points);
            translate([-g, 0]) square([2 * g, bridge_height]);
        }
    }
}

module ArchSeparatorBeams() {
    for (i = [0:bridge_beam_count-1]) {
        ArchSeparatorBeam(i);
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
}



module CrossBeams() {
    mirror_copy(VEC_Y) translate([0, bridge_width / 2]) CrossBeam();
}
module CrossBeam() {
    difference() {
        rotate(90, VEC_Y)rotate(90) {
            linear_extrude(bridge_bounding_length, center=true, convexity = 3) {
                CrossBeamProfile();
            }
        }
        mirror_copy(VEC_X) Head();
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
        [0, -bridge_deck_thickness - bridge_deck_rim_thickness],
        [0, -bridge_deck_thickness],
        [bridge_deck_indent, -bridge_deck_thickness],
        [bridge_deck_indent, 0],
        [0, 0],
        [0, bridge_cross_beam_height -bridge_deck_thickness - bridge_deck_rim_thickness],
        [bridge_cross_beam_width, bridge_cross_beam_height -bridge_deck_thickness - bridge_deck_rim_thickness],
        [bridge_cross_beam_width, 0],
        [bridge_cross_beam_width * 2/3, -bridge_deck_thickness - bridge_deck_rim_thickness],
    ]);
}

module Cables() {
    mirror_copy(VEC_Y) {
        for(cable_nr = [0:bridge_cable_count-1]) {
            translate(cable_bottom_position(cable_nr)) {
                rotate(cable_bottom_angle_vec_x(cable_nr), VEC_X) {
                    rotate(cable_bottom_angle_vec_y(cable_nr), VEC_Y) {
                        Cable(cable_length(cable_nr));
                    }
                }
            }
        }
    }
    module Cable(length) {
        cylinder(d = bridge_cable_diameter, h = length, $fn = 16);
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
// Utility

module mirror_copy(vec) {
    children();
    mirror(vec) children();
}
