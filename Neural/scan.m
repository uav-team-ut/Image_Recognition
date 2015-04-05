function [img,hist,files,net] = scan(img,shape)
% scan function for shape detection usiclcng neural networks
directory = strcat('images/',shape,'/*.jpg');
directory2 = strcat('images/',shape,'/');
files = dir(directory);
hist = [];
for n = 1 : length(files)
    filename = files(n).name;
    file = imread([directory2 filename]);
    hist = [hist, imhist(rgb2gray(file))]; 
end

som = selforgmap([10 10]);
som = train(som, hist);
t   = som(hist); %extract class data
 
net = lvqnet(10);
net = train(net, hist, t);
 
%like(img, hist, files, net)
end
