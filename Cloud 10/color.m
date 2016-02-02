function [color] = color(h,s,v)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if (h >= 0 && h < 20) || (h >= 330 && h <= 360)
    if s <= 15
        color = 'White2';
    elseif v <= 16
        color = 'Black';
    else
        color = 'Red';
    end
elseif h >= 20 && h < 50
    color = 'Orange';
elseif h >= 50 && h < 70
    color = 'Yellow';
elseif h >= 70 && h < 170
    color = 'Green';
elseif h >= 170 && h < 265
    color = 'Blue';
elseif h >= 265 && h < 330
    color = 'Purple';
else 
    color = 'cannot be determined';
end
end
