/*******************************************************************************************/
/*********************************Base 3D Shape Modules*************************************/
/*******************************************************************************************/

module cube_base(width, length, height){
    cube(size = [width, length, height], center = true);
}

module cylinder_base(radius, height, resolution){
    cylinder(r = radius, h = height, $fn = resolution, center = true);
}

module cone_base(radius1, radius2, height, resolution){
    cylinder(r1 = radius1, r2 = radius2, h = height, $fn = resolution, center = true);
}

module sphere_base(radius, resolution){
    sphere(r = radius, $fn = resolution, center = true);
}
