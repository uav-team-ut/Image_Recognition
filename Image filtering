original = imread('testimage.jpg');
Q = rgb2gray(original);
figure, imshow(Q,[125 200])
se = strel('disk',12);
% Check out strel function. Used for picture filtering.
NHOOD = getnhood(se)
tophatFiltered = imtophat(Q,NHOOD);
figure, imshow(tophatFiltered)
contrastAdjusted = imadjust(tophatFiltered);
figure, imshow(contrastAdjusted)
BW = contrastAdjusted
BW2 = bwareaopen(BW,500);
figure, imshow(BW2)
