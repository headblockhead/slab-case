// Arc+Circle resolution - 16 if previewing.
$fn = $preview ? 16 : 128;

// Driving parameters

// Vertical stagger amount per column (mm)
columns = [0, 4.5,7.5,9,6.5,0,0,0];
// Width of each column (mm)
column_widths = [ 19, 19, 19, 19, 19, 19, 19, 25];

// Horizontal stagger amount per row (mm)
rows = [0,0,0,0,0]; 
// Height of each row (mm)
row_heights = [19,19,19,19,19];

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

// Width of the case wall.
case_width = 1.8;
case_depth = 7.5;
case_floor_thickness = 0.4;

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
module screwholes( diameter) {
    for (i = [0:len(screwholes)-1]) {
        translate([screwholes[i].x,screwholes[i].y,0])
        circle(diameter/2);
    }
};

color("green")
translate([0,0,heatset_post_depth])
linear_extrude(1.6)
difference() {
    pcb();
    screwholes(3.2);
}

linear_extrude(case_depth)
difference() {
    offset(pcb_spacing+case_width) { pcb(); };
    offset(pcb_spacing) { pcb(); };
};

linear_extrude(heatset_post_depth)
difference() {
    screwholes(8);
    screwholes(4.6);
};

translate([0,0,-case_floor_thickness])
linear_extrude(case_floor_thickness)
offset(pcb_spacing+case_width) { pcb(); };

