function [imgresult] = ConvolutionKernal(input_img, kernal)

imgresult = conv2(input_img, kernal, 'same');
imgresult = uint8(imgresult);
