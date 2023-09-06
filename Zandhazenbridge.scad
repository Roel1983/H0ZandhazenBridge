// Constants

X = 0;
Y = 1;
Z = 2;

VEC_X = [1,0,0];
VEC_Y = [0,1,0];
VEC_Z = [0,0,1];

SCALE = 1/87;

// Units

function mm(x) = x;
function cm(x) = x * mm(10);
function m(x)  = x * mm(1000);

function scaled(x)   = x * SCALE;
function unscaled(x) = x / SCALE;

// Dimentions

bridge_length             = scaled(m(240));
bridge_height             = scaled(m( 50));

bridge_width_base         = scaled(m(28));
bridge_width_top          = scaled(m(10));

bridge_pillar_base_width  = scaled(m(4));
bridge_pillar_top_height  = scaled(m(4));
bridge_pillar_top_width   = scaled(m(4));
bridge_pillar_base_length = scaled(m(8));

bridge_beam_thickness     = scaled(m([3.0, 3.0]));

bridge_deck_width           = scaled(m(17));
bridge_deck_lenght          = scaled(m(255));
bridge_deck_beam_height     = scaled(m(4));
bridge_deck_beam_width      = scaled(m(4));
bridge_deck_thickness       = mm(9);
bridge_deck_ridge_thickness = mm(5);
bridge_deck_ridge_width     = cm(1.5);
bridge_deck_ridge_indent    = cm(0.5);
bridge_deck_base            = cm(20);

bridge_deck_screw_size      = mm(4);
bridge_deck_screw_distance  = cm(10);

bridge_cable_distance1      = bridge_length / 8;
bridge_cable_distance2      = scaled(m(2));
bridge_cable_count          = 12;
bridge_cable_thickness      = scaled(m(1));

// Derived Dimentions

bridge_deck_beam_top = bridge_deck_beam_height - bridge_deck_ridge_thickness - bridge_deck_thickness;

// Main

Bridge();
%Heads();

module Bridge() {
    color("white") {
        Curve();
        Beams();
        BridgeCables();
    }
    color("blue")  DeckBeams();
    color([0.2,0.2,0.2]) Deck();
    
    module Curve() {
        intersection() {
            rotate(90, VEC_X) {
                linear_extrude(bridge_width_base, center = true, convexity=2) {
                    Curve2DSide();
                }
            }
            rotate(90, VEC_Z) rotate(90, VEC_X) {
                linear_extrude(bridge_length, center = true, convexity=2) {
                    Curve2DFront();
                }
            }
        }
        
        module Curve2DSide() {
            polygon(points = curve_points());
            
            outer_curve_points = [for (i=[-1:($preview?.05:0.01):1]) outer_curve_point(i)];
            inner_curve_points = [for (i=[-1:($preview?.05:0.01):1]) inner_curve_point(i)];
                
            function curve_points() = concat(
                outer_curve_points,
                points_reverse(inner_curve_points)
            );
        }
        
        module Curve2DFront() {
            mirror_copy(VEC_X) {
                polygon([
                    [-bridge_width_base / 2                           , 0],
                    [-bridge_width_base / 2 + bridge_pillar_base_width, 0],
                    [-bridge_width_top  / 2 + bridge_pillar_top_width , bridge_height],
                    [-bridge_width_top  / 2                           , bridge_height],
                ]);
            }
        }
    }
    
    module Beams() {
        for (i = [-3/5, -1/5, 1/5, 3/5]) {
            rotate(90, VEC_X) {
                translate(center_curve_point(i)) rotate(center_curve_slope(i))
                cube([bridge_beam_thickness[X], bridge_beam_thickness[Y], center_curve_width(i)], true);
            }
        }
    }
    
    module BridgeCables() {
        for(i = [0 : bridge_cable_count - 1]) {
            mirror_copy(VEC_Y) BridgeCable(i);
        }
        
        module BridgeCable(i) {
            p1     = cable_bottom_attachment(i);
            p2     = cable_top_attachment(i);
            pd     = p1 - p2;
            length = norm(pd);
            
            translate(p1) {
                ry = atan(pd[X] / pd[Z]);
                rx = atan(pd[Y] / pd[Z] * cos(ry));
                rotate(-rx, VEC_X) {
                    rotate(ry, VEC_Y) {
                        Cable(length);
                    }
                }
            }
            
            function cable_bottom_attachment(cable_nr) = [
                -bridge_cable_distance1 * (bridge_cable_count - 2) / 4 +
                bridge_cable_distance1 * floor (cable_nr / 2) + 
                bridge_cable_distance2 * (((cable_nr % 2) == 0) ? -.5 : .5),
                (bridge_deck_width + bridge_deck_beam_width) / 2,
                0 *bridge_deck_beam_top
            ];
            function cable_top_attachment(cable_nr) = (
                let(
                    ix = -bridge_cable_distance1 * (bridge_cable_count - 2) / 4 +
                        bridge_cable_distance1 * floor (cable_nr / 2) + 
                        (bridge_cable_distance1 - bridge_cable_distance2) * (((cable_nr % 2) == 0) ? -.5 : .5),
                    i  = 2 * ix / bridge_length,
                    xz = center_curve_point(i)
                    
                ) [
                    xz[0],
                    center_curve_width(i) / 2,
                    xz[1]
                ]
            );
            
            module Cable(length) {
                cylinder(d = bridge_cable_thickness, h = length);
            }
        }
    }
        
    module DeckBeams() {
        mirror_copy(VEC_Y)
        difference() {
            union() {
                translate([0, (bridge_deck_width + bridge_deck_beam_width) / 2]) {
                    linear_extrude(bridge_deck_beam_top) {
                        square([
                            bridge_deck_lenght,
                            bridge_deck_beam_width
                        ], true);
                    }
                    translate([0, bridge_deck_ridge_indent/2, - bridge_deck_ridge_thickness - bridge_deck_thickness]) {
                        linear_extrude(bridge_deck_beam_height) {
                            square([
                                bridge_deck_lenght - 2 * bridge_deck_base,
                                bridge_deck_beam_width - bridge_deck_ridge_indent
                            ], true);
                        }
                        linear_extrude(bridge_deck_ridge_thickness) {
                            translate([0, -bridge_deck_ridge_width]) {
                                square([
                                    bridge_deck_lenght - 2 * bridge_deck_base,
                                    bridge_deck_beam_width - bridge_deck_ridge_indent
                                ], true);
                            }
                        }
                    }
                }
            }
        }
    }
    
    module Deck() {
        mirror(VEC_Z) linear_extrude(bridge_deck_thickness) square([
            bridge_deck_lenght - 2 * bridge_deck_base,
            bridge_deck_width + 2 * bridge_deck_ridge_indent
        ], true);
    }
    
    function curve_point(length, height, i) = [
        length * i / 2,
        (1 - (i * i)) * height
    ];
    
    function curve_slope(length, height, i) = (
        let(bias = 0.001,
        p1 = curve_point(length, height, i - bias),
        p2 = curve_point(length, height, i + bias))
        atan(
            (p1[Y] - p2[Y]) / (p1[X] - p2[X])
        )
    );
    
    function curve_width(length, height, width_base, width_top, i) = (
        let(
            z = curve_point(length, height, i)[Y],
            j = z / height
        )
        width_top * j + width_base * (1 - j)
    );

    function outer_curve_point(i) = curve_point(
        bridge_length,
        bridge_height,
        i
    );
    
    function inner_curve_point(i) = curve_point(
        bridge_length - 2 * bridge_pillar_base_length,
        bridge_height - bridge_pillar_top_height,
        i
    );
    
    function center_curve_point(i) = curve_point(
        bridge_length - bridge_pillar_base_length,
        bridge_height - bridge_pillar_top_height / 2,
        i
    );
    
    function center_curve_slope(i) = curve_slope(
        bridge_length - bridge_pillar_base_length,
        bridge_height - bridge_pillar_top_height / 2,
        i
    );
    
    function center_curve_width(i) = curve_width(
        bridge_length - bridge_pillar_base_length,
        bridge_height - bridge_pillar_top_height / 2,
        bridge_width_base - bridge_pillar_base_width,
        bridge_width_top  - bridge_pillar_top_width,
        i
    );
}

module Heads() {
    mirror_copy(VEC_X) {
        translate([
            bridge_deck_lenght / 2,
            0,
            -0.15 * bridge_height
        ])
        cube([
            2   * bridge_deck_base,
            1.2 * bridge_width_base,
            0.3 * bridge_height
        ], true);
    }
}

// Utilities

module mirror_copy(vec=undef) {
    children();
    mirror(vec) children();
}

function points_reverse(points) = [
    let(from = len(points) - 1, to = 0)
    for(i=[from:-1:to]) points[i]
];
