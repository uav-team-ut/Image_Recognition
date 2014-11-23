files = dir('images/*.jpg');
for file = files'
	img = Edger(['images/' file.name], 'can1');
	img_orig = imread(['images/' file.name]);
	ShapeClassifier(img_orig, img);
end