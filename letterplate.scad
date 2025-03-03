// Arc+Circle resolution - 16 if previewing.
$fn = $preview ? 16 : 128;

translate([0,0,-1])
cube([8,8,2], center=true);
linear_extrude(height=1)
// 'letter' should be set using the openscad CLI.
text(letter, size=7, font="Liberation Mono:style=Bold", halign="center", valign="center");
