function [ mainColor ] = getColorByHSV( image )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[h,s,v] = rgb2hsv(image);

%getMaxIndex returns the index of the highest peak in the 2 dimensional
%matrix. To be used with h,s,v from rgb2hsv(img)

%%% what getMaxIndex(h) does
% hueHist = imhist(h);
% %figure; plot(hueHist);
% [huePeak, hueInd] = findpeaks(hueHist);
% hueArray = [huePeak, hueInd];
% sortHue = sortrows(hueArray, 1);

maxHue = getMaxIndex(h, 330);
maxSat = getMaxIndex(s, 100);
maxVal = getMaxIndex(v, 100);

mainColor = color(maxHue, maxSat, maxVal);

end

