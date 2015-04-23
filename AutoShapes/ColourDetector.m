function ColourDetector(img_in)

	img = imread(img_in);

	[h,s,v] = rgb2hsv(img);
	
	[maxwell, index] = findpeaks(imhist(h));
	
	%[max, index]
	
	x = maxwell == max(maxwell)