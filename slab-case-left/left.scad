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

// Distance between PCB and internal case edge.
pcb_spacing = 0.5;

// Code

// generate a new list based on the sum of every item before it.
column_widths_sum = [ for (a=0, b=column_widths[0]; a < len(column_widths); a= a+1, b=b+(column_widths[a]==undef?0:column_widths[a])) b];;
row_heights_sum = [ for (a=0, b=row_heights[0]; a < len(row_heights); a= a+1, b=b+(row_heights[a]==undef?0:row_heights[a])) b];;

// Model the PCB outline based on column and row inputs
for (c = [0:len(columns)-1]) {
    for (r = [0:len(rows)-1]) {
        // X and Y are the top-left corner of every key on the keyboard.
        x = (column_widths_sum[c-1]==undef?0:column_widths_sum[c-1]) + rows[r];
        y = (row_heights_sum[r-1]==undef?0:row_heights_sum[r-1]) + columns[c];
        // Add a square per key
        color("green")
            translate([x,y,0])
                linear_extrude(1.6)
                    square([column_widths[c],row_heights[r]], center = false);
    }
}

// Model the outline of the case
pcb_outline_top = [for(c = [0:len(columns)*2]) [
]];

pcb_outline_bottom = [for(c = [len(columns):-1:0]) [
]];

pcb_outline = concat(pcb_outline_top,pcb_outline_bottom);

echo(pcb_outline);

color("red")
translate([0,0,2])
linear_extrude(20)
polygon(pcb_outline);

// Add screw posts for heat-set inserts
for (i = [0:len(screwholes)-1]) {
    translate([screwholes[i].x,screwholes[i].y,0])
        linear_extrude(5.5)
            difference() {
                circle(d=8);
                circle(d=4.6);
            };
}