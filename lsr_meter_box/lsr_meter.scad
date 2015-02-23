lsr_pcb_pos = [71, 63.2, 1.7];
lsr_pcb_color = [0, 1, 0];
lsr_transparency = 1;

lsr_pcb_holes_pos = [[2.5, 20, 0], [lsr_pcb_pos[0] - 2.5, 20, 0], [2.5, 60, 0], [lsr_pcb_pos[0] - 2.5, 60, 0]];

lsr_socket_color = [0, 1, 0];
lsr_socket_dim = [33, 14.8, 11.5];
lsr_socket_pos = [-1, 0, lsr_pcb_pos[2]];

lsr_battery_pos = [lsr_pcb_pos[0] + 5, 5, -10];
lsr_battery_size = [26.5, 46.5, 17.5];

lsr_socket_handle_diameter = 1.5;
lsr_socket_handle_length = 10;
lsr_socket_handle_diameter1 = 4.5;
lsr_socket_handle_length1 = 7;
lsr_socket_handler_hole = lsr_socket_handle_diameter1 + 0.5;
lsr_socket_handler_position = [5, 0.7, 5];

lsr_button_dim1 = [12, 12, 3];
lsr_button_pos1 = [58, 3, lsr_pcb_pos[2]];
lsr_button_color1 = "black";

lsr_button_dia2 = 13;
lsr_button_height2 = 5;
lsr_button_pos2 = [lsr_button_pos1[0] + (lsr_button_dim1[0] / 2), lsr_button_pos1[1] + (lsr_button_dim1[1] / 2), lsr_button_pos1[2] + lsr_button_dim1[2]];
lsr_button_color2 = "blue";

lsr_button_dia3 = 11.3;
lsr_button_height3 = 4.4;
lsr_button_pos3 = [lsr_button_pos2[0], lsr_button_pos2[1], lsr_button_pos2[2] + lsr_button_height2];
lsr_button_color3 = "yellow";

lsr_lcd_bottom_pos = [6, 25, lsr_pcb_pos[2]];
lsr_lcd_bottom_height = 2;

lsr_lcd_up_pos = [6, 25, lsr_lcd_bottom_pos[2] + lsr_lcd_bottom_height];
lsr_lcd_up_dim = [58, 38, 3];

lsr_lcd_viewport_pos = [lsr_lcd_up_pos[0] + 3, lsr_lcd_up_pos[1] + 3, lsr_lcd_up_pos[2] + lsr_lcd_up_dim[2]];
lsr_lcd_viewport_dim = [lsr_lcd_up_dim[0] - 6, 28, 0.1];

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
		translate(lsr_socket_handler_position)
			lsr_lsr_socket_handle();	
	}
	
}

module lsr_button() {
	union() {
		color(lsr_button_color1, lsr_transparency)
			translate(lsr_button_pos1)
				cube(lsr_button_dim1);
		color(lsr_button_color2, lsr_transparency)
			translate(lsr_button_pos2)
				cylinder(h = lsr_button_height2, r = lsr_button_dia2 / 2);
		color(lsr_button_color3, lsr_transparency)
			translate(lsr_button_pos3)
				cylinder(h = lsr_button_height3, r = lsr_button_dia3 / 2);
	}
}

module lsr_lcd() {
	union() {
		//bottom part of lcd	
		color("white", lsr_transparency)
			translate(lsr_lcd_bottom_pos)
				linear_extrude(height = lsr_lcd_bottom_height)
					polygon([[0, 0], [59, 0], [65, 12], [65, 21], [59, 34], [0, 34]]);
		//upper part
		color("black", lsr_transparency)
			translate(lsr_lcd_up_pos)
				cube(lsr_lcd_up_dim);
		//viewport
		color("green", lsr_transparency)
			translate(lsr_lcd_viewport_pos)
				cube(lsr_lcd_viewport_dim);
		
	}
}

module lsr_lsr_socket_handle_single() {
	union() {
		color("silver", lsr_transparency) cylinder(h = lsr_socket_handle_length, r = lsr_socket_handle_diameter / 2);
		color(lsr_socket_color, lsr_transparency)
			translate([0, 0, lsr_socket_handle_length])
				cylinder(h = lsr_socket_handle_length1, r = lsr_socket_handle_diameter1 / 2);
	}
}

module lsr_lsr_socket_handle() {
	union() {
		lsr_lsr_socket_handle_single();
		rotate(a = -90, v = [0, 1, 0])
			 lsr_lsr_socket_handle_single();
	}	
}

module lsr() {
	union() {
		lsr_pcb_bottom();
		lsr_pcb();
		lsr_lcd();
		lsr_button();
		translate(lsr_socket_pos) lsr_socket();
		translate(lsr_battery_pos) lsr_battery();
	}
}
