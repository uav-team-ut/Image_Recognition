files = dir('test_images/*.jpg');
for file = files'
	img = Edger(['test_images/' file.name], 'sob1');
	ShapeClassifier(img);
end