// Arc+Circle resolution - 16 if previewing.
$fn = $preview ? 16 : 128;

// Components
// comment/uncomment these when exporting for seperate files.
case();
plate();

//pcb_visualisation();

// Driving parameters

// Vertical stagger amount per column (mm)
columns = [0, 4.5,7.5,9,6.5,0,0,0];
// Width of each column (mm)
column_widths = [ 19, 19, 19, 19, 19, 19, 19, 25];

// Horizontal stagger amount per row (mm)
rows = [0,0,0,0,0]; 
// Height of each row (mm)
row_heights = [19,19,19,19,19];

// Which columns and rows have keys?
key_locations = [   
   // every row (0-4, 5 total) in columns 1,2,3,4,5, and 6. (0-indexed)
   for (i = [0:4]) each [[1, i], [2, i], [3, i], [4, i], [5, i], [6, i]] 
];

xiao_location = [7,4];
display_location = [7,0];
encoder_location = [0,0];
slider_location = [0,2];
trrs_left_y = 90.05;
trrs_right_y = 65.5;
magnet_left_y = 47.5;
magnet_right_y = 47.5;

// XY location of every screw hole (mm)
screwholes = [
    [38,64.5], // H1
    [76,85.5], // H2
    [114,38], // H3
    [58.5,28.5], // H4
    [135.9,28.5], // H5
    [19,42.5], // H6
    [114,76], // H7
    [3.75,19], // H8
    [19,80.5], // H9
];
heatset_post_depth = 5.5;

// Distance between PCB and internal case edge.
pcb_spacing = 0.5;

// Thickness of the PCB as specified by order. Usually always 1.6mm.
pcb_thickness = 1.6;

// Width of the case wall.
case_width = 1.8;
case_depth = 7.5;
case_floor_thickness = 0.4;

// Siderails for alligning plate
siderail_height = 2.5;

// Code

// generate a new list based on the sum of every item before it.
column_widths_sum = [ for (a=0, b=column_widths[0]; a < len(column_widths); a= a+1, b=b+(column_widths[a]==undef?0:column_widths[a])) b];;
row_heights_sum = [ for (a=0, b=row_heights[0]; a < len(row_heights); a= a+1, b=b+(row_heights[a]==undef?0:row_heights[a])) b];;

// PCB is an object repesenting the physical circuitboard.
module pcb() {
    for (c = [0:len(columns)-1]) {
        for (r = [0:len(rows)-1]) {
            // X and Y are the top-left corner of every key on the keyboard.
            x = (column_widths_sum[c-1]==undef?0:column_widths_sum[c-1]) + rows[r];
            y = (row_heights_sum[r-1]==undef?0:row_heights_sum[r-1]) + columns[c];
            // Add a square per key
            translate([x,y,0])
            square([column_widths[c],row_heights[r]], center = false);
        }
    };
};

// Screwholes creates circles of the given radius at every screwhole location.
module screwholes(diameter) {
    for (i = [0:len(screwholes)-1]) {
        translate([screwholes[i].x,screwholes[i].y,0])
        circle(diameter/2);
    }
};

// Draw the PCB (in green)
module pcb_visualisation() {
    color("green")
    translate([0,0,heatset_post_depth])
    linear_extrude(pcb_thickness)
    difference() {
        pcb();
        screwholes(3.2);
    }
};

module case() {
    // Create the main case body outline
    render()
    difference() {
        linear_extrude(case_depth)
        difference() {
            offset(pcb_spacing+case_width) { pcb(); };
            offset(pcb_spacing) { pcb(); };
        };
        trrs_l_hole();
        trrs_r_hole();
        magnet_l_hole();
        magnet_r_hole();
    };

    // Add heatset posts.
    linear_extrude(heatset_post_depth)
    difference() {
        screwholes(8);
        screwholes(4.6);
    };

    // Add a floor.
    translate([0,0,-case_floor_thickness])
    linear_extrude(case_floor_thickness)
    offset(pcb_spacing+case_width) { pcb(); };

    // Add the left siderail.
    render()
    difference() {
        translate([0,0, case_depth])
        linear_extrude(siderail_height)
        intersection() {
            offset(pcb_spacing+case_width) { pcb(); };
            translate([-case_width-pcb_spacing, -pcb_spacing-case_width + columns[0]])
            square([case_width,row_heights_sum[len(rows)-1]+2*(pcb_spacing+case_width)]);
        };
        trrs_l_hole();
        magnet_l_hole();
    };

    // Add the right siderail.
    render()
    difference() {
        translate([0,0, case_depth])
        linear_extrude(siderail_height)
        intersection() {
            offset(pcb_spacing+case_width) { pcb(); };
            translate([column_widths_sum[len(columns)-1]+pcb_spacing, -pcb_spacing-case_width + columns[len(columns)-1]])
            square([case_width,row_heights_sum[len(rows)-1]+2*(pcb_spacing+case_width)]);
        };
        trrs_r_hole();
        magnet_r_hole();
    };
};

module keycutouts() {
    for (c = [0:len(columns)-1]) {
        for (r = [0:len(rows)-1]) {
            // X and Y are the top-left corner of every key on the keyboard.
            x = (column_widths_sum[c-1]==undef?0:column_widths_sum[c-1]) + rows[r];
            y = (row_heights_sum[r-1]==undef?0:row_heights_sum[r-1]) + columns[c];
            position_vector = [x,y];
            keyboard_vector = [c,r];
            
            for (i = [0:len(key_locations)-1]) {
                if (keyboard_vector == key_locations[i]) {
                    linear_extrude(5)
                    translate([x+(column_widths[c]/2),y+(row_heights[r]/2)])
                    square([14,14], center = true);
                    
                    linear_extrude(3.4)
                    translate([x+(column_widths[c]/2),y+(row_heights[r]/2)])
                    square([16.5,16.5], center = true);
                    
                    linear_extrude(5)
                    translate([x+(column_widths[c]/2),y+(row_heights[r]/2)])
                    square([16.5+(0.3*2),3.9], center = true);
                }
            } 
            if (keyboard_vector == xiao_location) {
                  linear_extrude(5)
                  translate([x+(column_widths[c]/2),y+(row_heights[r]/2)])
                  square([21,20.5], center = true);
          }
          if (keyboard_vector == display_location) {
              linear_extrude(5)
              translate([x+(column_widths[c]/2)-7,y+(row_heights[r]/2)-1.5])
              square([14,40]);
          }
          if (keyboard_vector == encoder_location) {
              linear_extrude(5)
              translate([x+(column_widths[c]/2),y+(row_heights[r]/2)])
              square([15.6,14.2], center=true);
              linear_extrude(5)
              translate([x+(column_widths[c]/2),y+(row_heights[r]/2)])
              circle(d=6.4);
          }
           if (keyboard_vector == slider_location) {
              linear_extrude(5)
              translate([x+(column_widths[c]/2),y+(row_heights[r]*(3/4))])
              square([9,61], center=true);
           }
           }
    };
    linear_extrude(5)
    translate([column_widths[0]/2 - 5, trrs_left_y])
    square([15,10], center = true);

    linear_extrude(5)
    translate([column_widths_sum[len(columns)-1] - column_widths[len(columns)-1]/2 + 5, trrs_right_y])
    square([15,10], center = true);
};

// makes an M3 countersunk hole.
module countersunkscrewhole() {
    translate([0,0,-1.35])
    cylinder(1.35,1.7,3.05);
    translate([0,0,-20])
    cylinder(20,1.7,1.7);
}

module trrs_l_hole() {
translate([column_widths[0]/2-15, trrs_left_y, 10])
     rotate([0,90,0]) 
     cylinder(10, d=9);
}
module trrs_r_hole() {
translate([column_widths_sum[len(columns)-1] - column_widths[len(columns)-1]/2 + 5, trrs_right_y, 10])
     rotate([0,90,0]) 
     cylinder(10, d=9);
}

module magnet_l_hole() {
    translate([-pcb_spacing - case_width, magnet_left_y, 5.7])
     rotate([90,180,90])
     linear_extrude(5+pcb_spacing+case_width)
     square([22,8.6], center=true);
}

module magnet_r_hole() {
     translate([column_widths_sum[len(columns)-1] - 5, magnet_right_y, 5.7])
     rotate([90,180,90])
     linear_extrude(5+pcb_spacing+case_width)
     square([22,8.6], center=true);
}

module plate() {
render()
difference() {
    translate([0,0,heatset_post_depth+pcb_thickness])
    difference() {
        linear_extrude(5) pcb();
        keycutouts();
        for (i = [0:len(screwholes)-1]) {
            translate([screwholes[i].x,screwholes[i].y,5])
            countersunkscrewhole();
        }
    };
     magnet_l_hole();
        magnet_r_hole();
    };
}