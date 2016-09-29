// Higher definition curves
$fs = 0.01;

module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	module build_point(type = "sphere", rotate = [0, 0, 0]) {
		if (type == "sphere") {
			sphere(r = radius);
		} else if (type == "cylinder") {
			rotate(a = rotate)
			cylinder(h = diameter, r = radius, center = true);
		}
	}

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							build_point("sphere");
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							build_point("cylinder", rotate);
						}
					}
				}
			}
		}
	}
}



lo = 29.8;
la = 26.1;
ha = 12.3;
ep = 0.8;
k = 3;
//roundedcube([lo+2*ep, la+2*ep, ha+2*ep], true, 0.8, "x");


difference() {
// Entire Box    
roundedcube([lo+2*ep, la+2*ep, ha+2*ep], false, ep);
// Remove main Inside box
translate([3*ep,ep,ep]) cube([lo+2*ep, la, ha]);
// Remove right part
translate([lo+ep,la+ep,ep]) cube([ep, ep, ha]);
// Remove inside for the top part
translate([lo+ep,ep/2,ep/2]) cube([ep/2, la+2*ep, ha+ep]);
}

// Key ring part
difference() {
    // Main key ring part
//translate([lo+ep,0,ha/2+ep-k/2-ep]) cube([k+2*ep, ep, k+2*ep]);
    translate([lo+ep,0,ha/2+ep-k/2-ep]) roundedcube([k+2*ep, ep, k+2*ep],false, ep/2);
    // Remove for key ring
//translate([lo+2*ep,0,ha/2+ep-k/2]) cube([k, ep, k]);
    translate([lo+2*ep,0,ha/2+ep-k/2]) roundedcube([k, ep, k], false, ep);

        // Remove inside for the top part
translate([lo+ep,ep/2,ep/2]) cube([ep/2, la+2*ep, ha+ep]);

}

difference() {
translate([lo+ep,0,ha/2+ep-k/2-ep]) roundedcube([ep, ep, k+2*ep],false, ep/2, "x");
        // Remove inside for the top part
translate([lo+ep,ep/2,ep/2]) cube([ep/2, la+2*ep, ha+ep]);
}








