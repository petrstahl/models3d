$fa = 1;
$fs = 1;

lsr_pcb_pos = [71, 63.2, 1.7];
lsr_pcb_color = [0, 1, 0];
lsr_transparency = 1;

lsr_pcb_holes_pos = [[2.5, 20, 0], [lsr_pcb_pos[0] - 2.5, 20, 0], [2.5, 60, 0], [lsr_pcb_pos[0] - 2.5, 60, 0]];

lsr_socket_color = [0, 1, 0];
lsr_socket_dim = [33, 14.8, 11.5];
lsr_socket_pos = [-1, 0, lsr_pcb_pos[2]];

lsr_battery_pos = [lsr_pcb_pos[0] + 5, 5, -10];
lsr_battery_size = [26.5, 46.5, 17.5];

box_thick = 2.4;
box_distance = 2;
box_transparency = 0.5;

bottom1_pos = [-box_thick - box_distance, -box_thick - box_distance, lsr_battery_pos[2] - box_thick];
bottom2_pos = [-(box_thick / 2) - box_distance, -(box_thick / 2) - box_distance, lsr_battery_pos[2] - (box_thick / 2)];

bottom1_dim = [lsr_battery_pos[0] + lsr_battery_size[0] + (2 * box_thick) + (2 * box_distance),
			lsr_pcb_pos[1] + (2 * box_thick) + (2 * box_distance),
			box_thick / 2];
bottom2_dim = [	lsr_battery_pos[0] + lsr_battery_size[0] + box_thick + (2 * box_distance),
			lsr_pcb_pos[1] + box_thick + (2 * box_distance),
			box_thick / 2];

hole_distance = 2.5;

socket_handle_diameter = 1.5;
socket_handle_length = 10;
socket_handle_diameter1 = 4.5;
socket_handle_length1 = 7;
socket_handler_hole = socket_handle_diameter1 + 0.5;
socket_handler_position = [5, 0.7, 5];

button_dim1 = [12, 12, 3];
button_pos1 = [58, 3, lsr_pcb_pos[2]];
button_color1 = "black";

button_dia2 = 13;
button_height2 = 5;
button_pos2 = [button_pos1[0] + (button_dim1[0] / 2), button_pos1[1] + (button_dim1[1] / 2), button_pos1[2] + button_dim1[2]];
button_color2 = "blue";

button_dia3 = 11.3;
button_height3 = 4.4;
button_pos3 = [button_pos2[0], button_pos2[1], button_pos2[2] + button_height2];
button_color3 = "yellow";

lcd_bottom_pos = [6, 25, lsr_pcb_pos[2]];
lcd_bottom_height = 2;

lcd_up_pos = [6, 25, lcd_bottom_pos[2] + lcd_bottom_height];
lcd_up_dim = [58, 38, 3];

lcd_viewport_pos = [lcd_up_pos[0] + 3, lcd_up_pos[1] + 3, lcd_up_pos[2] + lcd_up_dim[2]];
lcd_viewport_dim = [lcd_up_dim[0] - 6, 28, 0.1];

module lsr_battery() {
	contact_diameter = 7;
	contact_height = 2;
	contact_distance = 12;
	
	battery_color = [0.7, 0.7, 0.7];
	battery_contact_color = [0.7, 0.7, 0.7];
	union() {
		color(battery_color, lsr_transparency){
			cube(lsr_battery_size);
		
			translate([(lsr_battery_size[0] / 2) - (contact_distance / 2), lsr_battery_size[1], lsr_battery_size[2] / 2])
				rotate(a = -90, v = [1, 0, 0])
					cylinder(h = contact_height, r = contact_diameter / 2);
				
			translate([(lsr_battery_size[0] / 2) + (contact_distance / 2), lsr_battery_size[1], lsr_battery_size[2] / 2])
				rotate(a = -90, v = [1, 0, 0])
					cylinder(h = contact_height, r = contact_diameter / 2);
		}
	}
}

module lsr_pcb() {
	
	difference() {
		color(lsr_pcb_color, lsr_transparency)
			cube(lsr_pcb_pos);
		
		for (hole_pos = lsr_pcb_holes_pos) {	
			translate(hole_pos)
				cylinder(h = lsr_pcb_pos[2], r = 1.5);
		}
	}
}

module lsr_pcb_bottom() {
	crystal_size = [5, 11.5, 4.5]; 
	crystal_pos = [47, 34, -crystal_size[2]]; 
	
	color("silver", lsr_transparency)
			translate(crystal_pos)
				cube(crystal_size);
}

module lsr_socket() {
	union() {
		color(lsr_socket_color, lsr_transparency)
			cube(lsr_socket_dim);
		translate(socket_handler_position)
			lsr_socket_handle();	
	}
	
}

module button() {
	union() {
		color(button_color1, lsr_transparency)
			translate(button_pos1)
				cube(button_dim1);
		color(button_color2, lsr_transparency)
			translate(button_pos2)
				cylinder(h = button_height2, r = button_dia2 / 2);
		color(button_color3, lsr_transparency)
			translate(button_pos3)
				cylinder(h = button_height3, r = button_dia3 / 2);
	}
}

module lsr_lcd() {
	union() {
		//bottom part of lcd	
		color("white", lsr_transparency)
			translate(lcd_bottom_pos)
				linear_extrude(height = lcd_bottom_height)
					polygon([[0, 0], [59, 0], [65, 12], [65, 21], [59, 34], [0, 34]]);
		//upper part
		color("black", lsr_transparency)
			translate(lcd_up_pos)
				cube(lcd_up_dim);
		//viewport
		color("green", lsr_transparency)
			translate(lcd_viewport_pos)
				cube(lcd_viewport_dim);
		
	}
}

module lsr_socket_handle_single() {
	union() {
		color("silver", lsr_transparency) cylinder(h = socket_handle_length, r = socket_handle_diameter / 2);
		color(lsr_socket_color, lsr_transparency)
			translate([0, 0, socket_handle_length])
				cylinder(h = socket_handle_length1, r = socket_handle_diameter1 / 2);
	}
}

module lsr_socket_handle() {
	union() {
		lsr_socket_handle_single();
		rotate(a = -90, v = [0, 1, 0])
			 lsr_socket_handle_single();
	}	
}

module lsr() {
	union() {
		lsr_pcb_bottom();
		lsr_pcb();
		lsr_lcd();
		button();
		translate(lsr_socket_pos) lsr_socket();
		translate(lsr_battery_pos) lsr_battery();
	}
}

//////////////////////////////////////////////////////
module box_bottom() {
	//bottom side of pcb is at 0
	//TODO diry zespoda
	
	pcb_holder_height = - (bottom2_pos[2] + bottom2_dim[2]);
	pcb_holder_hole_height = pcb_holder_height;
	
	difference() {
		union() {
			//bottom plate
			color("red", box_transparency)
				translate(bottom1_pos)
					cube(bottom1_dim);
			color("pink", box_transparency)
				translate(bottom2_pos)
					cube(bottom2_dim);

			//pcb holders
			for (hole_pos = lsr_pcb_holes_pos) {
				color("red", box_transparency) {
					translate([hole_pos[0], hole_pos[1], hole_pos[2] - pcb_holder_height])
						cylinder(h = pcb_holder_height, r = 3);
				}
			}
		}
		
		union() {
			//pcb holders holes
			for (hole_pos = lsr_pcb_holes_pos) {
				translate([hole_pos[0], hole_pos[1], hole_pos[2] - pcb_holder_hole_height + 0.1 - (2 * box_thick)])
					cylinder(h = pcb_holder_hole_height + 0.1 + (2 * box_thick), r = 1.5);
			}
			
			//corner holes
			for (hole_pos = [
				[bottom2_pos[0] + bottom2_dim[0] - hole_distance, bottom2_pos[1] + hole_distance, bottom1_pos[2] - 0.1],
				[bottom2_pos[0] + bottom2_dim[0] - hole_distance, bottom2_pos[1] + bottom2_dim[1] - hole_distance, bottom1_pos[2] - 0.1]]) {
				translate(hole_pos)
					cylinder(h = box_thick + 0.2, r = 1.5);
			}
		}
	}
}

module box_top() {
	box_height = button_pos3[2] - bottom1_pos[2] - (box_thick / 2) + 0.5;
	box_top_z = bottom1_pos[2] + box_height + (box_thick / 2);
	difference() {
		union() {
			color("blue", box_transparency) {
				//front side
				translate([bottom1_pos[0], bottom1_pos[1], bottom1_pos[2] + (box_thick / 2)])
					cube([bottom1_dim[0], box_thick / 2, box_height]);	
				translate([bottom2_pos[0], bottom2_pos[1], bottom2_pos[2] + (box_thick / 2)])
					cube([bottom1_dim[0] - box_thick, box_thick / 2, box_height - (box_thick / 2)]);
					
				//back side	
				translate([bottom1_pos[0], bottom1_pos[1] + bottom1_dim[1] - (box_thick / 2), bottom1_pos[2] + (box_thick / 2)])
					cube([bottom1_dim[0], box_thick / 2, box_height]);	
				translate([bottom2_pos[0], bottom2_pos[1] + bottom2_dim[1] - (box_thick / 2), bottom2_pos[2] + (box_thick / 2)])
					cube([bottom1_dim[0] - box_thick, box_thick / 2, box_height - (box_thick / 2)]);
			}
			
			color("lightblue", box_transparency) {
				//left side
				translate([bottom1_pos[0], bottom1_pos[1] + (box_thick / 2), bottom1_pos[2] + (box_thick / 2)])
					cube([box_thick / 2, bottom2_dim[1], box_height]);
				translate([bottom2_pos[0], bottom2_pos[1] + (box_thick / 2), bottom2_pos[2] + (box_thick / 2)])
					cube([box_thick / 2, bottom2_dim[1] - box_thick, box_height - (box_thick / 2)]);
				//right side
				translate([bottom1_pos[0] + bottom1_dim[0] - (box_thick / 2), bottom1_pos[1] + (box_thick / 2), bottom1_pos[2] + (box_thick / 2)])
					cube([box_thick / 2, bottom2_dim[1], box_height]);
				translate([bottom2_pos[0] + bottom2_dim[0] - (box_thick / 2), bottom2_pos[1] + (box_thick / 2), bottom2_pos[2] + (box_thick / 2)])
					cube([box_thick / 2, bottom2_dim[1] - box_thick, box_height - (box_thick / 2)]);
			}
			
			//top_side
			color("red", box_transparency)
				translate([bottom1_pos[0], bottom1_pos[1], box_top_z])
					cube([bottom1_dim[0], bottom1_dim[1], box_thick]);
			//lcd holder frame
			color("red")
				translate([lcd_viewport_pos[0] - (box_thick / 2), lcd_viewport_pos[1] - (box_thick / 2), lcd_viewport_pos[2] + lcd_viewport_dim[2]])
					cube([
						lcd_viewport_dim[0] + box_thick,
						lcd_viewport_dim[1] + box_thick,
						(box_top_z) - (lcd_viewport_pos[2] + lcd_viewport_dim[2])
					]);
			//pcb holders
			for (hole_pos = lsr_pcb_holes_pos) {
				difference() {
					color("red", box_transparency)
						translate([hole_pos[0], hole_pos[1], hole_pos[2] + lsr_pcb_pos[2]])
							cylinder(h = box_top_z - hole_pos[2] - lsr_pcb_pos[2], r = 3);
					translate([hole_pos[0], hole_pos[1], hole_pos[2]])
						cylinder(h = box_top_z - hole_pos[2] - box_thick - 1, r = 1);
				}
			}
			//corner_holder
			for (hole_pos = [
				[bottom2_pos[0] + bottom2_dim[0] - hole_distance, bottom2_pos[1] + hole_distance, bottom1_pos[2] + box_thick],
				[bottom2_pos[0] + bottom2_dim[0] - hole_distance, bottom2_pos[1] + bottom2_dim[1] - hole_distance, bottom1_pos[2] + box_thick]]) {
				difference() {
					translate(hole_pos)
						cylinder(h = box_height - (box_thick / 2), r = 3);
					translate(hole_pos)
						cylinder(h = box_height - (box_thick / 2) - 5, r = 1);
				}
			}
		}
		//holes in top part	
		//hole for socket handler
		translate([
			-box_thick - box_distance - 0.1,
			socket_handler_position[1] - (socket_handler_hole / 2),
			socket_handler_position[2]])
			cube([
				(box_thick / 2) + box_distance + socket_handler_position[0] + (socket_handler_hole / 2) + 0.2,
				socket_handler_hole,
				box_height + bottom1_pos[2] - socket_handler_position[2] + (1.5 * box_thick) + 0.1]);
		//hole for socket
		translate([lsr_socket_pos[0] - 0.5, lsr_socket_pos[1] - 0.5, box_top_z - 0.1])
			cube([lsr_socket_dim[0] + 1, lsr_socket_dim[1] + 1, box_thick + 0.2]);
		//hole for button
		translate(button_pos3)
			cylinder(h = button_height3 - 1, r = (button_dia3 / 2) + 0.5);
		//hole for lcd
		translate(lcd_viewport_pos)
			cube([lcd_viewport_dim[0], lcd_viewport_dim[1], lcd_viewport_dim[2] + 100]);
	}
}

lsr(); 

box_bottom();
box_top();

//rotate(a = 180, v = [1, 0, 0]) box_top();
