$fn = 20;

// Generate a round-capped line on the x-axis.
// The end points of the line are centered at zero and `length`.
module grid_line(length, width) {
  hull() {
    cylinder(d=width, h=1);
    translate([length, 0, 0])
      cylinder(d=width, h=1);
  }
}

// `line_spacing` is the distance between the centers of the lines, not the distance between the edges of each line.
module grid(width, height, line_width, line_spacing) {
  for(row = [0:height])
    translate([0, row * line_spacing, 0])
      grid_line(length=width, width=line_width);
  rotate([0, 0, 90])
    for(column = [0:width])
      translate([0, -column * line_spacing, 0])
        grid_line(length=width, width=line_width);
}

module upright_data_point(value) {
  cylinder(h=value, d=1);
}

function sinc(x) = x == 0 ? 1 : sin(x) / x;

module data_points(width, height, point_scale=1) {
  for(x = [0:width])
    for(y = [0:height]) {
      // magnitude = cos(8 * PI * (x + y)) + 1;
      frequency = 20 * PI;
      magnitude = (cos(frequency * x) + cos(frequency * y)) / 2 + 1;
      translate([x, y, 0])
        scale([point_scale, point_scale, 1])
          /* Switch between real-valued or thresholded
          upright_data_point(0.5 * magnitude + 0.1);
          /*/
          upright_data_point(magnitude < 1 ? 0 : 1);
          //*/
    }
}

grid_size = 10;
scale([1, -1, 1]) {
  scale([1, 1, 0.1])
    grid(grid_size, grid_size, line_width=0.1, line_spacing=1);
  data_points(grid_size, grid_size, point_scale=0.5);
}