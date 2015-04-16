cellcolors = ['green '; 'black '; 'blue  '; 'orange'; 'purple'; 'red   '; 'yellow'];
colors = cellstr(cellcolors);
cellshapes = ['circle  '; 'triangle'];
shapes = cellstr(cellshapes);

file = '';
directory = '';
histo = [];
for i=1:size(shapes)
    for j=1:size(colors)
        file = strcat(colors{j}, '_', shapes{i});
        %file
        directory = strcat(pwd, '\ShapeDatabase\',file,'.png');
        %directory2 = strcat('images/',shape,'/');
        img = imread(directory);
        disp(file);
        currHist = imhist(rgb2gray(img));
        for k=1:length(currHist)-1
           if currHist(k) > 100
               disp(strcat(num2str(k), ' = ', num2str(currHist(k))));
           end
        end
        %figure; plot(currHist); title(strcat('Hist ', strcat(i * size(shapes) + j)));
        histo = [histo, currHist];
    end
end

