images_processed = [];
files = dir('images/*.jpg')';
img_number = 0;
for file = files,
	img_number = img_number + 1;
	%TODO
% 	for im = images_processed,
% 		if strcmp(im,file) == 1,
% 			continue;
% 		end
% 	end
	
	img_orig = imread(['images/' file.name]);
	img = Edger(img_orig,'can1');
	ShapeClassifier(img_orig, img, img_number);
	
	%images_processed(end+1) = file.name;
end