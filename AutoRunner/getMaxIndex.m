function [ maxIndex ] = getMaxIndex( matrix, bins )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

hist = imhist(matrix, bins);
figure; plot(hist);

%doesn't work, findpeaks doesn't get peak if it's at 0 or end index
%[peak, ind] = findpeaks(hist);
%array = [peak, ind];
%sort = sortrows(array, 1);
%disp(num2str(sort(end, 2)));
%maxIndex = sort(end, 2);

% maxSize = 0;
% maxIndex = 0;
% for i=1:size(hist)
%     if (hist(i) > maxSize)
%        maxSize = hist(i);
%        maxIndex = i;
%     end
% end
% disp(num2str(maxIndex));

hist2 = 

end

