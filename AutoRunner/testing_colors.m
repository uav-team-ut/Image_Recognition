images_processed = [];
files = dir('images/*.jpg')';
count = 1;
for file = files,
	
	%TODO
% 	for im = images_processed,
% 		if strcmp(im,file) == 1,
% 			continue;
% 		end
% 	end
	
	img = imread(['images/' file.name]);
	figure; imshow(img);
    [firstColor, secondColor] = getColorByHSV(img);
    fprintf('\nFigure %d\n', count);
    count = count + 1;
    disp(firstColor);
    disp(secondColor);
	
	%images_processed(end+1) = file.name;
end