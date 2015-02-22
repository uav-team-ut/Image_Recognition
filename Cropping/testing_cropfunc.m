img = imread('test_images\test.png');
minSizeCroppedAreas = 1000;

img = resizeImage(img, minSizeCroppedAreas);
boxes = cropByMSER(img, minSizeCroppedAreas);
boxes

for i=1:size(boxes)
    %create cropped image
    crop = imcrop(img, boxes(i,:));
    %show cropped image
    figure; imshow(crop);
    %imwrite(crop, strcat('crop',num2str(i),'.jpg'));
end