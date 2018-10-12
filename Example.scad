include <variables.scad>
include <primitive_modules.scad>

/*******************************************************************************************/
/***********************************Sample 3D Model*****************************************/
/*******************************************************************************************/

/***********************************Smiley Face*********************************************/
module smiley_face(){
    difference(){
        cylinder_base(face_r, face_h, resolution);
        translate([-face_r/3, face_r/3, 0])
        cylinder_base(eye_r, eye_h, resolution);
        mirror([1, 0, 0]){
            translate([-face_r/3, face_r/3, 0])
            cylinder_base(eye_r, eye_h, resolution);
        }
        difference(){
            cylinder_base(smile_r, smile_h, resolution);
            translate([0, smile_r/2, 0])
            cube_base(smile_r * 2, smile_r, smile_h);
        }
    }
}
/***********************************Ramp Side**********************************************/
module ramp_side(){
    difference(){
        cube_base(board_w, ball_r * 4 - wall_t * 1.5, board_h);
        translate([0, 0, board_h * 0.5])
        rotate([90, 0, 0])
        cylinder_base(ball_r, ball_r * 4 + cube_allowance, 100);
    }
}
/***********************************Ramp Corner********************************************/
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
    //Local variables too obtusely named to warrant global scope.
        
    

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
    for(index = [0:top_ramp + 1]){
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
module twist_ramp(){
    difference(){
        
        //translate([0, 0, -17])
        union(){
            translate([0, 0, board_h * 1.25])
            difference(){
                cube_base(ball_r * 4, ball_r * 4, board_h * 4);
                cube_base(ball_r * 4 - wall_t, ball_r * 4 - wall_t, board_h * 4);
            }
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
        union(){
            translate([0, 0, board_h * 0.25])
            difference(){
                cube_base(ball_r * 4, ball_r * 4, board_h * 2);
                cube_base(ball_r * 4 - wall_t, ball_r * 4 - wall_t, board_h * 2);
            }
            simple_twist(1);
        }
    }
   
}

module accelerator_spacer(){
    difference(){
        cylinder_base(bearing_r + wall_t, magnet_h + bearing_r * 8, resolution);
        translate([(magnet_r * 4 + wall_t * 0.5), 0, 0])
        cube_base((bearing_r + wall_t) * 2, (bearing_r + wall_t) * 2, magnet_h + bearing_r * 8);
        cylinder_base(bearing_r * 1, magnet_h + bearing_r * 8, resolution);
    }
}

module accelerator_segment(){
    difference(){
        accelerator_spacer();
        for(x = [-1, 1]){
            for(y = [-1, 1]){
                translate([magnet_r * x, magnet_r * y, 0])
                cylinder_base(magnet_r, magnet_h, resolution);
            }
        }
        translate([0, 0, magnet_h * 0.5 + bearing_r])
        sphere_base(bearing_r, resolution);
        translate([0, 0, magnet_h * 0.5 + bearing_r * 3])
        sphere_base(bearing_r, resolution);

        mirror([0, 0, 1]){
            translate([0, 0, magnet_h * 0.5 + bearing_r])
            sphere_base(bearing_r, resolution);
            translate([0, 0, magnet_h * 0.5 + bearing_r * 3])
            sphere_base(bearing_r, resolution);
        }
        
    }
}
/*******************************************************************************************/
/***************************************Model Use*******************************************/
/*******************************************************************************************/

accelerator_segment();
translate([0, 0, (magnet_h + bearing_r * 8) * 0.625])
scale([1, 1, 0.25])
accelerator_spacer();
translate([0, 0, (magnet_h + bearing_r * 8) * 1.25])
accelerator_segment();
translate([0, 0, -(magnet_h + bearing_r * 8) * 0.625])
scale([1, 1, 0.25])
accelerator_spacer();
