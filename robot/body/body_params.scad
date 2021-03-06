// Author: Mihai Oltean, https://mihaioltean.github.io, mihai.oltean@gmail.com
// More details: https://jenny5.org, https://jenny5-robot.github.io/
// Source code: github.com/jenny5-robot
// License: MIT
//--------------------------------------------------------------

include <../../basic_scad/params_basic_components.scad>
include <../../basic_scad/params_radial_bearings.scad>
include <../../basic_scad/params_radial_bearings_housing.scad>
include <../../basic_scad/params_tube_bracket.scad>
include <../../basic_scad/params_sheets.scad>
include <../../basic_scad/params_stepper_motors.scad>
//--------------------------------------------------------------


angle_body_arm = 90;// 180 (closed - front)...-90 (open-back); // default = -90

body_rotation_linear_motor_position = 0;

bracket_thick = 10;

dist_edge_to_body_shaft = rbearing_6907_housing_size[0] / 2 + bracket_thick;

body_height = 340;
body_width = 450;

clavicule_size = [60, 30, body_width];

dist_to_body_motor = 150;
   
motor_housing_tolerance = 10;
motor_housing_tolerance_large = 20;

body_rotation_sheet_size = [60, 200, 10];

body_arm_bone_size = 25;
body_shaft_radius = 12.5;

distance_between_body_modules = rbearing_6907_housing_size[0] + body_arm_bone_size + wall_thick_2;

body_sheet_size = [rbearing_6907_housing_size[0] + 2 * bracket_thick + 2 * wall_thick_1, distance_between_body_modules + body_arm_bone_size + 2 * braket_lateral_wall_thick, 3];

body_sheet_size_bottom = body_sheet_size + [10, 0, 0];

body_motor_sheet_size = [60, distance_between_body_modules + body_arm_bone_size + 2 * braket_lateral_wall_thick, 3];

body_intermodule_sheet_size = [40, distance_between_body_modules + body_arm_bone_size + 2 * braket_lateral_wall_thick, 3];


body_arm_shaft_length = body_height + 2 * tube_bracket_base_thick_strong + 2 * body_sheet_size[2] + 2 * body_arm_bone_size + rbearing_6907_housing_size[2];

printed_pulley_thick = 14;
pulley_spacer_length = 5.8;

offset_body_motor_sheet = 130;

body_intermodule_offset = 90;

body_base_sheet_size = [80, 117, 3];

body_base_holes_to_leg = 
[
[-69/2, -95 / 2, 0],
[-69/2, 95 / 2, 0],
[69/2, -95 / 2, 0],
[69/2, 95 / 2, 0]
];

corner_length = 46;

corner_base_thick = wall_thick_2;

corner_lateral_wall_thick = 2 * m4_screw_radius + wall_thick_3 + 1.5;

function f_corner_width(tube_radius) = 2 * (tube_radius + corner_lateral_wall_thick);
function f_corner_height(tube_radius) = corner_base_thick + tube_radius - 0.5;

corner_sheet_size = [corner_length, 90, wall_thick_3];

function f_corner_holes(tube_radius) = [
    [5, 5, 0],
    [5, f_corner_width(12.5) - (wall_thick_3 + m4_screw_radius), 0],
    [corner_length - 5, wall_thick_3 + m4_screw_radius, 0],
    [corner_length - 5, f_corner_width(12.5) - (wall_thick_3 + m4_screw_radius), 0],
    [7, corner_sheet_size[1] - 5, 0],
    [corner_length - 7, corner_sheet_size[1] - 5, 0],
    [7, corner_sheet_size[1] - 42, 0],
    [corner_length - 7, corner_sheet_size[1] - 42, 0]
];

corner_holes = f_corner_holes(12.5);
