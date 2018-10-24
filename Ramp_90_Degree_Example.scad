include <variables.scad>
include <primitive_modules.scad>

/*******************************************************************************************/
/***********************************Sample 3D Model*****************************************/
/*******************************************************************************************/
/*
/*
/*
/***********************************Ramp Side**********************************************/
/* This is one of two modules that get combined to create the functional part of a ramp
 * down which a 16 mm diameter marble can travel.  The "sides" of the ramp, in contrast to the
 * "corners" of the ramp, will sit along the faces of a cubic tower, which shall act as a
 * support structure preventing the ramp from floating in mid air.
 * A ramp side is simply a cube from which a half cylinder has been subtracted.  The half
 * cylinder is centered such that the top face of the cube bisects the cylinder.  This
 * ensures that there will be enough of a wall to the ramp to accommodate a marble rolling
 * down it without falling over one side, while leaving the marble exposed for visual effect.
 */
module ramp_side(){
    difference(){
        //The outer hull of the side of the ramp
        cube_base(board_w, ball_r * 4 - wall_t * 1.5, board_h);
        //The hollow through which the marble can travel.
        //Translate in the positive z direction, then rotate about the x axis.
        translate([0, 0, board_h * 0.5])
        rotate([90, 0, 0])
        cylinder_base(ball_r, ball_r * 4 + cube_allowance, 100);
    }
}
/***********************************Ramp Corner********************************************/
/* This is the second of two modules that get combined to create the functional part of a ramp
 * down which a 16 mm diameter marble can travel.  This module is called a "corner" due to
 * the fact that it is meant to be placed at the corners of the support tower that will
 * run the length of the spiral ramp.  Similar to the ramp sides, the corners are designed from
 * carving out a curved shape from a cube.  The main difference here is that, for the side
 * module, the cylinder that produces the curve is rotated 15 degrees, not the 90 degrees of
 * the ramp sides.  Because cylinders default to being upright in OpenSCAD, this means there is
 * just enough slope to this ramp corner to keep the flat part of the cylindrical cutout from
 * merely being a landing upon which a marble would stop.  The 15 degree tilt allows the marble
 * to bounce off of the curved surface of the cylindrical cutout, and then follow gravity down
 * the subtle slope.
 */

module ramp_corner(){
    difference(){
        translate([0, 0, -wall_t * 2])
        cube_base(board_w + wall_t * 2, board_w + wall_t * 2, board_h + wall_t * 4);
        translate([(board_w + wall_t) * 0.45, (board_w + wall_t) * 0.45, 0    ])
        rotate([0, 15, 0])
        cylinder_base(ball_r * 2 + wall_t, board_h + wall_t * 2, resolution);
    }
}
/***********************************Simple Twist*******************************************/
module simple_twist(top_ramp){
    //Using sine and cosine, create a square shaped cascading ramp.
    //Here, five sides of the ramp are placed.
    for(index = [0:top_ramp]){
        translate([sin(180 * index/2) * board_l, cos(180 * index/2) * (board_l + wall_t/2), z * index])
        rotate([0, 0, 90 * r_z[index]])
        
        rotate([15 * r_xy[index], 0, 0])
        ramp_side();
    }
    //Using a larger swath of the sine and cosine curves, place ramp corner pieces.
    //These pieces should provide a backboard for a marble rolling down one ramp segment/side,
    //as well as an avenue for transitioning to the next ramp.  As of 09 Oct, 2018, these pieces may
    //be too narrow for the intended function.
    for(index = [0:top_ramp + 2]){
        translate([sin(180 * index/4) * (board_l + board_w * 0.65), cos(180 * index/4) * (board_l + board_w * 0.65), zc[index-1] + board_h * 0.75])
        rotate([0, 0, 90 * r_z[index]])
        if(index%2 != 0){
            rotate([0, 0, corner_rz[index-1]])
            translate([0, 0, ball_r]){
              ramp_corner();
            }
        }
    }
}

/***********************************Twist Ramp*********************************************/
module twist_ramp(){
    
    //Union groups structures, along with their transformations.  Any further transformations,
    //or other operations performed upon a union (e.g. scale()) apply to everything within
    //the union block.  A union can be thought of as a more local way of grouping things
    //together than a module.  A module can be instantiated again and again anywhere downstream
    //of where it is defined.  A union exists in one location, and one location only.
    //If you wanted to have copies of what is in the union exist across your model, you
    //should make it a module instead.
    union(){
        translate([0, 0, board_h * 1.25])
        //Create a hollow cubic tower with each wall being of dimension wall_t/2.  (Why
        //wall_t/2, and not wall_t?)  
        //Difference allows one or more sets of structures to be subtracted (carved out
        //from) another set of structures.  As OpenSCAD executes top to bottom, that which 
        //is placed in earlier lines within the difference block defines the structure(s) 
        //from which everything else will be subtracted.
        difference(){
            cube_base(ball_r * 4, ball_r * 4, board_h * 4);
            cube_base(ball_r * 4 - wall_t, ball_r * 4 - wall_t, board_h * 4);
        }
        //Invoke the simple_twist module using three levels.  Notice, the twist is not
        //translated, but the above tower is.  This is because, the design of the
        //twist is such that a twist will not be centered as a whole.  The first level
        //is centered at the origin, while the rest is built on top of that level.
        //This means, if we want a tower supporting the inner hollow of the twist, but
        //create the tower using centered cubes, it will not be properly aligned with the
        //twist unless one or both objects get translated.  The easier move is to translate the
        //tower.  Though, as a generalization, the better move may be to translate the
        //twist based on known z dimensions and the number of levels (in this case, 3).
        simple_twist(3);
        
        index = 5;
        translate([sin(180 * index/4) * (board_l + board_w * 0.65), cos(180 * index/4) * (board_l + board_w * 0.65), zc[index-1] + board_h * 0.75])
        rotate([0, 0, 90 * r_z[index]])
        if(index%2 != 0){
            rotate([0, 0, corner_rz[index-1]])
            translate([0, 0, ball_r]){
              ramp_corner();
            }
        }
    }
    
}

//Make use of the modules to render the 90 degree ramp/twist.
twist_ramp();