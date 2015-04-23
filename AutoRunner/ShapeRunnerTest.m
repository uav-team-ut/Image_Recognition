images_processed = [];
while true,
	
	files = dir('images/*.jpg')';
	
	for i = 1:length(files),
		for im = images_processed,
			if strcmp(im,files(i).name) == 1,
				files(i) = [];
			end
		end
	end

	for file = files,

		img_orig = imread(['images/' file.name]);
		img = Edger(img_orig,'can1');
		ShapeClassifier(img_orig, img);

		images_processed(end+1) = file.name;
	end
end