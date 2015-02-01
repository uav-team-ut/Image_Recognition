colorImage = imread('test_images\2014-10-26.jpg');
%colorImage = imresize(colorImage, .25);
origImage = colorImage;
figure; imshow(colorImage); title('Image');

hsv = rgb2hsv(colorImage);
for i=1:3
    histImage = hsv(:,:,i);
    histImage2 = histeq(histImage);
    %histImage3 = histeq(rgb2hsv(origImage));

    %figure;imshow(histImage);
    %figure;imshow(histImage2);
    %figure;imshow(histImage3);

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
%     figure; imshow(histImage); title('MSER Regions');
%     hold on;
%     plot(mserRegions, 'showPixelList', true, 'showEllipses', false);
%     plot(mserRegions);

    mserMask = false(size(histImage));
    ind = sub2ind(size(mserMask), mserRegionsPixels(:,2), mserRegionsPixels(:,1));
    mserMask(ind) = true;

    se1=strel('disk',25);
    se2=strel('disk',7);

    afterMorphologyMask = imclose(mserMask,se1);
    afterMorphologyMask = imopen(mserMask,se2);

    areaThreshold = 1000; % threshold in pixels
    connComp = bwconncomp(afterMorphologyMask);
    stats = regionprops(connComp,'BoundingBox','Area');
    boxes = round(vertcat(stats(vertcat(stats.Area) > areaThreshold).BoundingBox));
    for i=1:size(boxes,1)
        figure;
        imshow(imcrop(origImage, boxes(i,:))); % Display segmented text
        title('Text region')
    end
end