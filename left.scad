// -----
// Components
// Comment/uncomment these when exporting for seperate files.
// -----

case();
plate();

// -----
// Visualisations
// -----

// pcb_visualisation();

// -----
// Unique driving parameters
// -----

// Vertical stagger amount per column (mm)
columns = [0, 0, 0, 6.5,9,7.5,5.25,0];
// Width of each column (mm)
column_widths = [ 25, 19, 19, 19, 19, 19, 19, 19];

// Horizontal stagger amount per row (mm)
rows = [0,0,0,0,0]; 
// Height of each row (mm)
row_heights = [19,19,19,19,19];

// A list of every keyboard row and column with a key.
key_locations = [   
   // This loop generates a list containing every row (0-4, 5 total) for columns 1,2,3,4,5, and 6. (0-indexed)
   for (i = [0:4]) each [[1, i], [2, i], [3, i], [4, i], [5, i], [6, i]] 
];

// Location on the keyboard of peripherals.
// TODO: use absolute coordinates, or add offsets or something to this.
xiao_location = [0,4];
display_location = [0,0];
encoder_location = [7,0];
slider_location = [7,2];

// Height (mm) from the origin of the magnet connectors, and the trrs sockets.
trrs_left_y = 60;
trrs_right_y = 85.05;
magnet_left_y = 47.5;
magnet_right_y = 47.5;

// XY location (mm) of every screw hole. All screwholes are assumed to be M3 size.
screw_holes = [
    [120,64.5], // H1
    [82,85.5], // H2
    [44,38], // H3
    [101,28], // H4
    [22.1,28.5], // H5
    [139,42.5], // H6
    [44,76], // H7
    [154.25,19], // H8
    [139,80.5], // H9
];

include <case.scad>;