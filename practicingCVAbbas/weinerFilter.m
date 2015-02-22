img = imread('test_images\test.png');
%class(img) %shows type of img

figure;imshow(img);

 LEN = 5;
 THETA = 10;
 PSF = fspecial('motion', LEN, THETA);
% 
 uniform_var = (1/256)^2 / 12;
 signal_var = var(im2double(img(:)));
% 
 filtered = deconvwnr(img, PSF, uniform_var/signal_var);
% figure;imshow(img);
 figure;imshow(filtered);

%j = adapthisteq(rgb2gray(img));
%figure;imshow(j);

k = imadjust(img,[0.3 0.7],[]);
%figure;imshow(k);

hue = rgb2hsv(k); 
hue = hue(:,:,2);
%figure; imshow(hue);


