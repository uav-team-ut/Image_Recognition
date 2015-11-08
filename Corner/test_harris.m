% read in the image
I = imread('../test_images/cir1.jpg');
BW = rgb2gray(I);
G = imgaussfilt(BW,.5);
Ed = imdilate(G,strel('disk',5));
%figure, imshow(BW), hold off;
figure, imshow(Ed), hold on;

% use Harris corner detection to find the corners in the image
C = corner(Ed,'Harris','SensitivityFactor',.1);
numC = length(C(:,1));
plot(C(:,1), C(:,2), 'r*');

% find the centroid of the corners
x_sum = sum(C(:,1));
y_sum = sum(C(:,2));

x_avg = x_sum/length(C(:,1));
y_avg = y_sum/length(C(:,2));

plot(x_avg, y_avg, 'b*');

% find the distances of all the corner points from the centroid
dist = zeros(length(C(:,1)),2);
for i = 1:length(C(:,1))
    dist(i) = sqrt((C(i,1) - x_avg)^2 + (C(i,2) - y_avg)^2);
end
dist_third = sum(dist)/length(dist) - sum(dist)/(6*length(dist));

% visualize avg distance as a circle with radius dist_third
for i=0:.01:2*pi
    xp=dist_third*cos(i);
    yp=dist_third*sin(i);
    plot(x_avg + xp, y_avg + yp, 'b.');
end

% classify outer corners as such
outer = [];
for i=1:length(C(:,1))
    if dist(i) > dist_third
        outer = [outer; C(i,1) C(i,2)];
    end
end
if ~isempty(outer)
    for i=1:length(outer(:,1))
        plot(outer(i,1),outer(i,2),'y*');
    end
end

% tell me what you find pls
% note: need to find a way to more accurately classify corners
fprintf('%d corners identified\n%d outer corners\n', length(dist), length(outer));