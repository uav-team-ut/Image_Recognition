img = imread('test_images/2014-10-26.jpg');
% img = im2double(img);
% hist(reshape(img,[],3),1:max(img(:))); 
% colormap([1 0 0; 0 1 0; 0 0 1]);

img = rgb2hsv(img);
hue = img(:,:,1);
his = imhist(hue);

[peak, ind] = findpeaks(his);
arr = [peak, ind];
arr2 = sortrows(arr);

figure; title('Image');
    imshow(img);
figure; title('Histogram');
    plot(his);
figure; title('Find peaks');
    hold on; plot(arr);
figure; title('Peaks sorted by Row');
    hold on; plot(arr2);