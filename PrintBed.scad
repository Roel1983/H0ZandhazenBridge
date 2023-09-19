include <Utils.inc>

print_bed_shape            = "Rectangular";
print_bed_size             = mm([250, 210]);
print_bed_max_print_height = mm(210);

PrintBed();

module PrintBed() {
    if($preview) {
        if (print_bed_shape == "Rectangular") {
            Rectangular();
        } else {
            assert(false, str("Unknown 'print_bed_shape': ", print_bed_shape));
        }
    }
    
    module Rectangular() {
        color("black", alpha=0.2) {
            {
                difference() {
                    square(print_bed_size, true);
                    for (x = [10:10:print_bed_size[X]-10]) translate([mm(x - print_bed_size[X]/2), 0]) {
                        square(mm([x%50==0?1.5:.5, print_bed_size[Y] + 1]), true);
                    }
                    for (y = [10:10:print_bed_size[Y]-10]) translate([0, mm(y - print_bed_size[Y]/2)]) {
                        square(mm([print_bed_size[X] + 1, y%50==0?1.5:.5]), true);
                    }
                }
            }
        }
        color("black", alpha=0.02) {
            linear_extrude(print_bed_max_print_height) square(print_bed_size, true);
        }
    }
}