function [ maxIndex ] = getMaxIndex( matrix )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

hist = imhist(matrix);
%figure; plot(hueHist);
[peak, ind] = findpeaks(hist);
array = [peak, ind];
sort = sortrows(array, 1);

maxIndex = sort(end, 2);

end

