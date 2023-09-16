//difference() {
//    polygon(profile_points_2d());
//};

X = 0;
Y = 1;
Z = 2;

//TODO reenforcment
mortise_config = mortise_config(r=50);

%render()difference() {
    translate([-9.5, 0.1, -1])cube([17, 22, 8]);
    MortiseAndTenon("mortise", mortise_config);
}

render() union() {
    MortiseAndTenon("tenon", mortise_config);
    mirror([0,1,0])MortiseAndTenon("tenon", mortise_config);
}

//
function mortise_config(
    length           = 20,
    width_1          = 10,
    width_2          =  7,
    thickness_1      = 6,
    thickness_2      = 4,
    notch            = [1.5, 0.2],
    tight_length     = 6,
    bevel            =  1,
    r                = undef,
    tolerance_lenght = .2,
    tolerance_side   = -0.0,
    tolerance_bottom =  0.0,
    tolerance_top    =  1.0,
    tolerance_bevel  = -.1
) = [tolerance_lenght, length, width_1, width_2, thickness_1, thickness_2, notch, tight_length, bevel, r,
    tolerance_side, tolerance_bottom, tolerance_top, tolerance_bevel
];

module MortiseAndTenon(
    part = "mortise",
    mortise_config = mortise_config()
) {
    assert(part == "mortise" || part == "tenon", "'part' must be either \"mortise\" or \"tenon\"");

    z_tolerance  = part == "tenon" ? -mortise_config[0] : 0;
    length       = mortise_config[1];
    width_1      = mortise_config[2];
    width_2      = mortise_config[3];
    thickness_1  = mortise_config[4];
    thickness_2  = mortise_config[5];
    notch        = mortise_config[6];
    tight_length = mortise_config[7];
    bevel        = mortise_config[8];
    r            = mortise_config[9];
    tolerance_side   = mortise_config[10];
    tolerance_bottom = mortise_config[11];
    tolerance_top    = mortise_config[12];
    tolerance_bevel  = mortise_config[13];
    
    r_error = width_1 / ($preview ? 100 : 1000);
    echo(r_error);
    mortise_offsets = offsets(
        side   = 0,
        bottom = 0,
        top    = 0,
        bevel  = 0 
    );
    tenon_offsets = offsets(
        side   = -tolerance_side,
        bottom = -tolerance_bottom,
        top    = -tolerance_top,
        bevel  = -tolerance_bevel
    );

    points = mortise_points(
        z_tolerance  = z_tolerance,
        length       = length,
        width_1      = width_1,
        width_2      = width_2,
        thickness_1  = thickness_1,
        thickness_2  = thickness_2,
        notch        = [notch[0], notch[1] * ((part == "tenon") ? 1.5 : 1)],
        tight_length = tight_length,
        bevel        = bevel,
        offsets      = part == "mortise" ? mortise_offsets : tenon_offsets,
        r            = r,
        r_error      = r_error
    );
    rotate(180) rotate(90, [1,0,0]) render() difference() {
        polyhedron(points = points, faces = faces(points));
        if(part == "tenon") SlideSlots();
    }
    module SlideSlots() {
        rotate(90, [1,0,0]) {
            linear_extrude(12, center = true) {
                SlideSlot_2d(offset_x =  width_2 / 2 - (1 / 2) - (2 * 0.4));
                SlideSlot_2d(offset_x = -width_2 / 2 + (1 / 2) + (2 * 0.4));
            }
        }
        module SlideSlot_2d(
            offset_x
        ) {
            polygon(slide_slot_points(
                length = tight_length * 3/5,,
                width  = 1,
                r_error = 0.1,
                offset = [
                    length - bevel - tight_length / 2,
                    offset_x
                ],
                r = r
            ));
        }
    }

    //
    function offsets(
        side   = 0.1,
        bottom = 0.05,
        top    = 1.0,
        bevel  = 0.15
    ) = [
        side,
        bottom,
        top,
        bevel 
    ];
    function mortise_points(
        z_tolerance, length, width_1, width_2, thickness_1, thickness_2, notch, tight_length, bevel, offsets, r, r_error
    ) = let(
        fs = (
            is_undef(r) ? undef : (
                assert(
                    !is_undef(r_error),
                    "If 'r' is defined, you must define 'r_error' too"
                ) let(
                    r_max = r + max(width_1, width_2) / 2
                ) size_of_facet(r, r_error)
            )
        ),
        q = length - bevel - tight_length / 2,
        z_width_and_offset_sides = concat(
            [
                [0,                                           width_1,         0,        thickness_1],
                [z_tolerance + tight_length,                  width_1,         0,        thickness_1],
                [z_tolerance + length - bevel - tight_length, width_2,         0,        thickness_2]
            ], is_undef(notch) ? [] : [
                [q - notch[0] / 2 - 2 * notch[1],             width_2,         0,        thickness_2],
                [q - notch[0] / 2,                            width_2,         notch[1], thickness_2],
                [q + notch[0] / 2,                            width_2,         notch[1], thickness_2],
                [q + notch[0] / 2 + 2 * notch[1],             width_2,         0,        thickness_2]
            ], [
                [z_tolerance + length - bevel,                width_2,         0,        thickness_2],
                [z_tolerance + length,                        width_2 - bevel, 0,        thickness_2]
            ]
        )
    ) bend_points_3d(
        r = r,
        points = [
            each for (i = [0 : len(z_width_and_offset_sides) - 2]) (
                section_points_3d(
                    z_from           = z_width_and_offset_sides[i    ][0],
                    z_to             = z_width_and_offset_sides[i + 1][0], 
                    width_from       = z_width_and_offset_sides[i    ][1],
                    width_to         = z_width_and_offset_sides[i + 1][1],
                    offset_side_from = z_width_and_offset_sides[i    ][2],
                    offset_side_to   = z_width_and_offset_sides[i + 1][2],
                    thickness_from   = z_width_and_offset_sides[i    ][3],
                    thickness_to     = z_width_and_offset_sides[i + 1][3],
                    offsets          = offsets,
                    fs = fs,
                    skip_first_ring = (i!=0))
            )
        ]
    );

    // Calculate the 3d points of a section
    function section_points_3d(
        z_from, z_to, width_from, width_to, offset_side_from, offset_side_to, thickness_from, thickness_to, offsets, fs, skip_first_ring
    ) = (let(
            steps = is_undef(fs) ? 1 : ceil(max(1, abs(z_from - z_to) / fs))
        ) [
            each for (step = [(skip_first_ring?1:0):steps]) (
                let(
                    f           = steps > 0 ? step / steps : 0,
                    z           = z_from           * (1 - f) + z_to           * f,
                    width       = width_from       * (1 - f) + width_to       * f,
                    offset_side = offset_side_from * (1 - f) + offset_side_to * f,
                    thickness   = thickness_from   * (1 - f) + thickness_to   * f,
                    ps    = profile_points_2d(
                        width       = width,
                        thickness   = thickness,
                        offset_side = offset_side,
                        offsets     = offsets
                    )
                )
                [for (i = [0:len(ps)-1]) [
                    ps[i][X],
                    ps[i][Y],
                    z
                ]]
            )
        ]
    );

    // Calculate the 2D points of the profile
    function profile_points_2d(width, thickness, offset_side, offsets) = (
        let(
            thickness     = thickness,
            bevel         = thickness / 3,//settings[1],
            bevel_angle   = 45,
            offset_side2  = offsets[0] + offset_side,
            offset_bottom = offsets[1],
            offset_top    = offsets[2],
            offset_bevel  = offsets[3],
            a = width / 2 ,
            b = a - (bevel - offset_bevel) / cos(bevel_angle) - offset_top * tan(bevel_angle),
            c = thickness,
            d = c - (bevel - offset_bevel) / sin(bevel_angle) - offset_side2 / tan(bevel_angle)
        )[
            [ a + offset_side2, 0 - offset_bottom],
            [ a + offset_side2,  d],
            [ b,  c + offset_top],
            [-b,  c + offset_top],
            [-a - offset_side2,  d],
            [-a - offset_side2,  0 - offset_bottom]
        ]
    );
    
    // Calculate the faces for the polygon
    function faces(points) = concat(
        [[0,1,2,3,4,5]],
        [each for (i = [0 : 6 : len(points) - 7])[
            [i + 0, i +  6, i +  7, i + 1],
            [i + 1, i +  7, i +  8, i + 2],
            [i + 2, i +  8, i +  9, i + 3],
            [i + 3, i +  9, i + 10, i + 4],
            [i + 4, i + 10, i + 11, i + 5],
        ]],
        [[for (i = [len(points)-1:-1:len(points)-6]) i]],
        [concat(
            [for (i = [len(points)-6:-6:0]) i],
            [for (i = [5:6:len(points)-1]) i]
        )]
    );
}

// Bending the 3D points
function bend_points_3d(r = undef, points) = (
    is_undef(r) ? (
        points
    ) : [
        for (p = points) [
            r - cos(p[Z] / r * (180 / PI)) * (p[X] + r),
            p[Y],
            sin(p[Z] / r * (180 / PI)) * (p[X] + r)
        ]
    ]
);
function bend_points_2d(r = undef, points) = (
    is_undef(r) ? (
        points
    ) : [
        for (p = points) [
            r - cos(p[Y] / r * (180 / PI)) * (p[X] + r),
            sin(p[Y] / r * (180 / PI)) * (p[X] + r)
        ]
    ]
);

// Calculate points of lines and shapes
function slide_slot_points(
    length,
    width,
    r_error,
    offset = [0, 0], // In rotated field
    r = undef
) = bend_points_2d(
    r = r,
    points = (
        let(
            line_steps = is_undef(r) ? (
                2
            ) : (
                ceil(length / size_of_facet(r = r, r_error = r_error)) + 1
            )
        ) concat(
            arc_points(r = width / 2, a_from = 180, a_to = 360, offset = [offset[Y], -length / 2 + offset[X]], r_error = r_error),
            line_points(from = [width / 2 + offset[Y], -length / 2 + offset[X]], to = [width / 2 + offset[Y], length / 2 + offset[X]], steps = line_steps, skip_first = true, skip_last = true),
            arc_points(r = width / 2, a_from =   0, a_to = 180, offset = [offset[Y],  length / 2 + offset[X]], r_error = r_error),
            line_points(from = [-width / 2 + offset[Y], length / 2 + offset[X]], to = [-width / 2 + offset[Y], -length / 2 + offset[X]], steps = line_steps, skip_first = true, skip_last = true)
        )
    )
);

function arc_points(
    r,
    a_from,
    a_to,
    r_error,
    offset = [0,0],
    skip_first = false,
    skip_last  = false
) = let(
    fn    = number_of_facet(r = r, r_error = r_error),
    steps = ceil(abs(a_to - a_from) / fn)
) [ for(i = [(skip_first?1:0):(steps-(skip_last?1:0))]) (
    let(
        f = i / steps,
        a = a_to * f + a_from * (1 - f)
    ) [
        cos(a) * r + offset[X],
        sin(a) * r + offset[Y]
    ]
)];

function line_points(
    from,
    to,
    steps      = 2,
    skip_first = false,
    skip_last  = false
) = let (
) [ for(i = [(skip_first?1:0):(steps-(skip_last?1:0))]) (
    let(
        f = i / steps
    ) to * f + from * (1 - f)
)];

// Calculate facets of a circle    
function number_of_facet(r, r_error) = 2 * acos(1 - r_error/r);
function size_of_facet(r, r_error) = number_of_facet(r, r_error) * PI * r / 180;
