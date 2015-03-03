figure, imshow(BW), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

% highlight the longest line segment
%plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','blue');

for k=1:length(lines)
    trigger = 0;
    for j=1:length(lines)
        diff = zeros(1,4);
        if lines(k).point1(1) == lines(j).point1(1) && lines(k).point2(1) == lines(j).point2(1)
            if(lines(k).point1(2) == lines(j).point1(2) && lines(k).point2(2) == lines(j).point2(2))
                trigger = 1;
            end 
        end
        
        if(trigger == 0)
            diff(1) = lines(k).point1(1) - lines(j).point1(1);
            diff(2) = lines(k).point1(2) - lines(j).point1(2);
            diff(3) = lines(k).point2(1) - lines(j).point2(1);
            diff(4) = lines(k).point2(2) - lines(j).point2(2);
            avg = abs(mean(diff));

            if(avg<=1.25)
                lines(j).point2(1) = 0;
                lines(j).point2(2) = 0;
                lines(j).point1(1) = 0;
                lines(j).point1(2) = 0;
            end
            end
    end
    
end

figure, imshow(BW), hold on
for k = 1:length(lines)
   xyz = [lines(k).point1; lines(k).point2];
   plot(xyz(:,1),xyz(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xyz(1,1),xyz(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xyz(2,1),xyz(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
  
end

%corner count
corners = 0;
for k = 1:length(lines)
    for j = 1:length(lines)
        if(mean(lines(k).point1) ~= 0)
            norm1 = norm(lines(k).point1-lines(j).point1)
            norm2 = norm(lines(k).point2-lines(j).point2)
            norm3 = norm([norm1,norm2])
            if (norm3 < 10)
                corners =corners+1;
            end
           
        end
    end
    
end 

fprintf('There are %d corners\n',ceil(corners));

switch corners
    case {0}
        fprintf('\nCircle\n');
    case {1,2,3}
        fprintf('\nTriangle\n');
    case {4,5}
        fprintf('\nRectangle\n');
    case {6,7}
        fprintf('\nHexagon\n');
end
        






