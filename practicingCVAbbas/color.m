img = imread('test_images\crop3.jpg');
figure; imshow(img);
gray = rgb2gray(img);

hist = imhist(gray);
figure; plot(hist);
pks = findpeaks(hist);
pks
figure; plot(pks);