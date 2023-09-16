use <02 - Zandhazenbridge.scad>
hide_bridge = true;

#rotate(63, [0,1,0])translate([-297.7,-42,-100])rotate(80.72-90, [1,0,0])Arch03();

X = 0;
Y = 1;
Z = 2;

function mortise_tenon_config(
    length,
    width,
    thickness,
    tight_length,
    radius,
    tolerance_side_1,
    tolerance_side_2,
    tolerance_bottom,
    tolerance_top
) = [length,
    width,
    thickness,
    tight_length,
    radius,
    tolerance_side_1,
    tolerance_side_2,
    tolerance_bottom,
    tolerance_top
];

module Mortise(config) {
    
}



function mortise_points(
    width_a           = 12,
    width_b           = 10,
    thickness         =  10,
    bevel             =  2,
    length_a          = 10,
    length_ab         = 10,
    length_b          = 30,
    r                 = 500,
    r_error           = .01
) = (
    let(
        fs2 = (
            (is_undef(r)) ? (
                undef
            ) : (
                let(
                    r_max = r + max(width_a, width_b) / 2,
                    a     = acos(1 - r_error/r_max)
                )
                a * PI * r_max / 180
            )
        ),
        points = concat(
            section_points(
                z_1       = 0,
                z_2       = length_a,
                width_1   = width_a,
                width_2   = width_a,
                thickness = thickness, bevel = 2, fs = fs2),
            section_points(
                z_1       = length_a,
                z_2       = length_a + length_ab,
                width_1   = width_a,
                width_2   = width_b,
                thickness = thickness, bevel = 2, fs = fs2),
            section_points(
                z_1       = length_a + length_ab,
                z_2       = length_a + length_ab + length_b,
                width_1   = width_b,
                width_2   = width_b,
                thickness = thickness, bevel = 2, fs = fs2),
            section_points(
                z_1       = length_a + length_ab + length_b,
                z_2       = length_a + length_ab + length_b + bevel,
                width_1   = width_b,
                width_2   = width_b - bevel,
                thickness = thickness, bevel = 2, fs = fs2),
            section_points(
                z_1       = length_a + length_ab + length_b + bevel,
                z_2       = length_a + length_ab + length_b + bevel,
                width_1   = width_b - bevel,
                width_2   = width_b - bevel,
                thickness = thickness, bevel = 2, fs = fs2)
        )
    ) is_undef(r) ? points : bend_points(r=r, points = points)
);

points= mortise_points();
faces = concat(
    [[0,1,2,3,4,5]],
    [each for (i = [0 : 6 : len(points) - 7])[
        [i + 0, i +  6, i +  7, i + 1],
        [i + 1, i +  7, i +  8, i + 2],
        [i + 3, i +  9, i + 10, i + 4],
        [i + 4, i + 10, i + 11, i + 5],
    ]],
    [[for (i = [len(points)-1:-1:len(points)-6]) i]],
    [concat(
        [for (i = [len(points)-6:-6:0]) i],
        [for (i = [5:6:len(points)-1]) i]
    )],
    [concat(
        [for (i = [2:6:len(points)-1]) i],
        [for (i = [len(points)-3:-6:1]) i]
    )]
);
polyhedron(points = points, faces = faces);
for (p = points) translate(p) color("black") cube(.2, true);

function bend_points(r = 100, points) = [
    for (p = points) [
        cos(p[Z] / r * (180 / PI)) * (p[X] + r) - r,
        p[Y],
        sin(p[Z] / r * (180 / PI)) * (p[X] + r)
    ]
];


function section_points(
    z_1,
    z_2,
    width_1,
    width_2,
    thickness,
    bevel,
    bevel_angle   = 60,
    offset_side   =  0,
    offset_bottom =  0,
    offset_top    =  0,
    offset_bevel  =  0,
    fs            = undef
) = (
    let(
        steps = is_undef(fs) ? 1 : ceil(max(1, abs(z_1 - z_2) / fs))
    ) [
        each for (step = [0:steps - 1]) (
            let(
                f     = steps > 0 ? step / steps : 0,
                z     = z_1 * (1 - f) + z_2 * f,
                width = width_1 * (1 - f) + width_2 * f,
                ps    = profile_points(
                    width         = width,
                    thickness     = thickness,
                    bevel         = bevel,
                    bevel_angle   = bevel_angle,
                    offset_side   = offset_side,
                    offset_bottom = offset_bottom,
                    offset_top    = offset_top,
                    offset_bevel  = offset_bevel)
            )
            [for (i = [0:len(ps)-1]) [
                ps[i][X],
                ps[i][Y],
                z
            ]]
        )
    ]
);


function profile_points(
    width,
    thickness,
    bevel,
    bevel_angle   = 60,
    offset_side   =  0,
    offset_bottom =  0,
    offset_top    =  0,
    offset_bevel  =  0
) = (
    let(
        a = width / 2 ,
        b = a - (bevel - offset_bevel) / cos(bevel_angle) - offset_top * tan(bevel_angle),
        c = thickness / 2,
        d = c - (bevel - offset_bevel) / sin(bevel_angle) - offset_side / tan(bevel_angle)
    )[
        [ a + offset_side, -c - offset_bottom],
        [ a + offset_side,  d],
        [ b,  c + offset_top],
        [-b,  c + offset_top],
        [-a - offset_side,  d],
        [-a - offset_side,  -c - offset_bottom]
    ]
);
