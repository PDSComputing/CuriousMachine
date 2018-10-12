cube_allowance = 0.5;
rad_allowance  = 0.25;
resolution     = 100;
face_r         = 10;
face_h         = 5;
eye_r          = 2;
eye_h          = face_h + cube_allowance;
smile_r        = 6;
smile_h        = eye_h;
    
wall_t         = 4;
ball_r         = 9 + rad_allowance ;
board_w        = ball_r * 2 + wall_t;//5;
board_h        = ball_r * 2 + wall_t;//20;
board_l        = ball_r * 3;

//top_ramp = 3;

z = sin(15) * board_h * 3;
    zc = [z * 0, 0, z * 1, 0, z * 2, 0, z * 3, 0, z * 4, 0, z * 5, 0, z * 6];
    x = [0, 1, 1, 0, -1, -1, -1, 0, 1, 1, 0];
    y = [0, 0, 1, 1, 1, 0, -1, -1, -1, 0, 0];
    r_xy = [-1, -1, 1, 1, -1, -1, 1, 1, -1, -1, 1];
    r_z  = [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1];
    corner_rz = [180, 0, 90, 0, 0, 0, -90, 0];
    
magnet_h = 24 + cube_allowance;
magnet_r = 2 + rad_allowance;
bearing_r = 4 + rad_allowance;
pike_l    = 30;
