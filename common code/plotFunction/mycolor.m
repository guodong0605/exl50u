function color_cell= mycolor(N)
 color_cell= maxdistcolor(N,@srgb_to_Lab); % Exclude black background.
 end

