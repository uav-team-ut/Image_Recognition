img = imread('test_images\2014-10-26.jpg');
figure; imshow(img);

img = rgb2hsv(img);
hue = img(:,:,1);
hist = imhist(hue);
histImage = histeq(hue, hist);
figure; imshow(histImage);

figure;
edgePts = edge(histImage, 'canny');