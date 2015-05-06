%clear; close all; clc
img = imread('images\crop18.jpg');
figure; imshow(img);
[firstColor, secondColor] = getColorByHSV(img);
disp(firstColor);
disp(secondColor);
%disp(firstColor + ' ' + secondColor);