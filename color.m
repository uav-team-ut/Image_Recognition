function [color] = color(h,s,v)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if (h >= 0 && h <= 19) || (h >= 330 && h <= 360)
    if s >= 0 && s <= 30
        color = 'white';
    elseif v >= 0 && v <= 32
        color = 'black';
    else
        color = 'red';
    end
elseif h >= 20 && h <= 49
    color = 'orange';
elseif h >= 50 && h <= 69
    color = 'yellow';
elseif h >= 70 && h <= 170
    color = 'green';
elseif h >= 171 && h <= 264
    color = 'blue';
elseif h >= 265 && h <= 329
    color = 'purple';
else 
    color = 'cannot be determined'
end
end
