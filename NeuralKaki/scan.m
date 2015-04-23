function [hist] = scan()

% scan function for shape detection using neural networks
directory = strcat('new/','*.png');
directory2 = strcat('new/');
files = dir(directory);
hist = [];
for n = 1 : length(files),
	filename = files(n).name;
	file = imread([directory2 filename]);
	h = rgb2hsv(file);
	hist = [hist, imhist(rgb2gray(file))];
end

end