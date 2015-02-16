colorImage = imread('test_images\IMG_2376.jpg');
arrSize = size(colorImage);
threshold = 750
if max(arrSize) > threshold
    rSize = threshold / max(arrSize);
    colorImage = imresize(colorImage, rSize);
end
origImage = colorImage;
figure; imshow(origImage); title('Image');

gray = rgb2gray(origImage);
hsv = rgb2hsv(origImage);

histImage1 = histeq(gray);
histImage2 = adapthisteq(gray);
histImage3 = histeq(hsv(:,:,1));
histImage4 = adapthisteq(hsv(:,:,1));

%histImage = hsv(:,:,1);
%histImage2 = histeq(histImage);

figure;imshow(histImage1);title('Regular HistEQ of gray');
figure;imshow(histImage2);title('Adaptive HistEQ of gray');
figure;imshow(histImage3);title('Regular HistEQ of hue');
figure;imshow(histImage4);title('Adaptive HistEQ of hue');

%MSER Regions on Regular HistEQ of grayscale
mserRegions = detectMSERFeatures(histImage);
mserRegionsPixels = vertcat(cell2mat(mserRegions.PixelList));  % extract regions
figure; imshow(histImage1); title('MSER Regions on Regular HistEQ of gray');
hold on;
plot(mserRegions, 'showPixelList', true, 'showEllipses', false);
plot(mserRegions);

%MSER Regions on Adaptive HistEQ of grayscale
mserRegions = detectMSERFeatures(histImage2);
mserRegionsPixels = vertcat(cell2mat(mserRegions.PixelList));  % extract regions
figure; imshow(histImage2); title('MSER Regions on Adaptive HistEQ of gray');
hold on;
plot(mserRegions, 'showPixelList', true, 'showEllipses', false);
plot(mserRegions);



mserRegions = detectMSERFeatures(histImage3);
mserRegionsPixels = vertcat(cell2mat(mserRegions.PixelList));  % extract regions
figure; imshow(histImage3); title('MSER Regions on Regular HistEQ of hue');
hold on;
plot(mserRegions, 'showPixelList', true, 'showEllipses', false);
plot(mserRegions);

mserRegions = detectMSERFeatures(histImage4);
mserRegionsPixels = vertcat(cell2mat(mserRegions.PixelList));  % extract regions
figure; imshow(histImage4); title('MSER Regions on Adaptive HistEQ of hue');
hold on;
plot(mserRegions, 'showPixelList', true, 'showEllipses', false);
plot(mserRegions);




