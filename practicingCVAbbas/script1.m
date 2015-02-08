colorImage = imread('test_images\IMG_2376.jpg');
arrSize = size(colorImage);
threshold = 750
if max(arrSize) > threshold
    rSize = threshold / max(arrSize);
    rSize
    colorImage = imresize(colorImage, rSize);
end
origImage = colorImage;
figure; imshow(colorImage); title('Image');

gray = rgb2gray(origImage);
histImage2 = histeq(gray);
histImage = adapthisteq(gray);

%histImage = hsv(:,:,1);
%histImage2 = histeq(histImage);

figure;imshow(histImage);title('Adaptive HistEQ');
figure;imshow(histImage2);title('Regular HistEQ');

mserRegions = detectMSERFeatures(histImage2);
mserRegionsPixels = vertcat(cell2mat(mserRegions.PixelList));  % extract regions
figure; imshow(histImage); title('MSER Regions');
hold on;
plot(mserRegions, 'showPixelList', true, 'showEllipses', false);
plot(mserRegions);




