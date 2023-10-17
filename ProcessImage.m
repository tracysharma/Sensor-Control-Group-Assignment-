clc;
clear;

location = 'C:\Users\Aleisha Tran\OneDrive\Documents\MATLAB\Sensors and Control\Data2_Soft_pullback_1\Images';       %  folder where Ultrasound images exists
ds = imageDatastore(location)                                                                                        %  Variable for data of all the photos

while hasdata(ds)                                                                                                    %  While loop to have all images read at the same time
    
    A = read(ds);

    imgGs = convertRGBtoGrayscale_student(A);

    imshow(imgGs)

end

