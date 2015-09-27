% HOG_runner.m
close all;clear;clc

readVideo()

images_processed = {};

num_inputs = 100;
[net] = HOG_train(num_inputs);

nproc = 0; % counter for number of images processed

k = waitforbuttonpress;

while 1
    files = dir('images/competition/*.jpg')'; % take in all images in folder   
    for file = files
        if norm(find(strcmp(images_processed,file.name))) > 0 
            continue
        end
        img = imread(['images/competition/' file.name]);
%         figure,imshow(img)
        mser = cropByMSER(img,900);
        n = size(mser,1);
        check = 0;
        for i = 1:n
            color = imcrop(img,mser(i,:));
            cropped = rgb2gray(color);
            result = HOG_sim(cropped,net,num_inputs);
            shape = nn_shape(result);
            if strcmp(shape,'') ~= 1 && check == 0
                r2 = HOG_sim(cropped,net,num_inputs);
                s2 = nn_shape(r2);
                if strcmp(s2,shape) 
                    [c1,c2] = getColorByHSV(color);
                    figure,imshow(img),title(strcat('Shape: ',shape,'; Shape Color: ',c1,'; Alphanumeric Color: ',c2))
                    check = 1;
                end
            end
        end
        nproc = nproc + 1;
        images_processed{nproc} = file.name;
    end
end
% different folders for functions
