include <Utils.inc>
include <Bridge.inc>
use <Mortise02.scad>
use <BridgeSegments.scad>

*%color("red",   alpha= 0.1) ArchSegment(0);
*%color("green", alpha= 0.1) ArchSegment(1);;
%Bridge(colored=false);
ArchTenon(0);
ArchTenon(1);

mortise_config = [
    mortise_config(
        length = mm(50),
        thickness_1 = mm(10),
        thickness_2 = mm(6),
        r           = 700),
    mortise_config(
        length = mm(45),
        thickness_1 = mm(10),
        thickness_2 = mm(6),
        r           = 500)
];

module ArchTenon(number) {
    translate([0, bridge_arch_distance_bottom/2 ])
    rotate(90, VEC_X)
    translate(bridge_arch_segment_cut_loc(number + 1))
    rotate(90 - bridge_arch_angle, VEC_X)
    rotate(bridge_arch_segment_cut_rotate(number + 1), VEC_Z)
    translate([0, 0, mm(5.5)])
    rotate(90) render() {
        mirror_copy(VEC_Y) MortiseAndTenon("tenon", mortise_config[number]);
    }
}