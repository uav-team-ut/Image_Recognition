%nn_main.m
clear; close all; clc

num_inputs = 30;
img = imread('d.jpg');
[net,P] = nn_train(num_inputs);
result = nn_test(img,net,num_inputs,P);

[y,index] = max(result);
shape = '';
if y > 0.6
    if index == 1
        shape = 'rectangle';
    elseif index == 2
        shape = 'triangle';
    end
end

disp(shape)
