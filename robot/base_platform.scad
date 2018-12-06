// Author: Mihai Oltean, www.tcreate.org, mihai.oltean@gmail.com
// More details: jenny5.org
// Source: github.com/jenny5-robot
// MIT License
//--------------------------------------------------------------

include <../basic_scad/params_radial_bearings.scad>
use <../basic_scad/radial_bearings.scad>

include <../basic_scad/params_basic_components.scad>

use <../basic_scad/pulleys.scad>
include <../basic_scad/params_screws_nuts_washers.scad>
include <base_platform_params.scad>

include <tracks_params.scad>
use <tracks.scad>

include <../basic_scad/params_laptop.scad>
use <../basic_scad/laptop.scad>

include <../basic_scad/params_chair_wheel.scad>
use <../basic_scad/chair_wheel.scad>

include <../basic_scad/config.scad>

include <../basic_scad/params_stepper_motors.scad>

use <../basic_scad/stepper_motors.scad>
use <../basic_scad/stepper_motors_housing.scad>
use <../basic_scad/lidar.scad>

use <../basic_scad/screws_nuts_washers.scad>
use <../basic_scad/belt.scad>

use <../basic_scad/belt_tensioner.scad>

use <../basic_scad/batteries.scad>
include <../basic_scad/params_batteries.scad>

include <../basic_scad/params_radial_bearings_housing.scad>
use <../basic_scad/radial_bearing_housing.scad>

include <../basic_scad/params_radial_bearings_u_housing.scad>
use <../basic_scad/radial_bearing_u_housing.scad>

use <../basic_scad/basic_components.scad>

include <leg_params.scad>

use <../basic_scad/dc_motors.scad>
use <../basic_scad/dc_motors_housing.scad>

include <../basic_scad/params_dc_motors.scad>
include <../basic_scad/params_dc_motor_housing.scad>

use <../basic_scad/point_transformations_3d.scad>

use <../basic_scad/involute_gears.scad>
use <../basic_scad/alu_profiles.scad>

include <../basic_scad/tolerance.scad>

//--------------------------------------------------------------------
module prism(h)
{
    linear_extrude(height = h)
        polygon( points = [[-3, 0], [3, 0], [0, 9]]);
}
//--------------------------------------------------------------------
module tooth(h)
{
    w = 7;
    translate ([0, -w/2, 0]) 
        hull() {
            cube([h, w, 5]);
            translate ([h / 2, 2, 4])
            rotate([-90, 0, 0])
            cylinder(h = w - 4, r = h /2, $fn = 30)
            ;
        }
}
//--------------------------------------------------------------------
module tooth2(height, length, thick)
{
    render(){
        hull() {
            cylinder(h = height, r = thick / 2, $fn = 30);
            translate ([length - thick / 2, 0, 0])
            cylinder(h = height, r = thick / 2, $fn = 30);
        }
    }
}
//--------------------------------------------------------------------
module wheel_extension_with_teeth(radius = 48.5, height = 8, steps = 18)
{
    
    angle_step = 360/steps;
    color (plastic_color) 
    render(){
        diametral_thickness = 10;
        difference(){
            union(){
                cylinder (r = radius, h = height, $fn = 100);
                //cylinder (r = radius + 5, h = 3, $fn = 100);
		for ( i = [0 : 1 : steps] )	
    		rotate([0, 0, i * angle_step]){
                translate ([radius, 0, 0])
                 tooth2(height = height, length = 9, thick = 9);
                
           //     translate ([0, 0, external_radius + 4 - 0.3])
           //         color("red") cylinder(h = 4, r2 = 1.5, r1 = 6, $fn = 30, center = false);
            }                

            }
            translate (-display_tolerance_z) cylinder (r = radius - diametral_thickness, h = height + 2 * display_tolerance, $fn = 100);
            // screw holes
            for (i = [0 : 7])
                translate([(radius - diametral_thickness / 2) * sin(i * 45), (radius - diametral_thickness / 2) * cos(i * 45), 0] - display_tolerance_z) cylinder(h = height + 2 * display_tolerance, r = m4_screw_radius, $fn = 30);

            
        }
    }
}
//--------------------------------------------------------------------
module wheel_wall(radius = 48.5, height = 4)
{
    
    
    color (plastic_color) 
    render(){
        diametral_thickness = 10;
        difference(){
            union(){
                cylinder (r = radius + 9, h = height - 1, $fn = 100);
                translate([0, 0, height - 1]) cylinder (r2 = radius, r1 = radius + 9, h = 1, $fn = 100);
            }

            translate (-display_tolerance_z) cylinder (r = radius - diametral_thickness, h = height + 2 * display_tolerance, $fn = 100);
            // screw holes
            for (i = [0 : 7])
                translate([(radius - diametral_thickness / 2) * sin(i * 45), (radius - diametral_thickness / 2) * cos(i * 45), 0] - display_tolerance_z) cylinder(h = height + 2 * display_tolerance, r = m4_screw_radius, $fn = 30);

            
        }
    }
}
//--------------------------------------------------------------------
module wheel_middle_external(external_radius = 84)
{
    screw_case_height = 10;
    color (plastic_color) 
   // render()
    {
    height = 4;
    screw_length = external_radius - 24;
    
    diametral_thickness = 10;
    
	difference(){
      // traction teeth
      union(){
            cylinder (r = external_radius + 9, h = 3, $fn = 100);
            translate([0, 0, 3]) cylinder (r2 = external_radius, r1 = external_radius + 9, h = height - 3, $fn = 100);
          // screw case
          cylinder (h = screw_case_height, r = 18);
            }

      num_spokes = 8;
      spoke_angle = 360 / num_spokes;
      // holes for saving material
	  for ( i = [0 : 1 : num_spokes] )	
		rotate([i * spoke_angle, 90, 0]){
          translate ([0, 0, external_radius - screw_length - 6]){
          hull(){
            translate ([height / 2, 0, 0])         
                    cylinder(h = screw_length - 4, r1 = 4, r2 = 14, $fn = 6, center = false);
            translate ([-height / 2, 0, 0])         
                    cylinder(h = screw_length - 4, r1 = 4, r2 = 14, $fn = 6, center = false);
                }
            }
        }

// 4 holes for fixing the part to the next ones
               diametral_thickness = 10; 
            for (i = [0 : 3])
                rotate([0, 0, 23])
                translate([(external_radius - diametral_thickness / 2) * sin(i * 90), (external_radius - diametral_thickness / 2) * cos(i * 90), 0] - display_tolerance_z) cylinder(h = height + 2 * display_tolerance, r = m4_screw_radius, $fn = 30);

// midle screw holes
            for (i = [0 : 3])
                                rotate([0, 0, 70])
                translate([14 * sin(i * 90), 14 * cos(i * 90), 0] - display_tolerance_z) cylinder(h = screw_case_height + 2 * display_tolerance, r = m3_screw_radius, $fn = 30);
        // centre hole
        cylinder (r = 6, h = height + 1, $fn = 50);
        // nut hole
        translate ([0, 0, height - 1]) cylinder (r = M12_nut_radius, h = M12_nut_thick + display_tolerance, $fn = 6, center = false);
	}
    }
}
//--------------------------------------------------------------------
module wheel_middle_internal(external_radius = 84)
{
    color (plastic_color) 
    //render()
    {
    height = 4;
    screw_length = external_radius - 24;
    
    diametral_thickness = 10;
    
	difference(){
      // traction teeth
      union(){
            cylinder (r = external_radius + 9, h = 3, $fn = 100);
            translate([0, 0, 3]) cylinder (r2 = external_radius, r1 = external_radius + 9, h = height - 3, $fn = 100);
            }

      num_spokes = 8;
      spoke_angle = 360 / num_spokes;
      // holes for saving material
	  for ( i = [0 : 1 : num_spokes] )	
		rotate([i * spoke_angle, 90, 0]){
          translate ([0, 0, external_radius - screw_length - 6]){
          hull(){
            translate ([height / 2, 0, 0])         
                    cylinder(h = screw_length - 4, r1 = 4, r2 = 14, $fn = 6, center = false);
            translate ([-height / 2, 0, 0])         
                    cylinder(h = screw_length - 4, r1 = 4, r2 = 14, $fn = 6, center = false);
                }
            }
        }

// 4 holes for fixing the part to the next ones	
        diametral_thickness = 10; 
            for (i = [0 : 3])
                rotate([0, 0, 23])
                translate([(external_radius - diametral_thickness / 2) * sin(i * 90), (external_radius - diametral_thickness / 2) * cos(i * 90), 0] - display_tolerance_z) cylinder(h = height + 2 * display_tolerance, r = m4_screw_radius, $fn = 30);

// midle screw holes
            for (i = [0 : 3])
                rotate([0, 0, 70])
                translate([14 * sin(i * 90), 14 * cos(i * 90), 0] - display_tolerance_z) cylinder(h = height + 2 * display_tolerance, r = m3_screw_radius, $fn = 30);
        
        // centre hole
        cylinder (r = 6, h = height + 1, $fn = 50);
	}
    }
}
//--------------------------------------------------------------------
module wheel_middle_with_bearing_external(external_radius = 84)
{
    screw_case_height = rb_6907_thick;
    color (plastic_color) 
   // render()
    {
    height = 4;
    screw_length = external_radius - 24;
    
    diametral_thickness = 10;
    
	difference(){
      // traction teeth
      union(){
            cylinder (r = external_radius + 9, h = 3, $fn = 100);
          
            translate([0, 0, 3]) cylinder (r2 = external_radius, r1 = external_radius + 9, h = height - 3, $fn = 100);
          hull(){
              translate([0, 0, 3]) cylinder (r = external_radius - 10, h = height - 3, $fn = 100);
          // bearing case
          cylinder (h = screw_case_height, r = rb_6907_external_radius + 7);
          }
            }

      num_spokes = 8;
      spoke_angle = 360 / num_spokes;
      // holes for saving material
	  for ( i = [0 : 1 : num_spokes] )	
		rotate([i * spoke_angle, 90, 0]){
          translate ([0, 0, external_radius - screw_length + 6]){
          hull(){
            translate ([height / 2, 0, 0])         
                    cylinder(h = screw_length - 8, r1 = 4, r2 = 14, $fn = 6, center = false);
            translate ([-height / 2, 0, 0])         
                    cylinder(h = screw_length - 8, r1 = 4, r2 = 14, $fn = 6, center = false);
                }
            }
        }

// 4 holes for fixing the part to the next ones
               diametral_thickness = 10; 
            for (i = [0 : 7])
                rotate([0, 0, 23])
                translate([(external_radius - diametral_thickness / 2) * sin(i * 45), (external_radius - diametral_thickness / 2) * cos(i * 45), 0] - display_tolerance_z) cylinder(h = height + 2 * display_tolerance, r = m4_screw_radius, $fn = 30);

// middle screw holes
            for (i = [0 : 7])
                 rotate([0, 0, 68])
                translate([(rb_6907_external_radius + 3) * sin(i * 45), (rb_6907_external_radius + 3) * cos(i * 45), 0] - display_tolerance_z) cylinder(h = screw_case_height + 2 * display_tolerance, r = m4_screw_radius, $fn = 30);
        // centre hole
       // cylinder (r = rb_6907_external_radius - 2, h = height + 1, $fn = 50);
        // bearing hole
        translate (-display_tolerance_z) cylinder (r = rb_6907_external_radius, h = rb_6907_thick + 2 * display_tolerance, $fn = 50, center = false);
	}
    }
}
//--------------------------------------------------------------------
module wheel_middle_with_bearing_internal(external_radius = 84)
{
    color (plastic_color) 
    //render()
    {
    height = 4;
    screw_length = external_radius - 24;
    
    diametral_thickness = 10;
    
	difference(){
      // traction teeth
      union(){
            cylinder (r = external_radius + 9, h = 3, $fn = 100);
            translate([0, 0, 3]) cylinder (r2 = external_radius, r1 = external_radius + 9, h = height - 3, $fn = 100);
            }

      num_spokes = 8;
      spoke_angle = 360 / num_spokes;
      // holes for saving material
	  for ( i = [0 : 1 : num_spokes] )	
		rotate([i * spoke_angle, 90, 0]){
          translate ([0, 0, external_radius - screw_length + 4]){
          hull(){
            translate ([height / 2, 0, 0])         
                    cylinder(h = screw_length - 8, r1 = 4, r2 = 14, $fn = 6, center = false);
            translate ([-height / 2, 0, 0])         
                    cylinder(h = screw_length - 8, r1 = 4, r2 = 14, $fn = 6, center = false);
                }
            }
        }

// 4 holes for fixing the part to the next ones	
        diametral_thickness = 10; 
            for (i = [0 : 3])
                rotate([0, 0, 23])
                translate([(external_radius - diametral_thickness / 2) * sin(i * 90), (external_radius - diametral_thickness / 2) * cos(i * 90), 0] - display_tolerance_z) cylinder(h = height + 2 * display_tolerance, r = m4_screw_radius, $fn = 30);

// midle screw holes
            for (i = [0 : 3])
                 rotate([0, 0, 70])
                translate([(rb_6905_external_radius + 3.5) * sin(i * 90), (rb_6905_external_radius + 3.5) * cos(i * 90), 0] - display_tolerance_z) cylinder(h = height + 2 * display_tolerance, r = m3_screw_radius, $fn = 30);
        
        // centre hole
        cylinder (r = rb_6905_external_radius - 2, h = height + 1, $fn = 50);
	}
    }
}
//--------------------------------------------------------------------


module wheel_middle_external_with_teeth(radius, height, steps)
{
    wheel_extension_with_teeth(radius, height + 5, steps);
    wheel_middle_external(radius);
    translate ([0, 0, height + 4 + 3]) mirror ([0, 0, 1]) wheel_wall(radius, 3);
}
//--------------------------------------------------------------------
module wheel_with_teeths(external_radius = 84, steps = 24)// radius = 42, steps = 12
{
    color (plastic_color) 
    render()
    {
    height = 10;
    screw_length = external_radius - 24;
    angle_step = 360/steps;
    diametral_thickness = 10;
    
	difference(){
      // traction teeth
      union(){
		cylinder (r = external_radius, h = height, $fn = 100, center = true);
		for ( i = [0 : 1 : steps] )	
    		rotate([0, 0, i * angle_step]){
                translate ([external_radius -0.3, 0, height / 2])
                    color("red") rotate([0, 90, 0]) tooth(height);
                
           //     translate ([0, 0, external_radius + 4 - 0.3])
           //         color("red") cylinder(h = 4, r2 = 1.5, r1 = 6, $fn = 30, center = false);
            }

      }
      
      num_spokes = 8;
      spoke_angle = 360 / num_spokes;
      // holes for saving material
	  for ( i = [0 : 1 : num_spokes] )	
		rotate([i * spoke_angle, 90, 0]){
          translate ([0, 0, external_radius - screw_length - 8]){
          hull(){
            translate ([height / 2, 0, 0])         
                    cylinder(h = screw_length - 2, r1 = 4, r2 = 14, $fn = 6, center = false);
            translate ([-height / 2, 0, 0])         
                    cylinder(h = screw_length - 2, r1 = 4, r2 = 14, $fn = 6, center = false);
                }
            }
        }

// 4 holes for fixing the part to the next ones	
		for ( i = [0 : 1 : 4] ){
			rotate ([0, 0, spoke_angle / 2]) translate([(external_radius - diametral_thickness / 2) * sin(i * 90), (external_radius - diametral_thickness / 2) * cos(i * 90), 0]) cylinder(h = height + 2 * display_tolerance, r = 2, $fn = 30, center = true);
			//translate([(20) * sin(i*90+16), (20) * cos(i*90+16), 0]) cylinder(h=thick, r = 2, $fn = 20, center = true);
		}
        
        // centre hole
        cylinder (r = 6, h = height + 1, $fn = 100, center = true);
        translate ([0, 0, height / 2 - 7]) cylinder (r = M12_nut_radius, h = M12_nut_thick + display_tolerance, $fn = 6, center = false);
	}
    }
}
//--------------------------------------------------------------------
module wheel_extension(radius = 42.5, _h = 8, num_faces_nut_holes = 6)
{
    color (plastic_color) 
    render()
    {
        diametral_thickness = 12;
        difference(){
            union(){
                cylinder (r = radius, h = _h, $fn = 100);
                cylinder (r = radius + 5, h = 3, $fn = 100);

            }
            translate (-display_tolerance_z) cylinder (r = radius - diametral_thickness, h = _h + 2 * display_tolerance, $fn = 100);
            // screw holes
            for (i = [0 : 3])
                translate([(radius - diametral_thickness / 2) * sin(i * 90), (radius - diametral_thickness / 2) * cos(i * 90), 0] - display_tolerance_z) cylinder(h = _h + 2 * display_tolerance, r = m4_screw_radius, $fn = 30);
            // nuts holes
            for (i = [0 : 3])
                translate([(radius - diametral_thickness / 2) * sin(i * 90), (radius - diametral_thickness / 2) * cos(i * 90), 0] - display_tolerance_z) rotate ([0, 0, 30 * (i % 2)]) cylinder(h = m4_nut_thick + display_tolerance, r = m4_nut_radius, $fn = num_faces_nut_holes);
            
        }
    }
}
//--------------------------------------------------------------------
module tracks_on_half_wheel(num_tracks_per_circle, wheel_radius, start_angle = 0)
{
    step = 360 / num_tracks_per_circle;
    
    tracks_on_circle(num_tracks_per_circle, wheel_radius, start_angle, num_tracks_per_circle / 2 + 1);
}
//--------------------------------------------------------------------
module second_wheel_with_shaft(num_tracks_per_circle, wheel_radius)
{
    space_between_wheels = 18;
    // screw axis
    translate ([0, 0, -6]) 
      M12_hexa(150);
    // traction wheel
    wheel_with_teeths(wheel_radius, num_tracks_per_circle);
    // bottom extension wheel
    translate ([0, 0, -6 -8 -space_between_wheels])
    wheel_extension(tracks_wheel_radius, 12, 18, 6);
    // top extension wheel
    translate ([0, 0, 6 + 8 + space_between_wheels])
    mirror([0, 0, 1])
    wheel_extension(tracks_wheel_radius, 12, 18, 6);
    
    // screws for glueing plastic parts
    
    for (i = [0 : 3]){
      translate([(wheel_radius - 5) * sin(i * 90), (wheel_radius - 5) * cos(i * 90), -6 - 8 - space_between_wheels - m4_nut_thick]) M4_hexa(70);
      translate([(wheel_radius - 5) * sin(i * 90), (wheel_radius - 5) * cos(i * 90), 6 + 8 + space_between_wheels]) M4_autolock_nut();
    }
    
    // spacer
    translate ([0, 0, 6])
    M12_washer();
    // nut
    translate ([0, 0, 6 + washer_12_thick]) M12_nut();
    // long nut
   translate ([0, 0, 6 + washer_12_thick]) M12_long_nut();
    // long nut
   translate ([0, 0, 6 + washer_12_thick + M12_long_nut_thick]) M12_long_nut();
}
//--------------------------------------------------------------------
module tracks_on_2_wheels(num_tracks_per_half_circle, wheel_radius, distance_between_wheels)
{
    rotate ([90, 0, 0]) tracks_on_half_wheel(num_tracks_per_half_circle, wheel_radius);
    translate ([-distance_between_wheels, 0, 0]) mirror([1, 0, 0]) rotate ([90, 0, 0]) tracks_on_half_wheel(num_tracks_per_half_circle, wheel_radius);
    
    translate ([-distance_between_wheels - 12, -track_size[0] / 2, -wheel_radius - track_size[2]]) string_of_tracks(9);
    translate ([-distance_between_wheels - 12, -track_size[0] / 2, wheel_radius + track_size[2]]) mirror([0, 0, 1]) string_of_tracks(9);
}
//--------------------------------------------------------------------
module first_wheel_with_shaft(num_tracks_per_circle, wheel_radius)
{
    space_between_wheels = 18;
    // screw axis
    translate ([0, 0, -6]) 
      M12_hexa(150);
    // traction wheel
    wheel_with_teeths(wheel_radius, num_tracks_per_circle);
    // bottom extension wheel
    translate ([0, 0, -6 -8 -space_between_wheels])
    wheel_extension(tracks_wheel_radius, 12, 18, 6);
    // top extension wheel
    translate ([0, 0, 6 + 8 + space_between_wheels])
    mirror([0, 0, 1])
    wheel_extension(tracks_wheel_radius, 12, 18, 6);
    
    // screws for glueing plastic parts
    
    for (i = [0 : 3]){
      translate([(wheel_radius - 5) * sin(i * 90), (wheel_radius - 5) * cos(i * 90), -6 - 8 - space_between_wheels - m4_nut_thick]) M4_hexa(70);
      translate([(wheel_radius - 5) * sin(i * 90), (wheel_radius - 5) * cos(i * 90), 6 + 8 + space_between_wheels]) M4_autolock_nut();
    }
    
    // spacer
    translate ([0, 0, 6]) M12_washer();
    // long nut
   translate ([0, 0, 6 + washer_12_thick]) M12_long_nut();
    // gear
    translate ([0, 0, 6 + washer_12_thick + M12_long_nut_thick + wheel_gear_height - wheel_gear_nut_depth]) mirror([0, 0, 1]) wheel_gear();
    // washer
    translate ([0, 0, 6 + washer_12_thick + M12_long_nut_thick + wheel_gear_height - wheel_gear_nut_depth]) M12_washer();
    // nut
   translate ([0, 0, 6 + washer_12_thick + M12_long_nut_thick + wheel_gear_height - wheel_gear_nut_depth + washer_12_thick]) M12_nut();
    // nut
   translate ([0, 0, 6 + washer_12_thick + M12_long_nut_thick + wheel_gear_height - wheel_gear_nut_depth + washer_12_thick + M12_nut_thick]) M12_nut();
    // nut
   translate ([0, 0, 6 + washer_12_thick + M12_long_nut_thick + wheel_gear_height - wheel_gear_nut_depth + washer_12_thick + 2 * M12_nut_thick]) M12_nut();

}

//--------------------------------------------------------------------
module motor_gear()
{
    extra_length =  10;
    
    difference(){
        rotate ([0, 0, 7.5])
        color(plastic_color)
            gear (number_of_teeth = 25,
					circular_pitch = 500,
					bore_diameter = 10,
					hub_diameter = 30,
					rim_width = 4,
					hub_thickness = motor_gear_height + extra_length,
					rim_thickness = motor_gear_height,
					gear_thickness = motor_gear_height,
					pressure_angle = 31);
        // motor shaft hole
        //translate (-display_tolerance_z) cylinder (h = motor_gear_height + extra_length + 2 * display_tolerance, r = 5, $fn = 30);
        
        // 1st screw hole
        translate ([0, 0, motor_gear_height / 2]) rotate ([0, 90, 0]) cylinder(h = 50, r = m4_screw_radius, $fn = 20);
        // 1st nut hole
        hull(){
            translate ([7, 0, motor_gear_height / 2]) rotate ([0, 90, 0]) cylinder(h = 2 * m4_nut_thick, r = m4_nut_radius, $fn = 6);
            translate ([7, 0, 0]) rotate ([0, 90, 0]) cylinder(h = 2 * m4_nut_thick, r = m4_nut_radius, $fn = 6);
        }
        // 2nd screw hole
        translate ([0, 0, motor_gear_height + extra_length / 2]) rotate ([0, 90, 0]) cylinder(h = 50, r = m4_screw_radius, $fn = 20);
        // 2nd nut hole
        hull(){
            translate ([7, 0, motor_gear_height + extra_length / 2]) rotate ([0, 90, 0]) cylinder(h = m4_nut_thick, r = m4_nut_radius, $fn = 6);
            translate ([7, 0, motor_gear_height + extra_length]) rotate ([0, 90, 0]) cylinder(h = m4_nut_thick, r = m4_nut_radius, $fn = 6);
        }
    }
}
//--------------------------------------------------------------------
module wheel_gear()
{    
    difference(){
        rotate ([0, 0, 12]) gear (number_of_teeth=14,
					circular_pitch=500,
					bore_diameter=0,
					hub_diameter=0,
					rim_width=4,
					hub_thickness=4,
					rim_thickness=wheel_gear_height,
					gear_thickness=wheel_gear_height,
					pressure_angle=31);
        // M12 screw hole
        translate (-display_tolerance_z) cylinder(h = wheel_gear_height + 2 * display_tolerance, r = 6, $fn = 40);
        // M12 nut hole
        translate ([0, 0, wheel_gear_height - wheel_gear_nut_depth]) cylinder(h = wheel_gear_nut_depth + display_tolerance, r = M12_nut_radius, $fn = 6);
    }
}
//--------------------------------------------------------------------
module base_motor_with_housing()
{
    motor_gr_ep_45_housing_with_base_holes();
   
    translate ([motor_gr_ep_45_radius + base_wall_dc_motor_housing_thick + 2, motor_gr_ep_45_radius + side_wall_dc_motor_housing_thick, motor_gr_ep_45_188_1_length + 3]) mirror([0, 0, 1]) motor_gr_ep_45_188_1();
    
    translate ([motor_gr_ep_45_radius + base_wall_dc_motor_housing_thick + 2, motor_gr_ep_45_radius + side_wall_dc_motor_housing_thick, -20]) motor_gear();
}
//--------------------------------------------------------------------
module platform_sheet()
{
  difference(){    
    cube(base_platform_size);
    
    // holes  
    // LEFT SIDE
      echo("LEFT SIDE");
    // first wheel, first bearing
    for (i = [0 : 1]){
        translate ([first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2, wheels_bearing_housing_1_offset_y, 0] + rbearing_6201_enclosed_housing_holes_position[i] - display_tolerance_z)
    cylinder (h = base_platform_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);
        echo("first shaft first bearing",  [first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2, wheels_bearing_housing_1_offset_y, 0] + rbearing_6201_enclosed_housing_holes_position[i]);
    }
    // first wheel, second bearing
       for (i = [0 : 1]){
    translate ([first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2, wheels_bearing_housing_2_offset_y, 0] + rbearing_6201_enclosed_housing_holes_position[i] - display_tolerance_z)
    cylinder (h = base_platform_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);
        echo("first shaft second bearing",  [first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2, wheels_bearing_housing_2_offset_y, 0] + rbearing_6201_enclosed_housing_holes_position[i]);
    }
    // second wheel, first bearing
    for (i = [0 : 1]){
        translate ([first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2 + distance_between_wheels, wheels_bearing_housing_1_offset_y, 0] + rbearing_6201_enclosed_housing_holes_position[i] - display_tolerance_z)
    cylinder (h = base_platform_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);
        echo("second shaft first bearing",  [first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2 + distance_between_wheels, wheels_bearing_housing_1_offset_y, 0] + rbearing_6201_enclosed_housing_holes_position[i]);
    }
    // second gear, second bearing
    for (i = [0 : 1]){
        translate ([first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2 + distance_between_wheels, wheels_bearing_housing_2_offset_y, 0] + rbearing_6201_enclosed_housing_holes_position[i] - display_tolerance_z)
    cylinder (h = base_platform_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);
        echo("second shaft second bearing",  [first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2 + distance_between_wheels, wheels_bearing_housing_2_offset_y, 0] + rbearing_6201_enclosed_housing_holes_position[i]);
    }
    
    // holes for motor housing
    for (i = [0 : 3]){
        echo("motor housing holes = ", [motor_gr_ep_45_housing_size[1] / 2 + base_motor_offset, (motor_gr_ep_45_housing_size[2] - motor_wall_dc_motor_housing_thick)/ 2 + motor_wall_dc_motor_housing_thick, 0] + rotate_z(90, motor_gr_ep_45_housing_small_base_holes[i]));
        translate ([motor_gr_ep_45_housing_size[1] / 2 + base_motor_offset, (motor_gr_ep_45_housing_size[2] - motor_wall_dc_motor_housing_thick) / 2 + motor_wall_dc_motor_housing_thick, 0]) rotate ([0, 0, 90]) translate (motor_gr_ep_45_housing_small_base_holes[i] - display_tolerance_z) cylinder (h = base_platform_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);
    }
    
    // hole for track tensioner support
        echo("track tensioner support = ", [dist_to_tracks_tensioner_support + tracks_tensioner_support_size[0] / 2, 20, 0]);
    
    translate([dist_to_tracks_tensioner_support + tracks_tensioner_support_size[0] / 2, 20, 0] - display_tolerance_z) cylinder (h = base_platform_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);
    
    // RIGHT SIDE
    echo("RIGHT SIDE");
     // first gear, first bearing
    for (i = [0 : 1]){
        translate ([0, base_platform_size[1], 0]) mirror([0, 1, 0]) translate ([first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2, wheels_bearing_housing_1_offset_y, 0] + rbearing_6201_enclosed_housing_holes_position[i] - display_tolerance_z)
    cylinder (h = base_platform_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);
        echo("first shaft first bearing",  [0, base_platform_size[1], 0] + mirror_y([first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2, wheels_bearing_housing_1_offset_y, 0] + rbearing_6201_enclosed_housing_holes_position[i]));
    }
  
    // first gear, second bearing
    for (i = [0 : 1]){
        translate ([0, base_platform_size[1], 0]) mirror([0, 1, 0]) translate ([first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2, wheels_bearing_housing_2_offset_y, 0] + rbearing_6201_enclosed_housing_holes_position[i] - display_tolerance_z)
    cylinder (h = base_platform_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);
        echo("first shaft second bearing",  [0, base_platform_size[1], 0] + mirror_y([first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2, wheels_bearing_housing_2_offset_y, 0] + rbearing_6201_enclosed_housing_holes_position[i]));
    }
    
    /// second gear, first bearing
    for (i = [0 : 1]){
        translate ([0, base_platform_size[1], 0]) mirror([0, 1, 0]) translate ([first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2 + distance_between_wheels, wheels_bearing_housing_1_offset_y, 0] + rbearing_6201_enclosed_housing_holes_position[i] - display_tolerance_z)
    cylinder (h = base_platform_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);
        echo("second shaft first bearing",  [0, base_platform_size[1], 0] + mirror_y([first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2 + distance_between_wheels, wheels_bearing_housing_1_offset_y, 0] + rbearing_6201_enclosed_housing_holes_position[i]));
    }
    // second gear, second bearing
    for (i = [0 : 1]){
        translate ([0, base_platform_size[1], 0]) mirror([0, 1, 0]) translate ([first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2 + distance_between_wheels, wheels_bearing_housing_2_offset_y, 0] + rbearing_6201_enclosed_housing_holes_position[i] - display_tolerance_z)
    cylinder (h = base_platform_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);
        echo("second shaft second bearing",  [0, base_platform_size[1], 0] + mirror_y([first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2 + distance_between_wheels, wheels_bearing_housing_1_offset_y, 0] + rbearing_6201_enclosed_housing_holes_position[i]));
    }
    
    // holes for motor housing
    for (i = [0 : 3]){
        echo("motor housing holes = ", [base_motor_offset, base_platform_size[1], 0] + mirror_y([motor_gr_ep_45_housing_size[1] / 2, (motor_gr_ep_45_housing_size[2] - motor_wall_dc_motor_housing_thick) / 2 + motor_wall_dc_motor_housing_thick, 0] + rotate_z(90, motor_gr_ep_45_housing_small_base_holes[i])) );
        translate ([base_motor_offset, base_platform_size[1], 0]) mirror([0, 1, 0]) translate ([motor_gr_ep_45_housing_size[1] / 2, (motor_gr_ep_45_housing_size[2] - motor_wall_dc_motor_housing_thick) / 2 + motor_wall_dc_motor_housing_thick, 0]) rotate ([0, 0, 90]) translate (motor_gr_ep_45_housing_small_base_holes[i] - display_tolerance_z) cylinder (h = base_platform_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 20);
    }
    // hole for track tensioner support
    echo("track tensioner support = ", [dist_to_tracks_tensioner_support + tracks_tensioner_support_size[0] / 2, base_platform_size[1] - 20, 0]);
    
    translate([dist_to_tracks_tensioner_support + tracks_tensioner_support_size[0] / 2, base_platform_size[1] - 20, 0] - display_tolerance_z) cylinder (h = base_platform_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);
    
    // leg support holes - first spacer
    translate([leg_postion_on_platform + dist_to_first_bone, base_platform_size[1] / 2 - dist_to_foot_spacer_hole, 0] - display_tolerance_z) cylinder (h = base_platform_size[2] + 2 * display_tolerance, r = m8_screw_radius, $fn = 10);
    translate([leg_postion_on_platform + dist_to_first_bone, base_platform_size[1] / 2 + dist_to_foot_spacer_hole, 0] - display_tolerance_z) cylinder (h = base_platform_size[2] + 2 * display_tolerance, r = m8_screw_radius, $fn = 10);
    
    // leg support holes - second spacer
    translate([leg_postion_on_platform + dist_to_second_bone, base_platform_size[1] / 2 - dist_to_foot_spacer_hole, 0] - display_tolerance_z) cylinder (h = base_platform_size[2] + 2 * display_tolerance, r = m8_screw_radius, $fn = 10);
    translate([leg_postion_on_platform + dist_to_second_bone, base_platform_size[1] / 2 + dist_to_foot_spacer_hole, 0] - display_tolerance_z) cylinder (h = base_platform_size[2] + 2 * display_tolerance, r = m8_screw_radius, $fn = 10);
  }  
}
//-------------------------------------------------------
module laptop_fixer_corner_left()
{
  difference(){
    color (plastic_color) corner(40, 40, 40, 3);
    hull(){
        translate ([3 + 5, 10, 0] - display_tolerance_z) cylinder(h = 3 + 2 * display_tolerance, r = m4_screw_radius, $fn = 20);
        translate ([3 + 5, 40 - (6), 0] - display_tolerance_z) cylinder(h = 3 + 2 * display_tolerance, r = m4_screw_radius, $fn = 20);
    }
  }
}
//--------------------------------------------------------------------
module laptop_fixer_corner_right()
{
  difference(){
    color (plastic_color) corner(40, 40, 40, 3);
    hull(){
        translate ([10, 3 + 5, 0] - display_tolerance_z) cylinder(h = 3 + 2 * display_tolerance, r = m4_screw_radius, $fn = 20);
        translate ([40 - 6, 3 + 5, 0] - display_tolerance_z) cylinder(h = 3 + 2 * display_tolerance, r = m4_screw_radius, $fn = 20);
    }
  }
}
//--------------------------------------------------------------------
module base_motor_pulley()
{  
  pulley_t_ht = 8;	// length of toothed part of pulley
  pulley_base_height = 1.5;
  difference(){    
    rotate ([0, 0, 10.8]) pulley_with_shaft(68, 17, 0, 0, 8, 5, 0, 0);
        
        // M4 screw hole
    translate ([0, 0, pulley_t_ht / 2 + pulley_base_height]) rotate ([-90, 0, 0]) cylinder (h = 40, r = m4_screw_radius, $fn = 25);
        
        // M4 nut hole
    translate ([0, 3.6, pulley_t_ht / 2 + pulley_base_height]) rotate ([-90, 30, 0]) cylinder (h = m4_nut_thick + 0.2 + 1.4, r = m4_nut_radius + 0.1, $fn = 6);
  }
}
//--------------------------------------------------------------------
module radial_bearing_housing_with_bearing()
{
    radial_bearing_6201_vertical_housing(0);
    translate ([rbearing_6201_enclosed_housing_size[0] / 2, radial_bearing_vertical_housing_grosime_perete_lateral_latime, rb_6201_external_radius + radial_bearing_vertical_housing_base_wall_thick ]) rotate ([-90, 0, 0]) 6201rs();
}
//--------------------------------------------------------------------
module tracks_tensioner()
{
    color (plastic_color) 
        difference(){
            hull(){
                cube(tracks_tensioner_size);
                translate ([tracks_tensioner_size[0] / 2, 0, tracks_tensioner_size[2]]) rotate ([-90, 0, 0]) cylinder(h = tracks_tensioner_size[1], r = tracks_tensioner_size[0] / 2);
            }

// hole for M8 screw
            translate ([tracks_tensioner_size[0] / 2, 0, tracks_tensioner_size[2] + 2] - display_tolerance_y) rotate ([-90, 0, 0]) cylinder(h = tracks_tensioner_size[1] + 2 * display_tolerance, r = 4);
            
            // base screw hole
            translate ([tracks_tensioner_size[0] / 2, tracks_tensioner_size[1] / 2, 0] - display_tolerance_z) cylinder(h = 30, r = m4_screw_radius, $fn = 14);
            // base nut hole
            hull(){
            translate ([tracks_tensioner_size[0] / 2, tracks_tensioner_size[1] / 2, 25] - display_tolerance_z) rotate([0, 0, 30]) cylinder(h = m4_nut_thick, r = m4_nut_radius, $fn = 6);
            translate ([tracks_tensioner_size[0] / 2, tracks_tensioner_size[1], 25] - display_tolerance_z) rotate([0, 0, 30]) cylinder(h = m4_nut_thick, r = m4_nut_radius, $fn = 6);
            }

    }
}
//--------------------------------------------------------------------
module tracks_tensioner_support()
{
    difference(){
        color (aluminium_color) 
        cube(tracks_tensioner_support_size);
        // holes for screws
// tracks tensioner screw holes
        translate([tracks_tensioner_support_size[0] / 2, 6, 0] - display_tolerance_z) cylinder (h = tracks_tensioner_support_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);
        translate([tracks_tensioner_support_size[0] / 2, 74, 0] - display_tolerance_z) cylinder (h = tracks_tensioner_support_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);
// tracks tensioner screw holes - other side
        translate([tracks_tensioner_support_size[0] / 2, tracks_tensioner_support_size[1] - 6, 0] - display_tolerance_z) cylinder (h = tracks_tensioner_support_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);
        translate([tracks_tensioner_support_size[0] / 2, tracks_tensioner_support_size[1] - 74, 0] - display_tolerance_z) cylinder (h = tracks_tensioner_support_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);
        
        // base plarform screw
        translate([tracks_tensioner_support_size[0] / 2, track_size[0] + tracks_offset + 20, 0] - display_tolerance_z) cylinder (h = tracks_tensioner_support_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);

        translate([tracks_tensioner_support_size[0] / 2, tracks_tensioner_support_size[1] - (track_size[0] + tracks_offset + 20), 0] - display_tolerance_z) cylinder (h = tracks_tensioner_support_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);
        
    }
}
//--------------------------------------------------------------------
module tracks_support()
{
    difference(){
        color (aluminium_color) 
        cube(tracks_support_size);
        // base plarform screw
        translate([tracks_support_size[0] / 2, track_size[0] + tracks_offset + 20, 0] - display_tolerance_z) cylinder (h = tracks_support_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);

        translate([tracks_support_size[0] / 2, tracks_support_size[1] - (track_size[0] + tracks_offset + 20), 0] - display_tolerance_z) cylinder (h = tracks_support_size[2] + 2 * display_tolerance, r = m4_screw_radius, $fn = 10);
    }
}
//--------------------------------------------------------------------
module tracks_tensioner_support_with_pieces()
{
    tracks_tensioner_support();
    
    translate ([-tracks_tensioner_size[0] / 2 + tracks_tensioner_support_size[0] / 2, 0, tracks_tensioner_support_size[2]]) tracks_tensioner();
    translate ([-tracks_tensioner_size[0] / 2 + tracks_tensioner_support_size[0] / 2, 60, tracks_tensioner_support_size[2]]) tracks_tensioner();

    translate ([-tracks_tensioner_size[0] / 2 + tracks_tensioner_support_size[0] / 2, tracks_tensioner_support_size[1] - tracks_tensioner_size[1], tracks_tensioner_support_size[2]]) tracks_tensioner();
    translate ([-tracks_tensioner_size[0] / 2 + tracks_tensioner_support_size[0] / 2, tracks_tensioner_support_size[1] - 70, tracks_tensioner_support_size[2]]) tracks_tensioner();
}
//--------------------------------------------------------------------
module platform()
{
  platform_sheet();
    
    // reinforcement aluminium L profiles
    // left side
    translate ([0, -3, 3 + base_platform_size[2]]) rotate ([180, 0, 0]) rotate ([0, 0, -90]) L_profile(base_platform_size[0], edge_1_width = 25, edge_2_width = 25, wall_thick = 3);
    // right side
    translate ([0, base_platform_size[1] + 3, 3 + base_platform_size[2]]) rotate ([90, 0, 0]) rotate ([0, 0, -90]) L_profile(base_platform_size[0], edge_1_width = 25, edge_2_width = 25, wall_thick = 3);

  // motor right
    
  translate ([base_motor_offset, base_platform_size[1], 0]) 
    rotate([90, 0, 0])
      rotate([0, 0, -90]) 
        base_motor_with_housing();
    
    // motor left
  translate ([motor_gr_ep_45_housing_size[1] + base_motor_offset, 0, 0])
    //rotate([0, 0, 180])
      rotate([-90, 0, 0])
        rotate([0, 0, 90]) 
          base_motor_with_housing();
    
// first wheel    
    // first radial bearing housing
    translate ([first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2, wheels_bearing_housing_1_offset_y, -rbearing_6201_enclosed_housing_size[2]]) radial_bearing_housing_with_bearing();
   
    // second radial bearing housing
    translate ([first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2, wheels_bearing_housing_2_offset_y, -rbearing_6201_enclosed_housing_size[2]]) radial_bearing_housing_with_bearing();

// second shaft
    // first radial bearing housing
    translate ([first_tracks_offset + distance_between_wheels - rbearing_6201_enclosed_housing_size[0] / 2, wheels_bearing_housing_1_offset_y, -rbearing_6201_enclosed_housing_size[2]]) radial_bearing_housing_with_bearing();
   
    // second radial bearing housing
    translate ([first_tracks_offset + distance_between_wheels - rbearing_6201_enclosed_housing_size[0] / 2, wheels_bearing_housing_2_offset_y, -rbearing_6201_enclosed_housing_size[2]]) radial_bearing_housing_with_bearing();

// wheels
    
    translate ([0, -track_size[0] / 2 - tracks_offset, 0]) {
            
    //first gear
        translate ([first_tracks_offset, 0, -rb_6201_external_radius]) rotate([-90, 0, 0]) first_wheel_with_shaft(num_tracks_per_circle, tracks_wheel_radius);
    
    //second gear
        translate ([first_tracks_offset + distance_between_wheels, 0, -rb_6201_external_radius]) rotate([-90, 0, 0]) second_wheel_with_shaft(num_tracks_per_circle, tracks_wheel_radius);

        //tracks
   translate ([distance_between_wheels + first_tracks_offset, 0, -rb_6201_external_radius]) 
        tracks_on_2_wheels(num_tracks_per_circle, tracks_wheel_radius, distance_between_wheels);
    }

// other side

    

    translate ([0, base_platform_size[1], 0])
        mirror([0, 1, 0]){  
        // first radial bearing housing
            translate ([first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2, wheels_bearing_housing_1_offset_y, -rbearing_6201_enclosed_housing_size[2]]) radial_bearing_6201_vertical_housing(0);
   
    // second radial bearing housing
            translate ([first_tracks_offset - rbearing_6201_enclosed_housing_size[0] / 2, wheels_bearing_housing_2_offset_y, -rbearing_6201_enclosed_housing_size[2]]) radial_bearing_6201_vertical_housing(0);
        
// second shaft
    // first radial bearing housing
            translate ([first_tracks_offset + distance_between_wheels - rbearing_6201_enclosed_housing_size[0] / 2, wheels_bearing_housing_1_offset_y, -rbearing_6201_enclosed_housing_size[2]]) radial_bearing_housing_with_bearing();
   
    // second radial bearing housing
            translate ([first_tracks_offset + distance_between_wheels - rbearing_6201_enclosed_housing_size[0] / 2, wheels_bearing_housing_2_offset_y, -rbearing_6201_enclosed_housing_size[2]]) radial_bearing_housing_with_bearing();
        
        }

    translate([0, base_platform_size[1] + track_size[0] / 2 + tracks_offset, 0]){
    // first wheel
        translate ([first_tracks_offset, 0, -rb_6201_external_radius]) rotate([90, 0, 0]) first_wheel_with_shaft(num_tracks_per_circle, tracks_wheel_radius);
    // second wheel
        translate ([first_tracks_offset + distance_between_wheels, 0, -rb_6201_external_radius]) mirror([0, 1, 0]) rotate([-90, 0, 0]) second_wheel_with_shaft(num_tracks_per_circle, tracks_wheel_radius);

    // tracks
    translate ([distance_between_wheels + first_tracks_offset, 0, -rb_6201_external_radius]) 
        tracks_on_2_wheels(num_tracks_per_circle, tracks_wheel_radius, distance_between_wheels);

}
    // back wheel
    
    translate ([base_platform_size[0] + 100, base_platform_size[1]/2, -rb_6201_external_radius - tracks_wheel_radius - track_size[2] + chair_wheel_radius]) rotate ([0, 0, 90]) chair_wheel();
    
    // laptop
    translate ([base_platform_size[0] - laptop13_size[1], laptop13_size[0] / 2 + base_platform_size[1] / 2, 50]) rotate ([0, 0, 0]) rotate ([0, 0, -90]) translate ([0, 0, base_platform_size[2]]) laptop13();

    // lidar

    translate([lidar_position, base_platform_size[1] / 2, base_platform_size[2]]) rotate([0, 0, 90]) tera_ranger_one_lidar();

// tracks tensioner support
translate ([dist_to_tracks_tensioner_support, - 80 - tracks_offset + 10, -4 - tracks_tensioner_support_size[2] - 20]) tracks_tensioner_support_with_pieces();

translate ([dist_to_tracks_support1, - 80 - tracks_offset, -4 - tracks_tensioner_support_size[2]])
tracks_support();

translate ([dist_to_tracks_support2, - 80 - tracks_offset, -4 - tracks_tensioner_support_size[2]])
tracks_support();

// batteries
    //translate([base_platform_size[0] - laptop13_size[1], -LiFePO4_20Ah_size[1] / 2 + base_platform_size[1] / 2, base_platform_size[2]]) LiFePO4_20Ah();
    translate([base_platform_size[0] - laptop13_size[1], 0, base_platform_size[2]]) multistar_4s_16000();
    translate([base_platform_size[0] - laptop13_size[1], base_platform_size[1] - multistar_4s_16000_size[1], base_platform_size[2]]) multistar_4s_16000(); 
}
//--------------------------------------------------------------------


platform();


//tracks_tensioner();
//track_tensioner_support_with_pieces();

//platform_sheet(); 

//motor_gear();
//wheel_gear();

//second_wheel_with_shaft(num_tracks_per_circle, tracks_wheel_radius);

//first_wheel_with_shaft(num_tracks_per_circle, tracks_wheel_radius);

//base_motor_pulley();

//motor_housing_with_components();

//base_motor_with_housing();

//tracks_on_half_wheel(num_tracks_per_circle, tracks_wheel_radius);

//tracks_on_2_wheels(num_tracks_per_circle, tracks_wheel_radius, 200);

//string_of_tracks (10);

//wheel_traction_pulley();

//wheel_with_teeths(tracks_wheel_radius, num_tracks_per_circle);

//wheel_extension_with_teeth(radius = 54.66 * 0.955,  height = 10, steps = 20);

//wheel_wall(radius = 54.66 * 0.955, height = 4);

//wheel_middle_external(external_radius = 54.66 * 0.955);

//wheel_middle_internal(external_radius = 54.66 * 0.955);

//wheel_middle_external_with_teeth(radius = 54.66 * 0.955, height = 10, steps = 20);

//wheel_middle_with_bearing_external(external_radius = 54.66 * 0.955);
//wheel_middle_with_bearing_internal(external_radius = 54.66 * 0.955);

//tooth(10);

//wheel_extension(tracks_wheel_radius, _h = 10, num_faces_nut_holes = 6); // 4x

//wheel_extension(tracks_wheel_radius, 10, 20); // 4x

//tracks_on_2_wheels(12, 42.5, 200);

//laptop_fixer_corner_left();

//laptop_fixer_corner_right();

//tracks_tensioner(); // 2x

//motor_gr_ep_45_housing_with_base_holes(); // 2x

//radial_bearing_housing_with_bearing();
