// Author: Mihai Oltean, https://mihaioltean.github.io, mihai.oltean@gmail.com
// More details: https://jenny5.org, https://jenny5-robot.github.io/
// Source code: github.com/jenny5-robot
// MIT License
//--------------------------------------------------------------

include <params_basic_components.scad>
include <params_stepper_motors.scad>

    motor_housing_airflow_spacer = 0;

    wall_thick_lateral_motor_housing = wall_thick_2;
	wall_thick_base_motor_housing = wall_thick_3;
	wall_thick_motor_housing = wall_thick_3;

	nema_17_housing_width = nema_17_width + 2 * wall_thick_lateral_motor_housing + 2 * motor_housing_airflow_spacer;
	//motor_housing_height = perete_motor_motor_housing + 40; //wall_thick_base_motor_housing + 40;
    motor_housing_length = nema_17_width + 2 * wall_thick_lateral_motor_housing;
	
	distanta_gauri_baza_motor_housing_nema_17_x = 12;
    distanta_gauri_baza_motor_housing_nema_17_y = 15;
	distanta_gauri_large_baza_motor_housing_nema_17_y = 30;
    
    distance_between_base_holes_nema_17_housing = 8;
    
	nema_17_housing_base_holes = [
	[distanta_gauri_baza_motor_housing_nema_17_x, distanta_gauri_baza_motor_housing_nema_17_y, 0],
	[distanta_gauri_baza_motor_housing_nema_17_x, -distanta_gauri_baza_motor_housing_nema_17_y, 0],
	[-distanta_gauri_baza_motor_housing_nema_17_x, distanta_gauri_baza_motor_housing_nema_17_y, 0],
	[-distanta_gauri_baza_motor_housing_nema_17_x, -distanta_gauri_baza_motor_housing_nema_17_y, 0]
	];
    
    nema_17_housing_small_base_holes_position = [
	[distance_between_base_holes_nema_17_housing, distance_between_base_holes_nema_17_housing, 0],
	[distance_between_base_holes_nema_17_housing, -distance_between_base_holes_nema_17_housing, 0],
	[-distance_between_base_holes_nema_17_housing, distance_between_base_holes_nema_17_housing, 0],
	[-distance_between_base_holes_nema_17_housing, -distance_between_base_holes_nema_17_housing, 0]
	];
	
	nema_17_housing_large_base_holes = [
	[distanta_gauri_baza_motor_housing_nema_17_x, distanta_gauri_large_baza_motor_housing_nema_17_y, 0],
	[distanta_gauri_baza_motor_housing_nema_17_x, -distanta_gauri_large_baza_motor_housing_nema_17_y, 0],
	[-distanta_gauri_baza_motor_housing_nema_17_x, distanta_gauri_large_baza_motor_housing_nema_17_y, 0],
	[-distanta_gauri_baza_motor_housing_nema_17_x, -distanta_gauri_large_baza_motor_housing_nema_17_y, 0]
	];

	distanta_gauri_baza_motor_housing_nema_11 = 10;
    
	nema_11_housing_base_holes = [
	[distanta_gauri_baza_motor_housing_nema_11, distanta_gauri_baza_motor_housing_nema_11, 0],
	[distanta_gauri_baza_motor_housing_nema_11, -distanta_gauri_baza_motor_housing_nema_11, 0],
	[-distanta_gauri_baza_motor_housing_nema_11, distanta_gauri_baza_motor_housing_nema_11, 0],
	[-distanta_gauri_baza_motor_housing_nema_11, -distanta_gauri_baza_motor_housing_nema_11, 0]
	];