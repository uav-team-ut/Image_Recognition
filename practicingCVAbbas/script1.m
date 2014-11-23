%I = imread('test_images\FindingContours.png');
I = imread('test_images\2014-10-26.jpg');

figure;
imshow(I);

figure;
%I2 = rgb2gray(I);
I2 = im2uint8(I);
imshow(I2);

%E = edge(I2, 'canny',.1);
%figure;
%imshow(E);




