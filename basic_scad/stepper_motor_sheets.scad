// Author: Mihai Oltean, 
// https://mihaioltean.github.io, mihai.oltean@gmail.com
// More details: jenny5.org
// Source: github.com/jenny5-robot
// MIT License
//--------------------------------------------------------------

include <params_stepper_motor_gearbox.scad>
include <params_stepper_motors.scad>
include <params_basic_components.scad>
include <config.scad>
include <tolerance.scad>

//--------------------------------------------------------------
module stepper_gearbox_motor_sheet(sheet_size, gearbox_hole_position, screw_hole_position, gearbox_hole_radius, gearbox_radius)
{
    difference(){
        translate ([-sheet_size[0] / 2, -sheet_size[1] / 2, 0]) cube(sheet_size);
        // middle hole
        translate (-display_tolerance_z) cylinder(h = sheet_size[2] + 2 * display_tolerance, r = gearbox_hole_radius);
        translate ([0, 0, nema_17_gearbox_sheet_base_wall_thick]) cylinder(h = sheet_size[2], r = gearbox_radius,$fn = 80);
        // gearbox holes
        for (i = [1 : 4])
            translate (+ gearbox_hole_position[i]) cylinder(h = nema_17_gearbox_sheet_base_wall_thick , r2 = 1.5, r1 = 2.5, $fn = 10);

// screw holes for belt tensioner        
        for (i = [0 : 4])
            translate (-display_tolerance_z + screw_hole_position[i]) cylinder(h = sheet_size[2] + 2 * display_tolerance, r = 2, $fn = 10);
    }
}
//--------------------------------------------------------------
stepper_gearbox_motor_sheet(nema_17_gearbox_sheet_size, gearbox_nema_17_holes_position, nema17_gearbox_tensioner_sheet_screw_hole_position, nema_17_gearbox_motor_hole_radius, nema_17_motor_gearbox_radius);