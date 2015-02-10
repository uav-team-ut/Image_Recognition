img = imread('test_images\IMG_2376.jpg');
threshold = 1000;

img = resizeImage(img, threshold);
boxes = cropByMSER(img, threshold);
boxes
figure; imshow(img);
for i=1:size(boxes)
    figure; imshow(imcrop(img, boxes(i,:)));
end