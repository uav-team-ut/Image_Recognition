colorImage = imread('test_images\2014-10-26-2.jpg');
origImage = colorImage;
figure; imshow(colorImage); title('Image');

hsv = rgb2hsv(colorImage);
histImage = hsv(:,:,1);
histImage2 = histeq(histImage);

figure;imshow(histImage);
figure;imshow(histImage2);

%filter image by hue w/o equalizer
%colorImage = rgb2hsv(colorImage);
%histImage = colorImage(:,:,1);
%figure; imshow(hue);

%filter image to grayscale
% colorImage = rgb2gray(colorImage);
% histImage = colorImage;
% figure; imshow(histImage);

mserRegions = detectMSERFeatures(histImage);
mserRegionsPixels = vertcat(cell2mat(mserRegions.PixelList));  % extract regions
figure; imshow(histImage); title('MSER Regions');
hold on;
plot(mserRegions, 'showPixelList', true, 'showEllipses', false);
plot(mserRegions);

mserMask = false(size(histImage));
ind = sub2ind(size(mserMask), mserRegionsPixels(:,2), mserRegionsPixels(:,1));
mserMask(ind) = true;

se1=strel('disk',25);
se2=strel('disk',7);

afterMorphologyMask = imclose(mserMask,se1);
afterMorphologyMask = imopen(mserMask,se2);

areaThreshold = 5000; % threshold in pixels
connComp = bwconncomp(afterMorphologyMask);
stats = regionprops(connComp,'BoundingBox','Area');
boxes = round(vertcat(stats(vertcat(stats.Area) > areaThreshold).BoundingBox));
for i=1:size(boxes,1)
    figure;
    imshow(imcrop(origImage, boxes(i,:))); % Display segmented text
    title('Text region')
end