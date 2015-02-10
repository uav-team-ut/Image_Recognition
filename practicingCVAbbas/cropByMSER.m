function [ matrix ] = cropByMSER( image, threshold )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

colorImage = image;
% arrSize = size(colorImage);
% threshold = 750;
% if max(arrSize) > threshold
%     rSize = threshold / (max(arrSize));
%     %rSize
%     colorImage = imresize(colorImage, rSize);
% end
%origImage = colorImage;
%bw = rgb2gray(colorImage);
hsv = rgb2hsv(colorImage);
for i=1:3
histImage = hsv(:,:,i);
%histImage2 = histeq(histImage);

mserRegions = detectMSERFeatures(histImage);
mserRegionsPixels = vertcat(cell2mat(mserRegions.PixelList));  % extract regions

mserMask = false(size(histImage));
if (size(mserRegionsPixels) > 0)
    ind = sub2ind(size(mserMask), mserRegionsPixels(:,2), mserRegionsPixels(:,1));
end
mserMask(ind) = true;

se1=strel('disk',25);
se2=strel('disk',7);

afterMorphologyMask = imclose(mserMask,se1);
afterMorphologyMask = imopen(mserMask,se2);

areaThreshold = threshold; % threshold in pixels
connComp = bwconncomp(afterMorphologyMask);
stats = regionprops(connComp,'BoundingBox','Area');
boxes = round(vertcat(stats(vertcat(stats.Area) > areaThreshold).BoundingBox));

matrix = [;boxes];
end
%to print cropped image
%imcrop(origImage, boxes(i,:));


