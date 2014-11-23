triImg = imread('test_images\2014-10-26_triangle.jpg');
%triImg = rgb2gray(triImg);
triImg = rgb2hsv(triImg);
hue = triImg(:,:,1);
%figure; imshow(triImg);
triImg = rgb2gray(triImg);

%
%figure;
%imshow(triImg);
%title('Image of a Triangle');

sceneImg = imread('test_images\2014-10-26.jpg');
%sceneImg = rgb2gray(sceneImg);
sceneImg = rgb2hsv(sceneImg);
hue = sceneImg(:,:,1);
%figure; imshow(sceneImg);
%sceneImg = hsv2rgb(sceneImg);
%figure; imshow(sceneImg);
sceneImg = rgb2gray(sceneImg);
%figure; imshow(sceneImg);

%
%figure;
%imshow(sceneImg);
%title('Image of Scene');


triPoints = detectSURFFeatures(triImg);
scenePoints = detectSURFFeatures(sceneImg);

featPts = 100;
figure;
imshow(triImg);
title(strcat(num2str(featPts), ' Strongest Feature Points from Triangle Image'));
hold on;
%plot(selectStrongest(triPoints, featPts));

figure;
imshow(sceneImg);
title(strcat(num2str(featPts), ' Strongest Feature Points from Scene Image'));
hold on;
%plot(selectStrongest(scenePoints, featPts));
%plot(scenePoints);

[triFeatures, triPoints] = extractFeatures(triImg, triPoints);
[sceneFeatures, scenePoints] = extractFeatures(sceneImg, scenePoints);

triPairs = matchFeatures(triFeatures, sceneFeatures);

matchedTriPoints = triPoints(triPairs(:, 1), :);
matchedScenePoints = scenePoints(triPairs(:, 2), :);
figure;
showMatchedFeatures(triImg, sceneImg, matchedTriPoints, matchedScenePoints, 'montage');


