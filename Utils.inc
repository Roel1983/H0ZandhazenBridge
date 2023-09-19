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
