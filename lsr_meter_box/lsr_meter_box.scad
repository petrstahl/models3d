include <lsr_meter.scad>;
use <lsr_meter_utils.scad>;

//increase before stl generation
$fn = 20;

box_thick = 2.4;
box_thick_2 = box_thick / 2;

box_distance = 2;
box_transparency = 0.5;

bottom1_pos = [-box_thick - box_distance, -box_thick - box_distance, lsr_battery_pos[2] - box_thick];
bottom2_pos = [-(box_thick / 2) - box_distance, -(box_thick / 2) - box_distance, lsr_battery_pos[2] - (box_thick / 2)];

bottom1_dim = [lsr_battery_pos[0] + lsr_battery_dim[0] + (2 * box_thick) + (2 * box_distance),
			lsr_pcb_pos[1] + (2 * box_thick) + (2 * box_distance),
			box_thick / 2];
bottom2_dim = [	lsr_battery_pos[0] + lsr_battery_dim[0] + box_thick + (2 * box_distance),
			lsr_pcb_pos[1] + box_thick + (2 * box_distance),
			box_thick / 2];

hole_distance = 2.5;

slicer_hole_correction = 0.15;

//////////////////////////////////////////////////////
module box_bottom() {
	//bottom side of pcb is at 0
	
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
					cylinder(h = pcb_holder_hole_height + 0.1 + (2 * box_thick), r = 1.5 + slicer_hole_correction);
			}
			
			//corner holes
			for (hole_pos = [
				[bottom2_pos[0] + bottom2_dim[0] - hole_distance, bottom2_pos[1] + hole_distance, bottom1_pos[2] - 0.1],
				[bottom2_pos[0] + bottom2_dim[0] - hole_distance, bottom2_pos[1] + bottom2_dim[1] - hole_distance, bottom1_pos[2] - 0.1]]) {
				translate(hole_pos)
					cylinder(h = box_thick + 0.2, r = 1.5 + slicer_hole_correction);
			}
		}
	}
}

module box_top() {
	box_height = lsr_button_pos3[2] - bottom1_pos[2] - (box_thick / 2) + 0.5;
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
				translate([lsr_lcd_viewport_pos[0] - (box_thick / 2), lsr_lcd_viewport_pos[1] - (box_thick / 2), lsr_lcd_viewport_pos[2] + lsr_lcd_viewport_dim[2]])
					cube([
						lsr_lcd_viewport_dim[0] + box_thick,
						lsr_lcd_viewport_dim[1] + box_thick,
						(box_top_z) - (lsr_lcd_viewport_pos[2] + lsr_lcd_viewport_dim[2])
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
			lsr_socket_handler_position[1] - (lsr_socket_handler_hole / 2),
			lsr_socket_handler_position[2]])
			cube([
				(box_thick / 2) + box_distance + lsr_socket_handler_position[0] + (lsr_socket_handler_hole / 2) + 0.2,
				lsr_socket_handler_hole,
				box_height + bottom1_pos[2] - lsr_socket_handler_position[2] + (1.5 * box_thick) + 0.1]);
		//hole for socket
		translate([lsr_socket_pos[0] - 0.5, lsr_socket_pos[1] - 0.5, box_top_z - 0.1])
			cube([lsr_socket_dim[0] + 1, lsr_socket_dim[1] + 1, box_thick + 0.2]);
		//hole for button
		translate(lsr_button_pos3)
			cylinder(h = lsr_button_height3 - 1, r = (lsr_button_dia3 / 2) + 0.5);
		//hole for lcd
		translate(lsr_lcd_viewport_pos)
			cube([lsr_lcd_viewport_dim[0], lsr_lcd_viewport_dim[1], lsr_lcd_viewport_dim[2] + 100]);
	}
}

module box_fillet() {
    translate(bottom1_pos) fillet(2, 100);
    translate([bottom1_pos[0], bottom1_pos[1] + bottom1_dim[1], bottom1_pos[2]]) rotate([0, 0, 270]) fillet(2, 100);
    translate([bottom1_pos[0] + bottom1_dim[0], bottom1_pos[1] + bottom1_dim[1], bottom1_pos[2]]) rotate([0, 0, 180]) fillet(2, 100);
    translate([bottom1_pos[0] + bottom1_dim[0], bottom1_pos[1], bottom1_pos[2]]) rotate([0, 0, 90]) fillet(2, 100);
}

*lsr(); 

difference() {
    box_bottom();
    box_fillet();
}

*difference() {
    box_top();
    box_fillet();
}

//top side for printing
*rotate(a = 180, v = [1, 0, 0]) difference() {
    box_top();
    box_fillet();
}

// box_top();
