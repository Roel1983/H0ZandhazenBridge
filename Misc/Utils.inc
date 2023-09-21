// Constants
X = 0;
Y = 1;
Z = 2;

VEC_X = [1,0,0];
VEC_Y = [0,1,0];
VEC_Z = [0,0,1];

E = 2.7182818284;

// Units
function mm(x)     = x;
function cm(x)     = x * mm(10);
function m(x)      = x * mm(1000);
function nozzle(x) = x * mm(0.4);

function scaled(x)   = x * SCALE;
function unscaled(x) = x / SCALE;

// Util functions
function is_def(arg) = !is_undef(arg);
function round_decimals(x, decimal = 4, base = 10) = (
    let(k = pow(base, ceil(ln(x) / ln(base)) - decimal))
    round(x / k) * k
);

function length_to_string1(x) = (
    (x < 100)
    ? str(x / mm(1), "mm")
    : (x < 1000)
    ? str(x / cm(1), "cm")
    : str(x / m(1), "m")
);
function length_to_string(x) = str(
    length_to_string1(round_decimals(x)),
    " (", length_to_string1(round_decimals(unscaled(x))), ")"
);

// Catenary curve
function cosh(x)        = (pow(E, x) + pow(E, -x)) / 2;
function catenary(x, a) = a * cosh(x / a);

function between(from, to, f = 0.5) = (
    to * f + from * (1 - f)
);
function is_between(i, range) = (
    i >= range[0] && i < range[1]
);
// Modifiers
module mirror_copy(vec) {
    children();
    mirror(vec) children();
}

module mirror_if(condition, vec) {
    assert(is_bool(condition));
    if(condition) {
        mirror(vec) children();
    } else {
        children();
    }
}

// Shapes
module Hex(d) {
    intersection_for(a = [30,90,150]) rotate(a) square([d, d*2], true);
}

// Debug tools
module PrintOnScreen(relative_size = 1.0) {
    if ($preview) color("black") {
        effective_size = $vpd / 1000 * relative_size;
        
        
        rotate($vpr[Z], VEC_Z) rotate($vpr[Y], VEC_Y) rotate($vpr[X], VEC_X) {
            //linear_extrude(1000) square(effective_size * 2, true);
            //translate([0, 0, 1000]) 
                scale(effective_size) children();
        }
    }
}

module OrientationArrows(size = undef, relative_size = 1.0) {
    effective_size = is_def(size) ? (
        size
    ) : (
        $vpd / 50 * relative_size
    );
    arrow_h  = 1.0 * effective_size;
    arrow_d1 = 0.1 * effective_size;
    arrow_d2 = 0.3 * effective_size;
    
    if ($preview) {
        color("red")   rotate(90, VEC_Y)  Arrow();
        color("green") rotate(-90, VEC_X) Arrow();
        color("blue")  Arrow();
    }
    
    module Arrow() {
        cylinder(d = arrow_d1, h = arrow_h);
        translate([0, 0, arrow_h]) cylinder(d1 = arrow_d2, d2 = 0, h = arrow_d2);
    }
}
