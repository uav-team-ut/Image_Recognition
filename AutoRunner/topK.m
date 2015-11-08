function top = topK(nums, k)
top = zeros(k,2);
temp = nums;
for i = 1:k
    [M,I] = max(temp);
    top(i,1) = I;
    top(i,2) = M;
    temp(I) = 0;
end
end