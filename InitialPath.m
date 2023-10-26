x = 1:length(centroids);
y = 1:width(EMData);
z = (x-y);
plot(z)

translation_location = 'C:\Users\Aleisha Tran\OneDrive\Documents\MATLAB\Sensors and Control\Data1_Soft_Insertion_2\EM';       %  folder in which your images exists
fileName = [translation_location, 'EMdataFin'];
fileEntireDataSet = readdata(fileName);


fid = fopen(fileEntireDataSet);
    %        ^^^^^^^^^^----- your filename
formatspec=['%f',repmat('%*f',1,2,3,7)]; % 5 represents total columns - the first column
data = textscan(fid,formatspec);
fid = fclose(fid);
data{:,:,:}


rotation = [0.7071, 0, 0.7071; 0, 1, 0; -0.7071, 0, 0.7071]; % Rotation matrix

% Assuming you have a point in the original frame, for example:
point = [1; 1; 1]; % Point coordinates in the original frame

% Creating a 4x4 transformation matrix
transformation_matrix = eye(4);
transformation_matrix(1:3, 1:3) = rotation;
transformation_matrix(1:3, 4) = translation_location;

% Adding the homogeneous coordinate
point_homogeneous = [point; 1];

% Applying the transformation matrix
transformed_point_homogeneous = transformation_matrix * point_homogeneous;

% Extracting the transformed point
transformed_point = transformed_point_homogeneous(1:3);

% Displaying the results
disp("Original Point:")
disp(point')


