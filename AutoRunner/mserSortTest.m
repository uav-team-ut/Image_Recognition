img_longhorn = imread('images/123_1.jpeg');
img_bluedot = imread('images/test/copy.png');
img_letters = imread('images/test/test.jpg');
img_bad = imread('images/test/bad.png');

img = img_bad;
bw = rgb2gray(img);
ed = edge(bw, 'canny', .15);
mserRegions = detectMSERFeatures(bw);

figure; imshow(ed); hold off;
figure; imshow(bw); hold on;
plot(mserRegions, 'showPixelList', false, 'showEllipses', false);

numRegions = length(mserRegions.PixelList);
z = zeros(numRegions);
counts = z(1,:);
for i = 1:numRegions
    counts(i) = length(mserRegions.PixelList(i));
end
temp = topK(counts, 5);
topRegions = temp(:,1);

x = [];
y = [];
for i = 1:length(topRegions)
    x(i) = mserRegions.Location(topRegions(i),1);
    y(i) = mserRegions.Location(topRegions(i),2);
end
scatter(x,y,'b*')