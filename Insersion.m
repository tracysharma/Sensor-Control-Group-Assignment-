clc;
close all;
clear all;

%%
load Mesh_Soft_EM_Mod_0601.mat;

FV.vertices = ver;
FV.faces = tri;

figure(1);
%hold on;

patch(FV,'facecolor',[1 0 0],'facealpha',0.8,'edgecolor','none');
% patch(FV,'facecolor',[1 0 0],'facealpha',0.3,'edgecolor','none');
view(3)
camlight
axis equal;

%% Load Contour
folderPath = 'Data1_Soft_Insertion_2/Contours/';  % Replace with your actual folder path
files = dir(fullfile(folderPath, '*.txt'));  % Assuming .txt format for contours

numFiles = length(files);
% numFiles=100;
allContours = cell(1, numFiles);  % Pre-allocate for efficiency

for k = 1:numFiles
    filePath = fullfile(folderPath, files(k).name);
    allContours{k} = load(filePath);
end

%% Plot Contour
% %Plot One Contour
% 
% sampleContour = allContours{1};  % Extracting the first contour
% plot(sampleContour(:,1), sampleContour(:,2), 'b-');  % Assuming x is column 1, y is column 2
% xlabel('X-axis label');
% ylabel('Y-axis label');
% title('Sample Aorta Contour');
% axis equal;  % To ensure the correct aspect ratio

% %Plot All Contour
% % figure;
% hold on;
% for k = 1:numFiles
%     plot(allContours{k}(:,1), allContours{k}(:,2));
% end
% xlabel('X-axis label');
% ylabel('Y-axis label'); 
% title('All Aorta Contours');
% axis equal;
% hold off;

% % Animate Contour
% figure;
% for i = 1:numFiles
%     plot(allContours{i}(:,1), allContours{i}(:,2)); % Assuming 2D contour points
%     title(['Contour ', num2str(i)]);
%     pause(0.1); % Pause for 0.1 seconds between plots
% end

%% Load EM Data
% folderPath2 = 'Data2_Soft_pullback_1/EM/';  % Replace with your actual folder path
% files2 = dir(fullfile(folderPath, '*.txt'));  % Assuming .txt format for contours

folderPathEM = 'Data1_Soft_Insertion_2/EM/';  % Replace with your actual folder path
filesEM = dir(fullfile(folderPath, '*.txt'));  % Assuming .txt format for contours

numFilesEM = length(filesEM);
% numFilesEM = 100;
allEMs = cell(1, numFilesEM);  % Pre-allocate for efficiency

for k = 1:numFilesEM
    filePathEM = fullfile(folderPathEM, filesEM(k).name);
    allEMs{k} = load(filePathEM);
end

%% Plot EM

% %Plot One EM
% figure;
% sampleEM = allEMs{1};  % Extracting the first contour
% plot3(sampleEM(:,1), sampleEM(:,2), sampleEM(:,3), '-o');  % Assuming x is column 1, y is column 2
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% axis equal;  % To ensure the correct aspect ratio


% %Plot All EM
% figure;
% hold on;
% for k = 1:numFilesEM
%    plot3(allEMs{k}(:,1), allEMs{k}(:,2), allEMs{k}(:,3),'-o');
% end
% xlabel('X-axis label');
% ylabel('Y-axis label'); 
% title('All Aorta Contours');
% axis equal;
% hold off;



% emDataFile = fullfile('EM', '0.txt');
% [px, py, pz, qx, qy, qz, qw] = textread(emDataFile, '%f %f %f %f %f %f %f');
% 
% q = quaternion(qw, qx, qy, qz);
% rotMatrix = rotmat(q, 'point');
% 
% figure;
% plot3(px, py, pz, '-o');
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% title('EM Pose Data (Position)');
% grid on;
% hold on;

%% Mapping Contours to 3D Space

contours3D = cell(1, length(allContours));  % Initialize contours3D as a cell array

for i = 1:length(allContours)
    contour2D = allContours{i};
    contour2D(:,3) = 0; % Extend to 3D by setting z = 0
    
    % Extract EM data for this contour
    emPose = allEMs{i};
    translation = emPose(:,1:3);
    quaternion = emPose(:,4:7);
    
    % Convert quaternion to rotation matrix
    qw = quaternion(1);
    qx = quaternion(2);
    qy = quaternion(3);
    qz = quaternion(4);
    R = [1 - 2*(qy^2 + qz^2),  2*(qx*qy - qz*qw),      2*(qx*qz + qy*qw);
         2*(qx*qy + qz*qw),      1 - 2*(qx^2 + qz^2),  2*(qy*qz - qx*qw);
         2*(qx*qz - qy*qw),      2*(qy*qz + qx*qw),      1 - 2*(qx^2 + qy^2)];
    
    % Transform each point in the contour
    contour3D = zeros(size(contour2D));
    for j = 1:size(contour2D, 1)
        point2D = contour2D(j, :).';
        point3D = R * point2D + translation.';
        contour3D(j, :) = point3D.';
    end
    
    % Store the transformed contour
    contours3D{i} = contour3D;
end


%% Plot the 3D Contours

%figure;  % Open a new figure window
hold on; % Keep the plot active to overlay multiple contours

% Iterate over all 3D contours and plot them
for i = 1:length(contours3D)
    contour3D = contours3D{i};
    plot3(contour3D(:,1), contour3D(:,2), contour3D(:,3));
end

xlabel('X'); % Label for X-axis
ylabel('Y'); % Label for Y-axis
zlabel('Z'); % Label for Z-axis
title('3D Contours'); % Title for the plot
grid on;     % Turn on the grid for clarity
axis equal;  % To ensure that the scaling along each axis is the same
view(3);     % Default 3D view

hold off; % Release the plot

%% Compute the centreline
% Assuming contours3D is a cell array where each cell represents a contour slice in 3D

numContours = length(contours3D);
centroids = zeros(numContours, 3);  % [x, y, z]

% Compute centroids
for i = 1:numContours
    currentContour = contours3D{i};
    centroids(i, :) = mean(currentContour, 1);  % average over all points
end

% Order centroids if needed (based on z-coordinate for instance)
centroids = sortrows(centroids, 2);  % If needed

% % Assuming centroids is a Nx3 matrix and splitValue is the value where you want to split
% minX = min(centroids(:,1));
% maxX = max(centroids(:,1));
% 
% splitValue = (minX + maxX) / 2;
% % Split centroids into two parts
% leftCentroids = centroids(centroids(:,1) <= splitValue, :);
% rightCentroids = centroids(centroids(:,1) > splitValue, :);
% 
% % Sort the two parts
% leftCentroids = sortrows(leftCentroids, 2);  % Sort by y
% rightCentroids = sortrows(rightCentroids, 2);  % Sort by x
% 
% % Combine
% sortedCentroids = [leftCentroids; rightCentroids];
% 
% centroids=sortedCentroids;
%% Plotting the centreline
% %figure;
% hold on;
% 
% % % Plotting contours
% % for i = 1:numContours
% %     plot3(contours3D{i}(:,1), contours3D{i}(:,2), contours3D{i}(:,3), 'b');
% % end
% 
% % Plotting centerline
% plot3(centroids(:,1), centroids(:,2), centroids(:,3));
% 
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% view(3);


%% Plot as points
% 
% % Plotting
% figure;
% hold on;
% 
% % Plotting contours
% for i = 1:length(contours3D)
%     plot3(contours3D{i}(:,1), contours3D{i}(:,2), contours3D{i}(:,3), 'b');
% end
% 
% % Plotting centroids as points
% plot3(centroids(:,1), centroids(:,2), centroids(:,3), 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'r');
% 
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% view(3);
%% Polyfit method


% % Using t as the parameter
% t = (1:size(centroids,1))';
% 
% % Fit polynomials
% [p_x, ~, mu_x] = polyfit(t, centroids(:,1), 1);  % Linear fit for x
% [p_y, ~, mu_y] = polyfit(t, centroids(:,2), 1);  % Linear fit for y
% [p_z, ~, mu_z] = polyfit(t, centroids(:,3), 1);  % Linear fit for z
% 
% % Evaluate the fits over the range of t
% fit_x = polyval(p_x, t, [], mu_x);
% fit_y = polyval(p_y, t, [], mu_y);
% fit_z = polyval(p_z, t, [], mu_z);
% 
% % Plotting
% figure;
% hold on;
% 
% % Plotting contours
% for i = 1:length(contours3D)
%     plot3(contours3D{i}(:,1), contours3D{i}(:,2), contours3D{i}(:,3), 'b');
% end
% 
% % Plotting fitted centerline
% plot3(fit_x, fit_y, fit_z, 'r-', 'LineWidth', 2);
% 
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% view(3);

%% Convert Contour Data to a 3D Binary Image and Visualize

% Concatenate all the contour points into a single matrix
allPoints = vertcat(contours3D{:});

% Define the volume boundaries based on the contour data
x_min = min(allPoints(:,1));
x_max = max(allPoints(:,1));
y_min = min(allPoints(:,2));
y_max = max(allPoints(:,2));
z_min = min(allPoints(:,3));
z_max = max(allPoints(:,3));

% Create a 3D grid of points
[x_grid, y_grid, z_grid] = meshgrid(linspace(x_min, x_max, 200), linspace(y_min, y_max, 200), linspace(z_min, z_max, 200));

% Convert the 3D grid into a list of points
gridPoints = [x_grid(:), y_grid(:), z_grid(:)];

% Use pointCloud object for efficient nearest neighbor search
ptCloud = pointCloud(allPoints);

% Extract the point locations from the pointCloud object
ptLocations = ptCloud.Location;

% Find the closest point in ptLocations for each point in gridPoints
[~, dists] = knnsearch(ptLocations, gridPoints, 'K', 1);

% Convert the distances to a 3D matrix form
distMatrix = reshape(dists, size(x_grid));

% Threshold the distances to create a binary volume
binaryAorta = distMatrix <= 1; % you can adjust the threshold as needed

% Visualize the binary image
figure;
isosurface(x_grid, y_grid, z_grid, binaryAorta, 0.5);
hold on;



%% Approximate the centreline as Spline and plot

% Assuming centroids has been computed as per the previous code

% Using t as the parameter
t = (1:size(centroids,1))';

% Fit a cubic spline to the centroids
pp_x = spline(t, centroids(:,1));
pp_y = spline(t, centroids(:,2));
pp_z = spline(t, centroids(:,3));

% Evaluate the spline over a finer range of t for smoothness
t_fine = linspace(min(t), max(t), 1000)';
fit_x = ppval(pp_x, t_fine);
fit_y = ppval(pp_y, t_fine);
fit_z = ppval(pp_z, t_fine);

% Plotting
% figure;
hold on;

% Plotting contours
for i = 1:length(contours3D)
    plot3(contours3D{i}(:,1), contours3D{i}(:,2), contours3D{i}(:,3), 'b');
end

% Plotting fitted centerline
plot3(fit_x, fit_y, fit_z, 'r-', 'LineWidth', 2);

xlabel('X');
ylabel('Y');
zlabel('Z');
view(3);

%% Find EM position error or correction required to achieve centre point

% Create an array to store difference between EM position and centre point
% with rotation considered
EM_errorWR = zeros(numFilesEM,3);

% EM data saved in allEMs array is saved in a different format to
% centeriods, loop to rewrite EM data into new array in correct format
for i = 1:numFilesEM
    EMdata_pt = allEMs{i}; % Select ith cell in array
    EMdata_reform3(i,:) = EMdata_pt(1:3); % extract each value in array and save in seperate cell column in new array (3D point only for error w/o rotation)
    EMdata_reform7(i,:) = EMdata_pt(1:7); % extract each value in array and save in seperate cell column in new array (all data for error with rotation considered)
end
   
% Function to find EM error or correction with rotation considered
for i = 1:numFilesEM
    EM_3Dcoor = EMdata_reform7(i,1:3); % Extract 3D coordinates for ith EM point
    EM_quaternion = EMdata_reform7(i,4:7); % Extract rotation data for ith EM point
    
    Rot_matrix = quat2rotm(EM_quaternion); % Convert quaternion to rotation matrix
    
    rotated_EMcoor = (Rot_matrix * EM_3Dcoor')'; % Apply rotation to data coordinates
    
    % Find error or difference between center point and EM data pt (with rotation considered)
    variance = centroids(i,:) - rotated_EMcoor; 
    EM_errorWR(i,:) = variance; % store EM error with rotation considered into array
   
end
 
% Calculate EM poistion error or difference from centrepoint WITHOUT
% rotation
 EM_error = EMdata_reform3 - centroids;
 
% Display on console for debugging
 disp('The below dataset is the EM error or correction required to achieve centrepoint WITHOUT rotation considered:');
 disp(EM_error);
 disp('The below dataset is the EM error or correction required to achieve centrepoint WITH rotation considered:');
 disp(EM_errorWR);
 

