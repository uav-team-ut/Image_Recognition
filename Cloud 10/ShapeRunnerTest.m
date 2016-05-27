images_processed = cell(1,1);
while true,
    
    files = dir('images/*.jpg')';
    
    for i = 1:length(files)
        for im = images_processed
            if strcmp(im,files(i).name) == 1,
                files(i) = [];
            end
        end
    end
    
    for file = files
        img_orig = imread(['images/' file.name]);
        %imshow(img_orig);
        %figure()
        PerfectCell(img_orig)
        images_processed{end+1} = file.name;
    end
end