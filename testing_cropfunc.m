img = imread('test_images\IMG_2376.jpg');
threshold = 750;

img = resizeImage(img, threshold);
boxes = cropByMSER(img, threshold);
boxes

for i=1:size(boxes)
    %create cropped image
    crop = imcrop(img, boxes(i,:));
    %show cropped image
    %figure; imshow(crop);
end