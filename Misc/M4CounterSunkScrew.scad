include <Utils.inc>

m4_nut_diameter   = mm(6.9);
m4_nut_height     = mm(3.1);
m4_shaft_diameter = mm(4.2);
m4_counter_sunk_head_diameter = mm(7.5);
m4_counter_sunk_depth         = mm(0.5);

difference() {
    linear_extrude(mm(11)) square([mm(26), mm(12)], true);
    translate([-6,0]) rotate(90) {
        M4CounterSunkScrewHole();
        translate([0, 0, mm(5.9)])M4NutHole();
    }
    translate([mm(6),6,5]) rotate(90) rotate(-90, VEC_Y){
        rotate(-90)M4CounterSunkScrewHole(max_overhang_angle=60);
        translate([0, 0, mm(4)])M4NutSlot();
    }
}

module M4NutHole(center = false) {
    linear_extrude(m4_nut_height, center = center) {
        Hex(m4_nut_diameter);

    }
}
module M4NutSlot(center = false, slot_length = mm(0.0)) {
    linear_extrude(m4_nut_height, center = center) {
        Hex(m4_nut_diameter);
        l = 0.5 * m4_nut_diameter/cos(30) + slot_length;
        translate([l/2,0]) {
            square([l, m4_nut_diameter], true);
        }
    }
}

module M4CounterSunkScrewHole(
    length = mm(20.0),
    bias   = mm( 0.1),
    max_overhang_angle = 90,
    $fn = 32
) {
    rotate_extrude($fn=32) polygon([
        [
            0,
            -bias
        ], [
            m4_counter_sunk_head_diameter / 2,
            -bias
        ], [
            m4_counter_sunk_head_diameter / 2,
            m4_counter_sunk_depth
        ], [
            m4_shaft_diameter / 2,
            m4_counter_sunk_depth + (m4_counter_sunk_head_diameter - m4_shaft_diameter) / 2
        ], [
            0,
            m4_counter_sunk_depth + (m4_counter_sunk_head_diameter - m4_shaft_diameter) / 2
        ]
    ]);
    linear_extrude(length) {
        Droplet(d = m4_shaft_diameter, a = max_overhang_angle);
    }
}