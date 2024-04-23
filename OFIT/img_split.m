function [px,py]=img_split(img,threshold,params,info)
ref_color=0;                                  % the background lightness is 67
bin_mask = zeros(info.Height,info.Width);
bin_mask = bin_mask | (img - ref_color).^2 <= threshold^2; % MagicWand method
   
Blobs=bwconncomp(~bin_mask);                   % Find the connected blobs in 2-D image
numPixels=cellfun(@numel,Blobs.PixelIdxList);  % Get the pixel numbers of each blob
[~,idx]=max(numPixels);                        % The index of the biggest Blob
biggest_Blob=zeros(info.Height,info.Width);
biggest_Blob(Blobs.PixelIdxList{idx})=1;       % biggest_Blob is the selection of biggest blob
se=strel('disk',5);img5=imerode(biggest_Blob,se);
boundaries = bwboundaries(img5);       % Get the boundary of biggest blob

for k=1:length(boundaries)
    num(k)=length(boundaries{k});
end
firstBoundary = boundaries{num==max(num)};
x = firstBoundary(:, 2); 
y = firstBoundary(:, 1); 
%--------------------
windowWidth = 199;
polynomialOrder = 3;
overlap=100;
x(end+1:end+overlap)=x(1:overlap);
y(end+1:end+overlap)=y(1:overlap);
x1 = sgolayfilt(x, polynomialOrder, windowWidth); % Curvefit of the discrete points in Img
y1 = sgolayfilt(y, polynomialOrder, windowWidth);
boundx=x1(1+overlap/2:end-overlap/2);
tempx(1:length(boundx)-500)=boundx(501:end);
tempx(length(boundx)-500+1:length(boundx))=boundx(1:500);
boundy=y1(1+overlap/2:end-overlap/2);
tempy(1:length(boundy)-500)=boundy(501:end);
tempy(length(boundy)-500+1:length(boundy))=boundy(1:500);
global shotnum
ratio=params.ratio2/1e3;
px=(tempx-params.cx(shotnum))*ratio;    % Image x axis in meter unit
px=px';
py=(tempy-params.cy)*ratio;    % Image x axis in meter unit
py=py';
end