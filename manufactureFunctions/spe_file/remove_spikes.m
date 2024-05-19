function z = remove_spikes(im_in, thresh)

    % Takes an input matrix/grayscale image im_in and returns a matrix z
    % corresponding to im_in with data spikes removed. Input variable 
    % thresh refers to the threshold for considering a given pixel a
    % "spike" in the data. It is highly recommended that thresh not have a
    % value below 1. If it does, there is a risk that the function
    % classifies non-spikes as spikes.
    %
    % This code is most effective against speckle noise, salt-and-pepper or
    % impuse noise, and otherwise spikey data. Its intended application is 
    % image data that contains a scattering of pixels that have sharp 
    % intensity values differing significantly from those of their 
    % neighboring pixels. This type of noise is a common artifact of 
    % interferograms and radar images. Note that this function may not be 
    % an effective method of reducing other types of noise or image 
    % artifacts.
    %
    % The code functions by identifying the nearest neighbors of each
    % pixel (8 nearest neighbors for central pixels, 5 for edges, 3 for
    % corners) and calculating the mean and standard deviation values of
    % those neighbors. If the pixel of interest is further than thresh
    % standard deviations away from the mean value of its neighboring
    % pixels, it will be considered a data spike. It will then be removed
    % and replaced using my fill_region function, which accomplishes the
    % same task as the regionfill function of the Image Processing Toolbox.
    %
    % NOTE: If you do not have the Image Processing Toolbox, you should
    % replace the call to the regionfill function in this code with a call
    % to my fill_region function (included in this folder), which 
    % accomplishes the same task with comparable computational efficiency. 
    % Either will run reasonably quickly, even for higher-resolution 
    % images.
    %
    %
    % Example 1:
    %     
        % Load image "rice.png" into variable z
%         z_original = imread('rice.png');
%         z = z_original;
%     
%         % Populate 10% of the image with data spikes in randomly selected locations
%         cmin = min(min(z));
%         cmax = max(max(z));
%         for i = 1:ceil(size(z,1)*size(z,2)*0.1)
%             z(ceil(size(z,1)*rand),ceil(size(z,2)*rand)) = cmax*(rand);
%         end
%     
%         % Display original image, image with data spikes, and image with data
%         % spikes after being run through the remove_spikes function using different
%         % values for thresh
%     
%         figure,imagesc(z_original, [cmin cmax]);
%         title('Original image');
%         colormap('gray');
%     
%         figure,imagesc(z, [cmin cmax]);
%         title('Original image with spikes');
%         colormap('gray');
%     
%         spikes_removed = remove_spikes(z,3);
%         figure, imagesc(spikes_removed, [cmin cmax]);
%         title('Spikes removed, thresh = 3');
%         colormap('gray');
%     
%         spikes_removed = remove_spikes(z,2);
%         figure, imagesc(spikes_removed, [cmin cmax]);
%         title('Spikes removed, thresh = 2');
%         colormap('gray');
%     
%         spikes_removed = remove_spikes(z,1);
%         figure, imagesc(spikes_removed, [cmin cmax]);
%         title('Spikes removed, thresh = 1');
%         colormap('gray');
    % 
    %     % Under some circumstances, it may be desirable to run an image through
    %     % remove_spikes multiple times:
    %     spikes_removed = remove_spikes(z,1);
    %     spikes_removed = remove_spikes(spikes_removed,1);
    %     figure, imagesc(spikes_removed, [cmin cmax]);
    %     title('Spikes removed, thresh = 1, 2 iterations');
    %     colormap('gray');
    % 
    %     spikes_removed = remove_spikes(z,1);
    %     spikes_removed = remove_spikes(spikes_removed,1);
    %     spikes_removed = remove_spikes(spikes_removed,1);
    %     figure, imagesc(spikes_removed, [cmin cmax]);
    %     title('Spikes removed, thresh = 1, 3 iterations');
    %     colormap('gray');
    %
    %
    % Example 2:
    %
    %     % Create some function z(x,y) (can be displayed as image)
    %     x=linspace(-1,1,200);
    %     y=linspace(1,-1,200);
    %     [x,y] = meshgrid(x,y);
    %     z_original = sin(5*x.^2) + 2*sin(5*y);
    %     z = z_original;
    % 
    %     % Populate 10% of the image with data spikes in randomly selected locations
    %     cmin = min(min(z));
    %     cmax = max(max(z));
    %     for i = 1:ceil(size(z,1)*size(z,2)*0.1)
    %         z(ceil(size(z,1)*rand),ceil(size(z,2)*rand)) = 2*[cmax-cmin]*(rand-0.5);
    %     end
    % 
    %     % Display original image, image with data spikes, and image with data
    %     % spikes after being run through the remove_spikes function using different
    %     % values for thresh
    % 
    %     figure,imagesc(z_original, [cmin cmax]);
    %     title('Original image');
    % 
    %     figure,imagesc(z, [cmin cmax]);
    %     title('Original image with spikes');
    % 
    %     spikes_removed = remove_spikes(z,3);
    %     figure, imagesc(spikes_removed, [cmin cmax]);
    %     title('Spikes removed, thresh = 3');
    % 
    %     spikes_removed = remove_spikes(z,2);
    %     figure, imagesc(spikes_removed, [cmin cmax]);
    %     title('Spikes removed, thresh = 2');
    % 
    %     spikes_removed = remove_spikes(z,1);
    %     figure, imagesc(spikes_removed, [cmin cmax]);
    %     title('Spikes removed, thresh = 1');
    % 
    %     % Under some circumstances, it may be desirable to run an image through
    %     % remove_spikes multiple times:
    %     spikes_removed = remove_spikes(z,1);
    %     spikes_removed = remove_spikes(spikes_removed,1);
    %     figure, imagesc(spikes_removed, [cmin cmax]);
    %     title('Spikes removed, thresh = 1, 2 iterations');
    % 
    %     spikes_removed = remove_spikes(z,1);
    %     spikes_removed = remove_spikes(spikes_removed,1);
    %     spikes_removed = remove_spikes(spikes_removed,1);
    %     figure, imagesc(spikes_removed, [cmin cmax]);
    %     title('Spikes removed, thresh = 1, 3 iterations');    
    %
    %
    % Functions required for use: fill_region (or Image Processing Toolbox)
    % 
    % Evan Czako, 11.22.2019
    % -------------------------------------------    

    z = double(im_in);
    u = sort([find(z);find(~z)]);
    M = size(z,1);
    N = size(z,2);

    %% Handle central region (non-edges/non-corners)

    u_center = u;
    % Remove edge/corner indices
    u_center((M*N-M+1):(M*N))=[];
    u_center(1:M)=[];
    u_center(find(mod(u_center,M)==0))=[];
    u_center(find(mod(u_center,M)==1))=[];
    
    % Get indices of neighboring pixels
    u_north = u_center - 1;
    u_northeast = u_center + M - 1;
    u_east = u_center + M;
    u_southeast = u_center + M + 1;
    u_south = u_center + 1;
    u_southwest = u_center - M + 1;
    u_west = u_center - M;
    u_northwest = u_center - M - 1;
    
    % Get indices of neighboring pixels
    neighbors_center = double([u_north u_northeast u_east u_southeast  u_south u_southwest u_west u_northwest]);
    mean_std_index_list = [mean(z(neighbors_center.')).' std(z(neighbors_center.')).' z(u_center) u_center];


    %% Handle edges

    u_left = u(2:M-1);
    u_right = u((M*N-M+2):(M*N-1));
    u_bottom = find(mod(u,M)==0);
    u_bottom(N) = [];
    u_bottom(1) = [];
    u_top = find(mod(u,M)==1);
    u_top(N) = [];
    u_top(1) = [];

    % Left neighbors
    u_left_north = u_left - 1;
    u_left_northeast = u_left + M - 1;
    u_left_east = u_left + M;
    u_left_southeast = u_left + M + 1;
    u_left_south = u_left + 1;
    neighbors_left = [u_left_north u_left_northeast u_left_east u_left_southeast u_left_south];
    mean_std_index_list = [mean_std_index_list; mean(z(neighbors_left.')).' std(z(neighbors_left.')).' z(u_left) u_left];

    % Right neighbors
    u_right_north = u_right - 1;
    u_right_northwest = u_right - M - 1;
    u_right_west = u_right - M;
    u_right_southwest = u_right - M + 1;
    u_right_south = u_right + 1;
    neighbors_right = [u_right_north u_right_northwest u_right_west u_right_southwest u_right_south];
    mean_std_index_list = [mean_std_index_list; mean(z(neighbors_right.')).' std(z(neighbors_right.')).' z(u_right) u_right];

    % Top neighbors
    u_top_west = u_top - M;
    u_top_southwest = u_top - M + 1;
    u_top_south = u_top + 1;
    u_top_southeast = u_top + M + 1;
    u_top_east = u_top + M;
    neighbors_top = [u_top_west u_top_southwest u_top_south u_top_southeast u_top_east];
    mean_std_index_list = [mean_std_index_list; mean(z(neighbors_top.')).' std(z(neighbors_top.')).' z(u_top) u_top];

    % Bottom neighbors
    u_bottom_west = u_bottom - M;
    u_bottom_northwest = u_bottom - M - 1;
    u_bottom_north = u_bottom - 1;
    u_bottom_northeast = u_bottom + M - 1;
    u_bottom_east = u_bottom + M;
    neighbors_bottom = [u_bottom_west u_bottom_northwest u_bottom_north u_bottom_northeast u_bottom_east];
    mean_std_index_list = [mean_std_index_list; mean(z(neighbors_bottom.')).' std(z(neighbors_bottom.')).' z(u_bottom) u_bottom];


    %% Handle corners

    u_upper_left = u(1);
    u_upper_left_neighbors = [u(2) u(M+1) u(M+2)];
    mean_std_index_list = [mean_std_index_list; mean(z(u_upper_left_neighbors.')).' std(z(u_upper_left_neighbors.')).' z(u_upper_left) u_upper_left];
    u_bottom_left = u(M);
    u_bottom_left_neighbors = [u(M-1) u(2*M-1) u(2*M)];
    mean_std_index_list = [mean_std_index_list; mean(z(u_bottom_left_neighbors.')).' std(z(u_bottom_left_neighbors.')).' z(u_bottom_left) u_bottom_left];
    u_upper_right = u(M*N-M+1);
    u_upper_right_neighbors = [u(M*N-2*M+1) u(M*N-2*M+2) u(M*N-M+2)];
    mean_std_index_list = [mean_std_index_list; mean(z(u_upper_right_neighbors.')).' std(z(u_upper_right_neighbors.')).' z(u_upper_right) u_upper_right];
    u_bottom_right = u(M*N);
    u_bottom_right_neighbors = [u(M*N-M-1) u(M*N-M) u(M*N-1)];
    mean_std_index_list = [mean_std_index_list; mean(z(u_bottom_right_neighbors.')).' std(z(u_bottom_right_neighbors.')).' z(u_bottom_right) u_bottom_right];



    %% Remove spikes

    [~,idx] = sort(mean_std_index_list(:,4));
    sorted_list = mean_std_index_list(idx,:);
    a = sorted_list;
    a = [a double(a(:,1)+thresh*a(:,2)<a(:,3)) + double(a(:,1)-thresh*a(:,2)>a(:,3))];
    sorted_list = a;

    spike_pixel_indices = find(sorted_list(:,5));
    z(spike_pixel_indices) = NaN;
    mask = isnan(z);
    z = regionfill(z,mask);
    
end