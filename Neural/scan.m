function [img,hist,files,net] = scan(img)
% scan function for shape detection using neural networks
files = dir('images/circle/*.jpg');
hist = [];
for n = 1 : length(files)
    filename = files(n).name;
    file = imread(['images/' filename]);
    hist = [hist, imhist(rgb2gray(file))]; 
end

som = selforgmap([10 10]);
som = train(som, hist);
t   = som(hist); %extract class data
 
net = lvqnet(10);
net = train(net, hist, t);
 
%%like(img, hist, files, net)
end
