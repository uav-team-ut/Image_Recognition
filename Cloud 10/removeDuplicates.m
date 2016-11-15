function [lines] = removeDuplicates( lines )
distThresh = 20;
l = length(lines);

a = 1;

while a <= l
    x1start = lines(a).point1(1);
    y1start = lines(a).point1(2);
    
    x1end = lines(a).point2(1);
    y1end = lines(a).point2(2);
    
    b = a + 1;
    
    while b <= l
        x2start = lines(b).point1(1);
        y2start = lines(b).point1(2);

        x2end = lines(b).point2(1);
        y2end = lines(b).point2(2);
        
        % if starts are close
        if ( sqrt( (x2start - x1start)^2 + (y2start - y1start)^2 ) < distThresh )
            % if ends are close
            if ( sqrt( (x2end - x1end)^2 + (y2end - y1end)^2 ) < distThresh )
                lines(b) = [];
                b = b - 1;
                l = l - 1;
            end
        end
        b = b + 1;
    end
    a = a + 1;
end