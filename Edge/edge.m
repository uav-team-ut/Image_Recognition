I = imread('images/crop3.jpg');


thresh = multithresh(I,2);
seg_I = imquantize(I,thresh);
RGB = label2rgb(seg_I);
figure;
imshow(seg_I)

% [level EM] = graythresh(I)
% BW = im2bw(I,level);
% imshow(BW)
