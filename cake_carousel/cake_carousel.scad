screw_head_h = 8.5;
screw_head_r = 21.3 / 2;

screw_body_h = 60;
screw_body_r = 6;

bearing_h = 10;
bearing_r = 16;

pad_h = 2.5;

nut_r = screw_head_r;
nut_h = 8;

bottom_h = 40;

module bearing() {
	color ("yellow") {
		difference() {
			cylinder(h = bearing_h, r = bearing_r);
			cylinder(h = bearing_h, r = 6);
		}
	}
}

module pad() {
	color ("silver") {
		difference() {
			cylinder(h = pad_h, r=12);
			cylinder(h = pad_h, r=6);
		}
	}
}

module nut() {
	color ("silver") {
		difference() {
			cylinder(h = nut_h, r= nut_r);
			cylinder(h = nut_h, r=6);
		}
	}
}

module screw() {
	
	color("silver") {
		union() {
			//body
			translate([0, 0, screw_head_h]) {
				cylinder(h = screw_body_h, r = screw_body_r);
			}
			//head
			cylinder(h = screw_head_h, r = screw_head_r);
		}
	}
		
}

module steel() {
	union() {
		translate([0, 0, screw_head_h]) {
			bearing();
		}
		translate([0, 0, screw_head_h + bearing_h]) {
			pad();
		}
		translate([0, 0, screw_head_h + bearing_h + pad_h]) {
			nut();
		}
		translate([0, 0, screw_head_h + bearing_h + pad_h + 20]) {
			nut();
		}
		screw();
	}
}

module top() {
	translate([0, 0, screw_head_h + bearing_h + pad_h + nut_h + 20]) {
		cylinder(h = 8, r = 35);
		cylinder(h = 8.1, r = nut_r + 0.5);
	}
}

module bottom() {
	bottom_r = 70;
	
	color("blue") {
		difference() {
			cylinder(r = bottom_r, h = bottom_h);
			//bearing place
			translate([0, 0, bottom_h - bearing_h]) cylinder(r = bearing_r, h = bearing_h + 0.1);
			//screw head place
			translate([0, 0, bottom_h - bearing_h - screw_head_h - 1]) cylinder(r = screw_head_r + 1, h = screw_head_h + 1.1);
			//holes
			translate([25, 0, 20]) cylinder(h = 20.1, r = 1.2, $fn = 10);
			translate([0, 25, 20]) cylinder(h = 20.1, r = 1.2, $fn = 10);
			translate([-25, 0, 20]) cylinder(h = 20.1, r = 1.2, $fn = 10);
			translate([0, -25, 20]) cylinder(h = 20.1, r = 1.2, $fn = 10);
		}
	}
}

module b_holder() {
	color("red") {
		difference() {
			cylinder(h = 8, r = 35);
			cylinder(h = 8.1, r = nut_r + 0.5);
			//holes
			translate([25, 0, 0]) cylinder(h = 8.1, r = 1.6, $fn = 10);
			translate([0, 25, 0]) cylinder(h = 8.1, r = 1.6, $fn = 10);
			translate([-25, 0, 0]) cylinder(h = 8.1, r = 1.6, $fn = 10);
			translate([0, -25, 0]) cylinder(h = 8.1, r = 1.6, $fn = 10);
		}
	}
}

translate([0, 0, bottom_h - bearing_h - screw_head_h]) steel();

difference() {
	bottom();

	translate([0, 0, 40])
		rotate_extrude(convexity = 10) translate([82, 0, 0]) circle(r = 40); 
}

translate([0, 0, bottom_h])
	b_holder();
	
translate([0, 0, bottom_h - bearing_h - screw_head_h]) top();	