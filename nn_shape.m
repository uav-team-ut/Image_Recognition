function [shape] = nn_shape(result)
result = result-1;
[y,index] = min(abs(result/sum(abs(result))));
shape = '';
disp(y)
if y < 1
    if index == 4
        shape = '';
    elseif index == 1
        shape = ' Triangle';
    elseif index == 2
        shape = ' Rectangle';
    elseif index == 3
        shape = ' Circle';
    end
end
end

