clc;
clear;

location = 'C:\Users\Aleisha Tran\OneDrive\Documents\MATLAB\Sensors and Control\Data2_Soft_pullback_1\Images';       %  folder in which your images exists
ds = imageDatastore(location)

while hasdata(ds)
    
    A = read(ds);

    imgGss = convertRGBtoGrayscale_student(A);

    kern = [0, -1, 0; -1, 5, -1; 0 -1 0];                                       % sharpen kernal from slide 5.cameras:convolution

    imgresultfinal = ConvolutionKernal(imgGss,kern);

    imshow(imgresult)


end
