cellcolors = ['green '; 'black '; 'blue  '; 'orange'; 'purple'; 'red   '; 'yellow'];
colors = cellstr(cellcolors);
cellshapes = ['circle  '; 'triangle'];
shapes = cellstr(cellshapes);

% file = '';
% directory = '';
% histo = [];
% for i=1:size(shapes)
%     for j=1:size(colors)
%         file = strcat(colors{j}, '_', shapes{i});
%         %file
%         directory = strcat(pwd, '\ShapeDatabase\',file,'.png');
%         %directory2 = strcat('images/',shape,'/');
%         img = imread(directory);
%         disp(file);
%         currGrayHist = imhist(rgb2gray(img));
%         hsv = rgb2hsv(img);
%         a = hsv(:,:,1);
%         currHueHist = imhist(a);
%         for k=1:length(currGrayHist)-1 
%            if currGrayHist(k) > 100
%                %disp(strcat(num2str(k), ' = ', num2str(currGrayHist(k))));
%            end
%         end
%         [peak,ind] = findpeaks(currHueHist);
%         matrix = [peak, ind];
%         sortmatrix = sort(matrix, 'descend');
%         if (length(sortmatrix) > 1)
%             sortmatrix = flip(sortmatrix);
%             max1 = sortmatrix(1);
%             max2 = sortmatrix(2);
%             fprintf('Sorted %g & %g\n',max1,max2)
%         end        
%         %disp(strcat('Sorted ', max1, ' & ', max2);
%         
%         %disp(strcat('Peaks ', num2str(ind),' = ', num2str(peak)));
%         figure; imshow(img);
%         figure; plot(currGrayHist); title(strcat('Hist  ', strcat(file)));
%         figure; plot(currHueHist); title(strcat('Hue Hist ', strcat(file)));
%         histo = [histo, currGrayHist];
%     end
% end

img1 = imread('AutoShapes\images\crop1.jpg');
hist = imhist(rgb2gray(img1));
[h,s,v] = rgb2hsv(img1);
a = hsv(:,:,1);
currHueHist = imhist(h);
figure; plot(currHueHist);
[peak,ind] = findpeaks(currHueHist);
matrix = [peak, ind];
sortmatrix = sortrows(matrix,1);
if (min(size(sortmatrix > 1)))
    %flip(sortmatrix);
    max1 = sortmatrix(1);
    max2 = sortmatrix(2);
    fprintf('Sorted %g & %g\n',sortmatrix(end,2),sortmatrix(end-1,2));
end   
figure; imshow(img1);
figure; plot(currHueHist);
% 
% minSizeCroppedAreas = 1000;
% 
% img = resizeImage(img1, minSizeCroppedAreas);
% boxes = cropByMSER(img, minSizeCroppedAreas);
% 
% for i=1:size(boxes)
%     %create cropped image
%     crop = imcrop(img, boxes(i,:));
%     hist = imhist(rgb2gray(crop));
%     figure; imshow(crop);
%     figure; plot(hist);
% end

