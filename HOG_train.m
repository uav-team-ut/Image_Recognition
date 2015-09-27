function [net] = HOG_train(nbins)
%HOG_TRAIN Summary of this function goes here
%   Detailed explanation goes here

nshapes = 3+1; % + 1 for training negative images
files = dir('images/train/tringles/*.jpg')';
nnmat = zeros(nbins,nshapes*length(files));
T = zeros(nshapes*length(files)+1,nshapes)';
count = 1;
for file = files
%     file.name
    img = rgb2gray(imread(['images/train/tringles/' file.name]));
    [hog1, ~] = extractHOGFeatures(img);
    [histFreq, ~] = hist(hog1, nbins);
    histFreq = histFreq/sum(histFreq);
    nnmat(:,count) = histFreq';
    
    target = -1*ones(1,nshapes);
    target(1,1) = 1;
    T(:,count) = target;
    
    count = count + 1;
end

files = dir('images/train/Ricktangles/*.jpg')';
for file = files
    img = rgb2gray(imread(['images/train/Ricktangles/' file.name]));
    [hog1, ~] = extractHOGFeatures(img);
    [histFreq, ~] = hist(hog1,nbins);
    histFreq = histFreq/sum(histFreq);
    nnmat(:,count) = histFreq';
    
    target = -1*ones(1,nshapes);
    target(1,2) = 1;
    T(:,count) = target';
    
    count = count + 1;
end

files = dir('images/train/Circles/*.jpg')';
for file = files
    img = rgb2gray(imread(['images/train/Circles/' file.name]));
    [hog1, ~] = extractHOGFeatures(img);
    [histFreq, ~] = hist(hog1,nbins);
    histFreq = histFreq/sum(histFreq);
    nnmat(:,count) = histFreq';
    
    target = -1*ones(1,nshapes);
    target(1,3) = 1;
    T(:,count) = target';
    
    count = count + 1;
end

% train negative case
files = dir('negative/*.png')';
for file = files
    img = rgb2gray(imread(['negative/' file.name]));
    [hog1, ~] = extractHOGFeatures(img);
    [histFreq, ~] = hist(hog1,nbins);
    histFreq = histFreq/sum(histFreq);
    nnmat(:,count) = histFreq';
    
    target = -2*ones(1,nshapes);
    target(1,4) = 1;
    T(:,count) = target';
    
    count = count + 1;
end

nhid = 100; % number of hidden nuerons
net = feedforwardnet(nhid);
net=init(net);
net.trainparam.epochs=250;
net.trainparam.goal=0.001;
net=train(net,nnmat,T);
