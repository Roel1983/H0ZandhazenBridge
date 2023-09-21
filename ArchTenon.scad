include <Utils.inc>
include <Bridge.inc>
use <Mortise.scad>
use <SegmentCutPosition.scad>
use <BridgeSegments.scad>

%Bridge(colored=false);
ArchMortise(0);
ArchMortise(1);
ArchMortise(2);
ArchMortise(3);

base_mortise_config = mortise_config(
    length  = 45,
    width_1 = 10, width_2 = 6,
    thickness_1 = 8, thickness_2 = 6
);
mortise_config1 = mortise_config(base_mortise_config, r = 500, length  = 53);
mortise_config2 = mortise_config(base_mortise_config, r = 700, length  = 47);

mortise_configs = [
    mortise_config1,
    mortise_config2,
    mortise_config2,
    mortise_config1
];

module ArchTenon(index) {
    arch_mortise_transform(index) {
        render() union() {
            Tenon(mortise_configs[index]);
            translate([0,0.001]) mirror(VEC_Y) Tenon(mortise_configs[index]);
        }
    }
}

module ArchMortise(index) {
    arch_mortise_transform(index) {
        render() union() {
            Mortise(mortise_configs[index]);
            translate([0,0.001]) mirror(VEC_Y)Mortise(mortise_configs[index]);
        }
    }
}


module arch_mortise_transform(index) {
    bridge_arch_segment_cut_transform(index + 1) {
        rotate(90) {
            rotate(-90, VEC_Y) {
                translate(mm([.5,0,-5])) {
                    children();
                }
            }
        }
    }
}