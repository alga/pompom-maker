// Parametric Pompom maker
// 2018 (c) Albertas Agejevas <albertas.agejevas@gmail.com>
// Released under CC-BY-SA

dia = 100;
hole = dia * 5 / 12;
thickness = 5;
gap = 0.25;

// 2d profile to extrude
module shape(r=2, x=30, y=5) {
    $fn=30;
    hull() {
        translate([r, r]) circle(r);
        translate([x-y+r, r]) circle(r);
        translate([x-r, y-r]) circle(r);
        translate([r, y-r]) circle(r);
    }
}

module donut(dia, hole, thickness) {
    rotate_extrude(angle=180, $fn=60, convexity=10) 
        translate([hole/2, 0]) shape(r=1.5, x=(dia-hole)/2, y=thickness);
}

module pompom_quarter(dia=dia, hole=hole, thickness=thickness) {
    difference() {
        donut(dia, hole, thickness);
        translate([-dia, -2*dia+gap, -dia]) cube(2*dia);
    }
    // Poles
    pr = thickness/2;
    pb = thickness/2;
    ph = (dia-hole)/2 * 0.66;
    pole_locate(dia, hole, thickness, gap) 
        translate([0,0, thickness]) footpole(pr, ph, pb);
}

// Calculate the position of the poles
module pole_locate(dia, hole, thickness, gap) {
    xsym() {
        pr = thickness/2;
        pb = thickness/2;
        ph = (dia-hole)/2 * 0.66;
        r = dia/2 - (dia-hole)/4;
        alpha = asin((pr+pb+gap)/r);
        translate([r * cos(alpha), r * sin(alpha), 0]) children();
    }
}

// symmetry along x axis
module xsym() {
    children();
    mirror([1, 0, 0]) children();
}

// Cylinder with a bevel at the bottom and a spherical top
module footpole(r, h, bevel) {
    $fn=30;
    cylinder(r=r, h=h-r);
    translate([0, 0, h-r]) sphere(r);
    difference() {
        cylinder(r=r+bevel, h=bevel);
        rotate_extrude() translate([r+bevel, bevel]) circle(bevel);
    }
    
}

module ring(dia=dia, hole=hole, rthickness=3) {
    $fn=200;
    hgap = gap; // The radius tollerance inside the hole
    difference () {
        rotate_extrude() hull() {
            $fn=20;
            translate([dia/2 - (dia-hole)/3, rthickness/2]) circle(rthickness/2);
            translate([dia/2 - (dia-hole)/6, rthickness/2]) circle(rthickness/2);
        }
    translate([0, 0, -1]) 
        pole_locate(dia, hole, thickness, gap) cylinder(r=thickness/2+hgap, hole);
    mirror([0, 1, 0]) translate([0, 0, -1]) 
        pole_locate(dia, hole, thickness, gap) cylinder(r=thickness/2+hgap, hole);
    }
}

module assy () {

    translate([0, 0, thickness*3]) ring(dia, hole);
    mirror([0,0, 1]) translate([0, 0, thickness*3]) ring(dia, hole);

    pompom_quarter(dia, hole, thickness);
    mirror([0,0,1]) translate([0, 0, 1]) pompom_quarter(dia, hole, thickness);
    mirror([0, 1, 0]) {
        pompom_quarter(dia, hole, thickness);
        mirror([0,0,1]) translate([0, 0, 1]) pompom_quarter(dia, hole, thickness);
    }

}

assy();
//ring();
//pompom_quarter();