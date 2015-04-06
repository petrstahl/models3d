cross_size = 13.4;
cs2 = cross_size / 2;
cross_width = 4;
cw2 = cross_width / 2; 
cross_height = 0.9;

holder_thick = 0.5;
holder_height = 3.2;

plate_width = 31;
plate_height = 50;
plate_thick = holder_height;

plate_adjust_thick = 0.8;

module cross_holder() {
	width = 1;
	width2 = width / 2;
	rotate([90, 0, 0]) {
		linear_extrude(height = holder_thick, center = true) {
			polygon([[-width2, 0], [width2, 0], [0, holder_height]]);
		}
	}		
}

module cross_shape(correction) {
	c = correction; 
	
	polygon([
		[-cw2 - c, -cs2 - c], [cw2 + c, -cs2 - c], [cw2 + c, -cw2 - c], [cs2 + c, -cw2 - c],
		[cs2 + c, cw2 + c], [cw2 + c, cw2 + c], [cw2 + c, cs2 + c], [-cw2 - c, cs2 + c],
		[-cw2 - c, cw2 + c], [-cs2 - c, cw2 + c], [-cs2 - c, -cw2 - c], [-cw2 - c, -cw2 - c]
	]);
}

module cross() {
	color("silver") {
		union() {
			linear_extrude(height = cross_height, center = false) {
				cross_shape(0);
			};
			translate([0, cs2 - holder_thick / 2, cross_height]) {
				cross_holder();
			};
			translate([0, -cs2 + holder_thick / 2, cross_height]) {
				cross_holder();
			};
		}
	}
};

module plate_adjust() {
	cube([plate_width, plate_adjust_thick, plate_thick + cross_height + 2]);
}

module plate() {
	color("red") {
		union() {
			difference() {
				translate([-plate_width / 2, -plate_height / 2, 0]) {
					cube([plate_width, plate_height, plate_thick + cross_height]);
				};
				linear_extrude(height = plate_thick + cross_height + 0.1, center = false) {
					cross_shape(0.2);
				};
			}
			translate([-plate_width / 2, -(plate_height / 2) - plate_adjust_thick, 0]) {
				plate_adjust();
			}
			translate([-plate_width / 2, (plate_height / 2), 0]) {
				plate_adjust();
			}
		}
	}
}

module plate_simple() {
	color("red") {
		union() {
			difference() {
				translate([-plate_width / 2, -plate_height / 2, 0]) {
					cube([plate_width, plate_height, 0.1 + cross_height]);
				};
				linear_extrude(height = plate_thick + cross_height + 0.1, center = false) {
					cross_shape(0.2);
				};
			}
		}
	}
}

module stamp() {
	stamp_height = 3;
	color("green") {
		union() {
			cube([plate_width, plate_width, stamp_height], center = true); 

			translate([0, 0, stamp_height / 2]) {			
				linear_extrude(height = holder_height + 2, center = false) {
					cross_shape(-0.2);
				};
			}
		}	
	}
}

*cross();

*plate();

plate_simple();

*cross_holder();

*stamp();