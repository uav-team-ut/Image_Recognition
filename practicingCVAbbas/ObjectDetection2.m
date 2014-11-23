colorImage = imread('test_images\2014-10-26-2.jpg');
origImage = colorImage;
%figure; imshow(colorImage); title('Image');

colorImage = rgb2hsv(colorImage);
hue = colorImage(:,:,1);
hist = imhist(hue);
histImage = histeq(hue, hist);
%figure; imshow(histImage); title('img 2 hsv');

figure; 
SURFPts = detectSURFFeatures(histImage);
imshow(histImage); title('SURF Features');
hold on;
plot(selectStrongest(SURFPts, 100));
%plot(C(:,1), C(:,2), 'r*');

edgeMask = edge(histImage,'sobel');
edgeMask2 = edge(histImage,'canny');
figure;
imshowpair(edgeMask,edgeMask2,'montage')
title('Sobel Filter                                   Canny Filter');
 


mserRegions = detectMSERFeatures(histImage);
mserRegionsPixels = vertcat(cell2mat(mserRegions.PixelList));  % extract regions
figure; imshow(histImage); title('MSER Regions');
hold on;
plot(mserRegions, 'showPixelList', true, 'showEllipses', false);
plot(mserRegions);



mserMask = false(size(histImage));
ind = sub2ind(size(mserMask), mserRegionsPixels(:,2), mserRegionsPixels(:,1));
mserMask(ind) = true;

surfMask = false(size(histImage));
ind = sub2ind(size(surfMask), SURFPts(:,2), SURFPts(:,1));
surfMask(ind) = true;

surfAndMSERIntersection = SURFPts & mserMask;
figure; imshowpair(edgeMask2, edgeAndMSERIntersection, 'montage');

edgeAndMSERIntersection = edgeMask2 & mserMask;
figure; imshowpair(edgeMask2, edgeAndMSERIntersection, 'montage');
title('Canny edges and intersection of canny edges with MSER regions'); 
% 
% [~, gDir] = imgradient(histImage);
% % You must specify if the text is light on dark background or vice versa
% gradientGrownEdgesMask = helperGrowEdges(edgeAndMSERIntersection, gDir, 'LightTextOnDark');
% figure; imshow(gradientGrownEdgesMask); title('Edges grown along gradient direction');

% Remove gradient grown edge pixels
% edgeEnhancedMSERMask = ~gradientGrownEdgesMask & mserMask;

%Visualize the effect of segmentation
%figure; imshowpair(mserMask, edgeEnhancedMSERMask, 'montage');
%title('Original MSER regions and segmented MSER regions');

se1=strel('disk',25);
se2=strel('disk',7);

afterMorphologyMask = imclose(mserMask,se1);
afterMorphologyMask = imopen(mserMask,se2);

% Display image region corresponding to afterMorphologyMask
%displayImage = histImage;
%displayImage(~repmat(afterMorphologyMask,1,1,3)) = 0;
%figure; imshow(displayImage); title('Image region under mask created by joining individual characters')

areaThreshold = 5000; % threshold in pixels
connComp = bwconncomp(afterMorphologyMask);
stats = regionprops(connComp,'BoundingBox','Area');
boxes = round(vertcat(stats(vertcat(stats.Area) > areaThreshold).BoundingBox));
for i=1:size(boxes,1)
    figure;
    imshow(imcrop(origImage, boxes(i,:))); % Display segmented text
    title('Text region')
end
