 img_test = imread('images/test/bad3.jpg');
 img = img_test;
 filter = .4;
 RGB2 = imadjust(img, [.1 .1 .1; .6 .6 .6]);

gray = rgb2gray(img);
gray = wiener2(gray,[5 5]);
a_gray = imadjust(gray);
thisImage = edge(a_gray, 'Canny', filter);
% thisImage = imfill(thisImage, 'holes');
% thisImage = ExtractNLargestBlobs(thisImage, 3);
imshow(thisImage);