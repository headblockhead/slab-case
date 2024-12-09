// -----
// Components
// Comment/uncomment these when exporting for seperate files.
// -----

// render_case and render_plate are set by the openscad CLI.
if (render_case) {
  case();
}
if (render_plate) {
  plate();
}

// case();
// plate();

// -----
// Visualisations
// -----

// pcb_visualisation();

// -----
// Unique driving parameters
// -----

// Vertical stagger amount per column (mm)
columns = [0, 0,0,0,0,0];
// Width of each column (mm)
column_widths = [ 25, 19, 19, 19, 19, 19];

// Horizontal stagger amount per row (mm)
rows = [0,0,0,0,0]; 
// Height of each row (mm)
row_heights = [19,19,19,19,19];

// A list of every keyboard row and column with a key.
key_locations = [   
   // This loop generates a list containing every row (0-4, 5 total) for columns 1,2,3,4,5, and 6. (0-indexed)
   for (i = [0:4]) each [[1, i], [2, i], [3, i], [4, i]] 
];

// Location on the keyboard of peripherals.
// TODO: use absolute coordinates, or add offsets or something to this.
xiao_location = [0,4];
display_location = [0,0];
encoder_location = [-1,-1];
slider_location = [-1,-1];

// Height (mm) from the origin of the magnet connectors, and the trrs sockets.
trrs_left_y = 60.5;
trrs_right_y = 85;
magnet_left_y = 47.5;
magnet_right_y = 47.5;

// XY location (mm) of every screw hole. All screwholes are assumed to be M3 size.
screw_holes = [
    [101,76], // H1
    [116.25,19], // H2
    [82,19], // H3
    [44,38], // H4
    [82,57], // H5
    [44,76], // H6
    [22.1,28.5], // H7
];

include <case.scad>;
