clc;
clear;

%% Load ultrasound images into Matlab workspace

% File directory
filePath = 'Data2_Soft_pullback_1/Images';

numImgs = 2003; % total ultrasound images provided for pullback 0 to 2002

% Create cell array to store loaded images
images = cell(1,numImgs); 

% Loop to read in each image into cell array
for i = 0:numImgs-1
    fileName = fullfile(filePath, sprintf('%d.jpg', i)); % Filename
    images{i+1} = imread(fileName); % Load current image into images cell array
    
    fprintf('Loaded image: %s\n', fileName); % debugging, print to console to check to see if images loaded correctly
end

%% Process ultrasound images and find centre point

% Kernals used to remove noise and define aorta walls
% edgeDetect_K = [-1 -1 -1;-1 8 -1;-1 -1 -1]; 
% blur_K = (1/9)*[1 1 1;1 1 1;1 1 1];
% gussBlur_K = (1/16)*[1 2 1;2 4 2;1 2 1];

% Convolution functions to remove noise from ultrasound images
% imgresult = convolve_w_kernal(grey,gussBlur_K);
% imgresult2 = convolve_w_kernal(imgresult,edgeDetect_K);

% Create arrays to store processed images and found centre points
imagesProcessed = cell(1,numImgs); % array to store processed imgs
centrePoints = zeros(numImgs, 2); % array to store centre points

% Select region of interest (ROI) to apply to all ultrasound images
imshow(images{1}); % show first image in set to select ROI to apply to all other images
roi = drawrectangle('Label', 'Ultrasound ROI'); % prompts user to select ROI
position = roi.Position; % saves position of ROI
close;

% Loop to convert all ultrasound images into greyscale
for i = 1:numImgs
    % Convert to greyscale to remove some noise, then convert to binary
    % black & white at 60% threshold to remove almost all noise and define
    % aorta wall.
    greyImg = rgb2gray(images{i}); % convert to greyscale
    bwImg = im2bw(greyImg, 0.6); % convert to black/white
    
    % Save post processed image to show in GUI later
    imagesProcessed{i} = bwImg;
    
    % Extract ROI position to mask onto BW image to apply detection algorithms 
    x = round(position(1));
    y = round(position(2));
    width = round(position(3));
    height = round(position(4));
    
    roi_mask = false(size(bwImg)); % creating a blank mask of the same size as the processed BW image
    roi_mask(y:y+height,x:x+width) = true; % set all the pixels that fall inside selected ROI to true
    
    % Apply ROI mask to processed image BW img
    roiImg = bwImg;
    roiImg(~roi_mask) = 0; % set the pixels outside the ROI mask to be zero (black) so detection algorithms apply to selected ROI only
    
    % Use Matlab SURF (Speeded Up Robust Features) detection algorithm for
    % feature extraction
    points = detectSURFFeatures(roiImg);
    
    % Extract all x-coordinates and y-coordinates from feature points detected using SURF
    x_coords = points.Location(:,1);
    y_coords = points.Location(:,2);
    
    % Extract the max and min x and y points found in the image. The max
    % and min points on each axis will be used to find intesecting point =
    % centre point 
    x_max = max(x_coords);
    x_min = min(x_coords);
    y_max = max(y_coords);
    y_min = min(y_coords);
    
    % Find centre point of x points and centre point of y points
    centerPt_x = (x_max + x_min) / 2;
    centerPt_y = (y_max + y_min) / 2;
    
    % Save centre point in array
    
    centrePoints(i,:) = [centerPt_x,centerPt_y];

%     % Show processed image, with SURF detection points and centre point
%     imshow(bwImg); % Show BW image
%     hold on
%     plot(points); % Show SURF feature points
%     hold on
%     plot(centerPt_x, centerPt_y, 'ro', 'MarkerSize', 10,'MarkerEdgeColor', 'red', 'MarkerFaceColor', 'red', 'LineWidth', 2); % Plot centre point as red dot
%     hold off;
    
end

