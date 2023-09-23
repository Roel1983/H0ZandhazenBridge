include <Utils.inc>

m3_nut_diameter   = mm(5.5);
m3_nut_height     = mm(2.5);
m3_shaft_diameter = mm(3.0);
m3_counter_sunk_head_diameter = mm(5.5);
m3_counter_sunk_depth         = mm(0.5);

difference() {
    linear_extrude(mm(9)) square([mm(24), mm(12)], true);
    translate([-4,0]) {
        M3CounterSunkScrewHole();
        translate([0, 0, mm(4.7)])M3NutHole();
    }
    translate([mm(12),0,4]) rotate(-90, VEC_Y){
        M3CounterSunkScrewHole();
        translate([0, 0, mm(2)])M3NutSlot();
    }
}

module M3NutHole(center = false) {
    linear_extrude(m3_nut_height, center = center) {
        Hex(m3_nut_diameter);

    }
}
module M3NutSlot(center = false, slot_length = mm(0.0)) {
    linear_extrude(m3_nut_height, center = center) {
        Hex(m3_nut_diameter);
        l = 0.5 * m3_nut_diameter/cos(30) + slot_length;
        translate([l/2,0]) {
            square([l, m3_nut_diameter], true);
        }
    }
}

module M3CounterSunkScrewHole(
    length = mm(10.0),
    bias   = mm( 0.1)
) {
    rotate_extrude($fn=32) polygon([
        [
            0,
            -bias
        ], [
            m3_counter_sunk_head_diameter / 2,
            -bias
        ], [
            m3_counter_sunk_head_diameter / 2,
            m3_counter_sunk_depth
        ], [
            m3_shaft_diameter / 2,
            m3_counter_sunk_depth + (m3_counter_sunk_head_diameter - m3_shaft_diameter) / 2
        ], [
            m3_shaft_diameter / 2,
            length
        ], [
            0,
            length
        ]
    ]); 
}