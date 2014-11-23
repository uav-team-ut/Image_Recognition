img = imread('test_images\2014-10-26.jpg');
figure; imshow(img);
rgbGray = rgb2gray(img);
img = rgb2hsv(img);
img = hsv2rgb(img);
hsvGray = rgb2gray(img);
figure; imshow(img);
figure; imshow(rgbGray);
figure; imshow(hsvGray);
