files = dir('images/*.jpg');
for file = files',
	img_orig = imread(['images/' file.name]);
	img = Edger(img_orig,'sob1');
	ShapeClassifier(img_orig, img);
end