function [] = PerfectCell( img, fileName )


% Input: Any RGB image // Can be a direct frame from the camera // CANNOT BE ONLY BW
%      ****Does NOT have to contain a shape****
%      ****Does NOT need cropping of the shape****
%      ****This implementation first determines IF there is a shape, and then classifies it****
%      ****This implementation assumes there is atmost one shape per image****
% Output: Classifies the shape as:
%          Triangle, Circle, Square, Rectangle, Trapezoid(some orientations diableed), Star(disabled), Cross, Semicircle, or Quarter Circle
%          Also attempts to recognize QRC for squares / rectangles
%      Note: Detects Squares, Rectangles, Triangles, and Circles with relatively high
%            accuracy, the rest have decent to poor accuracy, especially
%            with a poor image quality
%
% Known Errors: The general alogorithm is slow (even in the "fast" mode)
%                   Time Range: 1 - ~5 secs (My computer is kinda shitty so might not be as slow)
%                   If the edge detection gods favor you, average time is 2 ~ 3 secs
%               All shapes are assumed to be regular (except Triangles), some non-regular shapes
%                   might have unpredictable outputs
%               Average amount of safegaurds atm, false alarm is still relatively high
%               Some shapes with 0 degree rotation (ie perfectly parallel with the x or y axis) are not properly recognized
%               Large patches of discontinuity lead to unpredictable output (ie. circle.png)
%               There is not a consistent implementation for scale atm due to efficiency,
%                   very small shapes with alot of noise might not be
%                   recognized through blob filtering and resizing
%               Regular n-sided polygons with n >= 5 WILL be falsely
%                   detected as circles, trapezoids, or quarter circles; They do not have an
%                   implementation atm
%               Color thresholds (in HSV) can be further refined (especially for off black)
%               Color detection for the following is almost always wrong: Stars, Crosses
%               Alphanumeric detection is NOT implemented
%
%   -Hari

clc;
%clear;         % Avoid using clear; it forces MATLAB to recompile all functions and slows performance
workspace;
%close all;


%% IMAGE SELECTION

% img_bad = imread('images/test/bad7.jpg');         % tringle in bad4.jpg fails (bump on top side causes problems with neighbor detection)
% img_crop = imread('images/test/crop.jpg');        % crop2.jpg fails (corners are missing due to crop)
% img_test = imread('images/test/test.jpg');
% img_square = imread('images/test/square.jpg');
% img_difficult = imread('images/test/IMG_2376.jpg');
% img_rectangle = imread('images/test/rectangle3.jpg');
% img_barelyRectangle = imread('images/test/barelyRectangle.jpg');
% img_star = imread('images/test/star.jpg');
% img_cross = imread('images/test/cross2.jpg');
% img_trap = imread('images/test/trap6.png');
% img_nothing = imread('images/test/nothing3.jpg');
% img_DBZ = imread('images/test/DBZ.png');
% img_potato = imread('images/test/potato.jpg');
% img_texas = imread('images/test/texas.jpg');
% img_circle = imread('images/test/circle.png');     % circle.png fails (it's poles are missing)
% img_semi = imread('images/test/semi14.jpg');        % semi12 / semi13.jpg fail (it's complicated...)
% img_quart = imread('images/test/quart.jpg');
% img_tringle = imread('images/test/tringle6.jpg');
% img_shear = imread('images/test/shear7.jpg');
% img_impossible = imread('images/test/impossible.jpg');  % Too much god damn noise
% img_qr = imread('images/test/qr2.jpg');
% img_test = imread('images/image-139.jpg');

% ******* Change the img assignment to debug with another image *******

%img = img_test;

% Special Crop to fix ffmpeg capture
img = imcrop(img, [0 10 1920 1072]);

% ******* Select Appropriate Modes *******

mode = 0;       % 0 - Fast/Performance Mode     1 - Debugging Mode (Shows Approximations)

writeEnable = 1;   % 0 - No Write               1 - shape written on disk

% Use 0 for competition =)

%% PRE-IMAGE PROCESSING
% Standard for all images(no initial crop)

filter = .80;                               % <--- Initial canny threshold (filter is decremented by .1 every iteration)
RGB2 = imadjust(img,[.1 .1 .1; .9 .9 .9]);
gray = rgb2gray(RGB2);
a_gray = imadjust(gray);
thisImage = edge(a_gray, 'canny', filter);

% Used to fill small holes/discontinuities
se5 = strel('square', 5);
se3 = strel('square', 3);
%se2 = strel('square', 2);

if mode
    subplot(2,2,3);
    imshow(img);
    title('Initial Image');
    set(gcf, 'Position', get(0,'Screensize'));       % Maximize figure to full screen
end

% GLOBAL INITIALIZATIONS

counter = 0;
repeat = 1;
tryToFlip = 0;
tryToRotate = 0;
tryToShear = 0;
flipped = 0;
rotated = 0;
sheared = 0;
crossConfirm = 0;
nothing = 0;


% GLOBAL ERROR HANDLE; catches all exceptions (including no shape/ no white pixels)

try
    
    %% ITERATIVE NOISE FILTER; loops until a shape is found or filter hits limit
    
    while  repeat && filter >=  .50
        
        % thisImageThick is used to determine the boundary of a blob after dilating to fill holes (not displayed though)
        thisImageThick = imdilate(thisImage,se5);
        
        blobs = regionprops(thisImageThick, 'BoundingBox');
        
        % Caps the filtered image to max 20 blobs
        noiseLVL = 1;
        
        while length(blobs) > 20;
            thisImageThick = bwareaopen(thisImageThick, 200*noiseLVL);
            noiseLVL = noiseLVL + 1;
            blobs = regionprops(thisImageThick, 'BoundingBox');
            counter = counter + 1;
        end
        
        %     blobAreas = regionprops(thisImage, 'area');       %Order the blobs by their area
        %     order = [blobAreas.Area];
        %     [~,idx]=sort(order, 'descend');
        %     blobs=blobs(idx);
        
        if mode
            subplot(2,2,4);
            imshow(thisImage);
            axis on;
            title('After Pre-Processing');
            subplot(2,3,2);
        end
        
        if isempty(blobs)
            nothing = 1;
            error('Empty');
        end
        
        z = 1;
        %% LOOPING THROUGH BLOBS
        while z <= length(blobs)
            % Flips are for acute-angle-oriented shapes
            if tryToFlip == 1 && flipped == 0
                thisBlob = fliplr(thisBlob);
                tryToFlip = 0;
                flipped = 1;
                % Rotations are for flat (or almost flat) shapes
            elseif tryToRotate == 1 && rotated == 0
                thisBlob = imrotate(thisBlob, 3);
                thisBlob = bwmorph(thisBlob, 'thin', Inf);
                tryToRotate = 0;
                rotated = 1;
                if mode
                    cla(subplot(2,3,2));
                end
                % Shears are for some acute-angled tringles
            elseif tryToShear == 1 && sheared == 0
                tform = affine2d([1 0 0; .5 1 0; 0 0 1]);
                if strcmp(shape, 'Riven')
                    tform = invert(tform);
                end
                thisBlob = imwarp(thisBlob, tform);
                tryToShear = 0;
                sheared = 1;
                if mode
                    cla(subplot(2,3,2));
                end
                % Else go to next blob
            else
                boundary = blobs(z).BoundingBox;
                % Crop it out of the original gray scale image.
                thisBlob = imcrop(thisImage, boundary);
                
                numberOfWhite = sum(thisBlob(:));
                
                % If image is too small, skip to next blob
                if numberOfWhite < 50
                    tryToFlip = 0;
                    tryToRotate = 0;
                    tryToShear = 0;
                    flipped = 0;
                    rotated = 0;
                    sheared = 0;
                    crossConfirm = 0;
                    nothing = 0;
                    z = z+1;
                    continue
                end
                
                % STANDARDIZING SCALE/SIZE OF THE BLOB
                
                
                %             thisBlob = imdilate(thisBlob,se2);
                %             thisBlob = imresize(thisBlob, [300 NaN], 'Method', 'bicubic') ;
                %             thisBlob = bwmorph(thisBlob, 'thin', Inf);
                
                thisBlob = bwareaopen(thisBlob, 10);
                thisBlob = imdilate(thisBlob,se3);
                thisBlob = imresize(thisBlob, [300 NaN], 'Method', 'bicubic') ;
                thisBlob = imfill(thisBlob,'holes');
                thisBlob = bwperim(thisBlob, 8);             
                
            end
            
            %DISPLAY BLOB APPROXIMATIONS
            if mode
                cla(subplot(2,3,2));
                imshow(thisBlob);
                hold on; axis tight; axis on;
                title('Blob Approximations');
            end
            
            xyIndex = 1;
            
            % CREATE THE ROW/COL ARRAYS WHERE THE IMAGE IS WHITE (1)
            [yArray, xArray] = find (thisBlob==1);
            
            total = length(yArray);
            
            if total == 0
                tryToFlip = 0;
                tryToRotate = 0;
                tryToShear = 0;
                flipped = 0;
                rotated = 0;
                sheared = 0;
                crossConfirm = 0;
                nothing = 0;
                z = z+1;
                continue
            end
            
            % LOCAL/BLOB INITIALIZATIONS
            
            index = zeros([500 1]);
            cornersArray = [];
            prevEnd = 1;
            i = 1;
            j = 1;
            
            % DETERMINES WHICH DIRECTION OF TRAVERSAL (UP/DOWN) SHOULD BE FIRST
            yolo = 0;
            
            if total >= 50
                goUntil = 50;
            else
                goUntil = total;
            end
            
            for k = 2:goUntil
                yolo = yolo + yArray(k);
            end
            
            if ( yolo/(goUntil-1) < yArray(1) )
                start = 1;                      %GO UP FIRST
                %firstDirection = 'up';
            else
                start = 0;                      %GO DOWN FIRST
                %firstDirection = 'down';
            end
            
            traversal = 0;
            % CHANGING TRAVERSAL
            for a = 1:2
                % CHANGING DIRECTION
                for b = start:start+1
                    keepGoing = 1;
                    % FINDING NEIGHBORS ALONG A DIRECTION
                    while keepGoing
                        
                        [n_xyIndex, keepGoing] = supNeighbor( yArray(), xArray(), xyIndex, b );
                        
                        index(i) = xyIndex;
                        
                        % PATH TO NEIGHBOR (RED)
                        if mode
                            line ([xArray(xyIndex), xArray(n_xyIndex)], [yArray(xyIndex), yArray(n_xyIndex)],'Color','r','LineWidth',2);
                        end
                        xyIndex = n_xyIndex;
                        i= i+1;
                        j= j+1;
                        if j == 3
                            prevEnd = xyIndex;
                        end
                    end
                    
                    % LINEAR SIDE APPROXIMATION (BLUE)
                    if i > 3 && prevEnd > 0
                        deltax = xArray(prevEnd) - xArray(index(i-3));
                        deltay = yArray(prevEnd) - yArray(index(i-3));
                        distance = sqrt(deltax^2 + deltay^2);
                    end
                    
                    if j >= 10 && distance > 25
                        if mode
                            line([xArray(prevEnd), xArray(index(i-3))], [yArray(prevEnd), yArray(index(i-3))],'Color','b','LineWidth',4);
                        end
                        %Ignore this warning(this matrix is at most a 4x2)
                        cornersArray = vertcat(cornersArray,[prevEnd, index(i-3)]);
                        if a == 1
                            traversal = traversal + 1;
                        end
                    end
                    j = 1;
                end
                
                % REVERSING TRAVERSAL DIRECTION (AFTER FIRST ITERATION)
                if start == 1
                    start = 0;
                else
                    start = 1;
                end
                
                prevEnd = 1;
                j = 1;
                
                if index(3) == 0
                    break;
                end
                
                [xyIndex] = mimicShadow( xArray, yArray, xArray(index(3)), yArray(index(3)));
                
                if xyIndex == 0
                    break;
                end
            end
            
            % SHAPE RETRIEVAL
            [~, xdim, ~] = size(thisBlob);
            [shape, xcenter, ycenter] = discriminate( cornersArray, xArray, yArray, index, traversal, xdim );
            
            %% CHECK IF BLOB NEEDS TO BE FLIPPED AND RERUN
            if strcmp(shape, 'KAMEHAMEHA') && flipped == 0
                tryToFlip = 1;
                continue
            elseif strcmp(shape, 'Cross') && crossConfirm == 0
                crossConfirm = 1;
                tryToFlip = 1;
                continue
                % CHECK IF BLOB NEEDS TO BE ROTATED AND RERUN
            elseif strcmp(shape, '5/7')  && rotated == 0
                tryToRotate = 1;
                continue
                % CHECK IF BLOB NEEDS TO BE SHEARED AND RERUN
            elseif (strcmp(shape, 'Lee') || strcmp(shape, 'Riven'))  && sheared == 0
                tryToShear = 1;
                continue
                % CHECK IF IMAGE IS AN ALLOWED SHAPE
            elseif ~strcmp(shape, 'Unknown') && ~strcmp(shape, 'KAMEHAMEHA') && ~strcmp(shape, '5/7') && ~strcmp(shape, 'Lee') && ~strcmp(shape, 'Riven')
                repeat = 0;
                %REINITIALIZE IF SHAPE IS INVALID AND GO TO NEXT BLOB
            else
                tryToFlip = 0;
                tryToRotate = 0;
                tryToShear = 0;
                flipped = 0;
                rotated = 0;
                sheared = 0;
                crossConfirm = 0;
                nothing = 0;
            end
            % IF SHAPE IS DETECTED, LEAVE LOOP
            if repeat == 0
                break
            end
            z = z + 1;
        end
        
        % IF SHAPE IS DETECTED, LEAVE LOOP
        if repeat == 0
            break
        end
        
        % INCREMENT AND PROCESS NOISE FILTER
        if ~tryToFlip && ~tryToRotate && ~tryToShear
            %prevImage = thisImage;
            
            filter = filter - .10;
            thisImage = edge(a_gray, 'canny', filter);
        end
    end
    
catch
    % CATHES EMPTY IMAGES
    if nothing == 1
        shape = 'Empty';
    else
        shape = 'Something went wrong =/';
    end
end

% PLACE CENTER OF ALL NEIGHBORS

if mode
    
    if ~strcmp(shape, 'Empty') && exist('xcenter', 'var')
        scatter (xcenter, ycenter, 'y*');
    end
    
    % IF CIRCLE, DRAW APPROXIMATION
    if strcmp(shape, 'Circle')
        xrad = (xArray(cornersArray(4,2)) - xArray(cornersArray(1,1)))/2 ;
        yrad = abs((yArray(cornersArray(2,1)) - yArray(cornersArray(4,1)))/2);
        r = (xrad + yrad)/2;
        
        xc = (xArray(cornersArray(4,2)) + xArray(cornersArray(1,1)))/2;
        
        yc = (yArray(cornersArray(4,2)) + yArray(cornersArray(1,1)))/2;
        
        theta = linspace(0,2*pi);
        x = r*cos(theta) + xc;
        y = r*sin(theta) + yc;
        plot(x,y, 'g', 'LineStyle','- -')
    end
    
end

%% OUTPUT APPROPRIATE FINAL IMAGE

% Catches almost flat rectangles (that were detected as squares)
if strcmp(shape, 'Square') && abs(boundary(3) - boundary(4)) >= abs(.25*mean(boundary(3), boundary(4)))
    shape = 'Rectangle';
end

if strcmp(shape, 'Unknown') || strcmp(shape, 'KAMEHAMEHA') || strcmp(shape, '5/7') || strcmp(shape, 'Lee') || strcmp(shape, 'Riven') || strcmp(shape, 'Unknown') || (strcmp(shape, 'Cross') && crossConfirm == 0)
    shape = 'Empty';
end

if strcmp(shape, 'Empty')
    croppedOutput = img;
else
    % This crop pads the sides with more of the original image
    %croppedOutput = imcrop(img, boundary + [-5,-5,10,10]);
    %croppedOutput = imcrop(img, boundary + [-2,-2,4,4]);
    croppedOutput = imcrop(img, boundary);
end

if mode
    subplot(2,3,1);
end

imshow(croppedOutput);

if length(cornersArray) >= 3 && ~strcmp(shape, 'Empty')
    
    if length(cornersArray) == 3
        r = [xArray(cornersArray(1,1)) xArray(cornersArray(1,2)) xArray(cornersArray(2,2))];
        c = [yArray(cornersArray(1,1)) yArray(cornersArray(1,2)) yArray(cornersArray(2,2))];
    else
        r = [xArray(cornersArray(1,1)) xArray(cornersArray(1,2)) xArray(cornersArray(2,2)) xArray(cornersArray(3,2))];
        c = [yArray(cornersArray(1,1)) yArray(cornersArray(1,2)) yArray(cornersArray(2,2)) yArray(cornersArray(3,2))];
    end
    
    [height, width, ~] = size(croppedOutput);
    masked = roipoly(thisBlob,r,c);
    r_masked = imresize(masked,[height width], 'Method', 'bicubic');
    maskedOutput = bsxfun(@times, croppedOutput, cast(r_masked, 'like', croppedOutput));
    
    [color1,color2] = getColorByHSV(maskedOutput);
    
    if strcmp(color1, color2)
        title(horzcat([shape, ' (', color1, ')']));
    else
        title(horzcat([shape, ' (', color1 , ' or ' color2 ')']));
    end
    
    if mode
        subplot(2,3,3);
        imshow(maskedOutput);
        title('Colored Foreground (Masked)');
        axis on;
    end
    
else
    title(shape);
end

if strcmp(shape,'Square') || strcmp(shape,'Rectangle')
    imwrite(imresize(croppedOutput, 5), 'qr_output.jpg');
    message = read_qr(imread('qr_output.jpg'));
    if ~strcmp(message, 'error')
        if mode
            subplot(2,3,1);
            imshow(croppedOutput)
        end
        title('QR Code Found!')
        xlabel(message, 'FontSize', 15);
    end
end



% Flush display buffer
drawnow('update');

if writeEnable && ~strcmp(shape, 'Empty')
    saveas(gcf, strcat('images_results/',fileName))
end

why
