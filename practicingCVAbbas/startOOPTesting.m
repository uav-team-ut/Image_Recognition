origImg = imread('test_images/2014-10-26-2.jpg');
%figure; imshow(origImg); title('Original Image');

%make grayscale image
grayImg = rgb2gray(origImg);
%figure; imshow(grayImg); title('Grayscale Image');

%make black and white image
bwImg = im2bw(origImg);
%figure; imshow(bwImg); title('Black and White Image');

%make hsv images
hsvImg = rgb2hsv(origImg);
%figure; imshow(hsvImg); title('HSV Image');
%hsv1
hsv1Img = hsvImg(:,:,1);
%figure; imshow(hsv1Img); title('HSV 1 Image');
%hsv2
hsv2Img = hsvImg(:,:,2);
%figure; imshow(hsv2Img); title('HSV 2 Image');
%hsv3
hsv3Img = hsvImg(:,:,3);
%figure; imshow(hsv3Img); title('HSV 3 Image');

%make histeq images
histImg = histeq(hsv1Img);
figure; imshow(histImg); title('Histogram Equalized');
