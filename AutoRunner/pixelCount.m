function counts = pixelCount(pixelList)
z = zeros(length(pixelList));
counts = z(1,:);
for i = 1:length(pixelList)
    temp1 = pixelList(i);
    temp2 = temp1(1,:);
    temp2(1)
    %counts(i) = length(list(1,:));
end
end