include <Misc/Utils.inc>
use <Bridge.scad>

// Scale
SCALE = 1/283.34;

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

bridge_cross_beam_width      = scaled(m(4.0));
bridge_cross_beam_height     = scaled(m(4.7));

bridge_deck_thickness        = mm( 4.0);
bridge_deck_indent           = mm( 5.0);
bridge_deck_rim_thickness    = mm( 1.5);

bridge_cable_count           = 12;
bridge_cable_distance1       = bridge_length / 8;
bridge_cable_distance2       = scaled(m(3.0));
bridge_cable_diameter        = mm(3.0);

bridge_head_length           = cm(5);

// Derived
bridge_height            = bridge_arch_outer_point(i = 0)[Y];
bridge_bounding_width    = bridge_arch_distance_bottom  + 2 * bridge_arch_width;
bridge_bounding_length   = bridge_length + 2 * bridge_head_length;
bridge_arch_overhang     = (bridge_arch_distance_bottom - bridge_arch_distance_top) / 2;
bridge_arch_angle        = atan(bridge_height / bridge_arch_overhang);
bridge_beam_count        = len(bridge_beam_locations);
bridge_cross_beam_bottom = -bridge_deck_thickness - bridge_deck_rim_thickness;
bridge_cross_beam_top    = bridge_cross_beam_height -bridge_deck_thickness - bridge_deck_rim_thickness;
cross_beam_center_center_distance = bridge_width + bridge_cross_beam_width;
