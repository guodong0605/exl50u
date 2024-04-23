% Replace the bad pixels of a scene with the median of their nearest neighbours.
%   [corr_im uncorr_bp] = filterBadPixels(badpixels, width, height, Scene, AOI, param1, value1, ...)
%
%   Filter the bad pixels bpmap using a spatial median filter (8-neighbour
%   connectivity) on the input scene. The scene has (width x height) pixels,
%   unless the subwindow AOI is defined, in which case, width and height
%   represent the greater frame into which the AOI is defined.
%
%   INPUTS
%       bpmap  : [-] This is a vector (N x 1) containing the index position of
%                the bad pixels on the detector, or a Nx1 logical vector.
%       width  : [pixels] Horizontal size of the window or the FPA (depending on the AOI
%                input).
%       height : [pixels] Vertical size of the window or the FPA (depending on the AOI
%                input).
%       Scene  : [a.u.] Scene to be corrected. This scene can be a calibrated or non
%                calibrated datacube or image. The spatial information of the data
%                corresponds to the row index of the matrix. The values in each row
%                represent the spectral or temporal information.
%       AOI    : [optional] area of interest structure with fields .Width, .Height,
%                .OffsetX, and .OffsetY, corresponding to the subwindow containing the
%                scene.
%
%   Properties:
%       'recurse': {true, false}, loop until all bad pixels are corrected.
%                  Default is false.
%
%       'method' : {'median', 'medoid-sum' [default], 'medoid-max'}. 'median' takes the
%                  median of the quantities frame by frame (good with temporal data or
%                  single images.) 'medoid-sum' takes the quantity that has the median
%                  average value (good with spectral data) 'medoid-max' takes the quantity
%                  that has the median maximum value (good with interferograms).
%
%   OUTPUTS
%       corr_im   : Same information as in the 'Scene' input, but the bad pixels are
%                   replaced by the median of their valid neighbours (maximum of 8
%                   neighbours).
%       uncorr_bp : The list of pixels that have not been corrected.
%       repMap    : The map of replacement indices. For methods 'medoid-sum' and
%                   'medoid-max' it has dimensions <1 x Npx>, since a single map is used.
%                   For method 'median' it has the same dimensions as the 'Scene' <Nim x
%                   Npx>, since each frame ends with its own replacement map.
%
%   Examples:
%
%   Ex. 1: the scene is a subwindow AOI of a 320x256 detector.
%   [scene, DH, H] = readHyperCam(filemame);
%   sceneCorr = filterBadPixels(bpmap, H.SensorWidth, H.SensorHeight, scene, H);
%
%   Ex. 2: the bad pixel map is in the data vector referential
%   [scene, DH, H] = readHyperCam(filemame);
%   sceneCorr = filterBadPixels(bpmap, H.XSize, H.YSize, scene);
%
%