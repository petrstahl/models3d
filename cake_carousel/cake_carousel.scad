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

top_h = 16;
top_position = 20;

screw_hole_place = 25;

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
		translate([0, 0, screw_head_h + bearing_h + pad_h + top_position]) {
			nut();
		}
		translate([0, 0, screw_head_h + bearing_h + pad_h + top_position + top_h - 1]) {
			nut();
		}
		screw();
	}
}

module top() {
	hole_len = top_h* 0.75;
	translate([0, 0, screw_head_h + bearing_h + pad_h + nut_h + top_position]) {
		difference() {
			union() {
				cylinder(h = top_h, r = 35);
			}
			//holes
			translate([screw_hole_place, 0, top_h - hole_len]) cylinder(h = hole_len + 0.1, r = 1.2, $fn = 10);
			translate([0, screw_hole_place, top_h - hole_len]) cylinder(h = hole_len + 0.1, r = 1.2, $fn = 10);
			translate([-screw_hole_place, 0, top_h - hole_len]) cylinder(h = hole_len + 0.1, r = 1.2, $fn = 10);
			translate([0, -screw_hole_place, top_h - hole_len]) cylinder(h = hole_len + 0.1, r = 1.2, $fn = 10);
			//hole for screw
			translate([0, 0, -0.05]) cylinder(h = top_h + 0.1, r = screw_body_r);
			//hole for nut
			translate([0, 0, top_h - nut_h - 1]) cylinder(h = nut_h + 1.1, r = nut_r + 7);
		}
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
			translate([screw_hole_place, 0, 20]) cylinder(h = 20.1, r = 1.2, $fn = 10);
			translate([0, screw_hole_place, 20]) cylinder(h = 20.1, r = 1.2, $fn = 10);
			translate([-screw_hole_place, 0, 20]) cylinder(h = 20.1, r = 1.2, $fn = 10);
			translate([0, -screw_hole_place, 20]) cylinder(h = 20.1, r = 1.2, $fn = 10);
		}
	}
}

module b_holder() {
	color("red") {
		difference() {
			cylinder(h = 8, r = 35);
			cylinder(h = 8.1, r = nut_r + 0.5);
			//holes
			translate([screw_hole_place, 0, 0]) cylinder(h = 8.1, r = 1.6, $fn = 10);
			translate([0, screw_hole_place, 0]) cylinder(h = 8.1, r = 1.6, $fn = 10);
			translate([-screw_hole_place, 0, 0]) cylinder(h = 8.1, r = 1.6, $fn = 10);
			translate([0, -screw_hole_place, 0]) cylinder(h = 8.1, r = 1.6, $fn = 10);
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
	
!translate([0, 0, bottom_h - bearing_h - screw_head_h]) top();	