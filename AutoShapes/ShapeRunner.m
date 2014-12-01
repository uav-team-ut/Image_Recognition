images_processed = [];
files = dir('images/*.jpg')';
for file = files,
	
	%TODO
% 	for im = images_processed,
% 		if strcmp(im,file) == 1,
% 			continue;
% 		end
% 	end
	
	img_orig = imread(['images/' file.name]);
	img = Edger(img_orig,'can1');
	ShapeClassifier(img_orig, img);
	
	%images_processed(end+1) = file.name;
end