
% This is where the classification actually happens

function [ string , xcenter, ycenter] = discriminate( corners, x, y, index, traversal, xdim )

xcenter = 0;
ycenter = 0;

fitScale = 20;
shitScale = 35;

[realsize,~] = size(corners);

string = 'Unknown' ;

if realsize == 0
    return
end

xEdges = x(index(index ~= 0));
yEdges = y(index(index ~= 0));

%% FINDING LENGTHS OF SIDES, SETTING LENGTH VARIANCE, AND DETERMINING FLATNESS

length = zeros([realsize 1]);

for b = 1:realsize
    deltax = x(corners(b,2)) - x(corners(b,1)) ;
    deltay = y(corners(b,2)) - y(corners(b,1)) ;
    length(b) = sqrt( deltax^2  + deltay^2 ) ;
end

lowSideVariance = 0;
highSideVariance = 0;
tiny = 0;

if max(length)/min(length) < 1.75
    lowSideVariance = 1;
end

if max(length)/min(length) > 3.5
    highSideVariance = 1;
end

if min(length) < 50
    tiny = 1;
end

if realsize == 3
    deltax = x(corners(b,2)) - x(corners(b,1)) ;
    deltay = y(corners(b,2)) - y(corners(b,1)) ;
    length(b) = sqrt(  deltax^2  + deltay^2 ) ;
end


flat = 0;
almostFlat = 0;

for q = 1:realsize
    deltax = x(corners(q,2)) - x(corners(q,1)) ;
    deltay = y(corners(q,2)) - y(corners(q,1)) ;
    if (abs(deltax) <= 5 || abs(deltay) <= 5) && length(q) > 50
        flat = 1;
    end
    if (abs(deltax) <= 30 || abs(deltay) <= 30) && length(q) > 50
        almostFlat = 1;
    end
end

disconnected = 0;
if realsize >= 2 && x(corners(2,1)) - x(corners(1,2)) > 50
    disconnected = 1;
end



if flat
    string = '5/7';
    return;
end


% Checking if mid-points of sides are not alone
longestPerfFit = 0;
longPerfFit = 0;
perfectFit = 0;
goodFit = 0;

for a = 1:realsize
    neighborFit = zeros([3 1]);
    for p = 1:3
        xmid = ( ( x(corners(a,2)) ) - x(corners(a,1)) ) * p/4;
        ymid = ( ( y(corners(a,2)) ) - y(corners(a,1)) ) * p/4;
        
        xmid = x(corners(a,1)) + xmid;
        ymid = y(corners(a,1)) + ymid;
        
        neighborFit(p) = notAlone( xmid , ymid , xEdges, yEdges, fitScale );
    end
    if sum(neighborFit) == 3 && length(a) > 70
        perfectFit = perfectFit + 1;
        if length(a) == max(length)
            longestPerfFit = 1;
        end
        if length(a) >= 125
            longPerfFit = longPerfFit + 1;
        end
    end
    
    for q = 1:3
        xmid = ( ( x(corners(a,2)) ) - x(corners(a,1)) ) * q/4;
        ymid = ( ( y(corners(a,2)) ) - y(corners(a,1)) ) * q/4;
        
        xmid = x(corners(a,1)) + xmid;
        ymid = y(corners(a,1)) + ymid;
        
        neighborFit(q) = notAlone( xmid , ymid , xEdges, yEdges, shitScale );
    end
    
    if (sum(neighborFit) == 2 && neighborFit(2)) || (sum(neighborFit) == 3 && length(a) <= 70)
        goodFit = goodFit + 1;
    end
end

if realsize == 2 && notAlone( xdim/2 , 150, x, y, fitScale ) && ((notAlone( (3/4)*xdim , 75, x, y, fitScale ) && notAlone( (1/4)*xdim, 225, x, y, fitScale )) || (notAlone( (1/4)*xdim , 75 , x, y, fitScale ) && notAlone( (3/4)*xdim , 225 , x, y, fitScale ))) && length(1) > 300
    if y(corners(1,2)) - y(corners(1,1)) < 0;
        string = 'Lee';
        return
    else string = 'Riven';
        return
    end
    
elseif (realsize == 2 && lowSideVariance) || (almostFlat && realsize <= 2) || (disconnected && realsize == 3)
    string = 'KAMEHAMEHA';      %Might be a two-sided/three-sided star or a vertically flat shape
    return
    
elseif realsize <= 2
    return
end


%% END POINT CONDITIONS & SLOPE COMPARING
% Start and End connections & Finding Perpendicular and Parallel Lines

sideSlopes = zeros([realsize 1]);

perp = 0;
almostPerp = 0;
par = 0;
almostPar = 0;

for g = 1:realsize
    deltax = x(corners(g,2)) - x(corners(g,1));
    deltay = y(corners(g,1)) - y(corners(g,2));
    sideSlopes(g) = (deltay/deltax);
end

startGreetings = 0;
endGreetings = 0;
endHugs = 0;

% Checking that start and end points are close

if realsize == 3
    % If 2-1 Traversal
    if traversal == 2
        deltax = x(corners(3,2)) - x(corners(2,2)) ;
        deltay = y(corners(3,2)) - y(corners(2,2)) ;
        distance = sqrt(deltax^2 + deltay^2) ;
        
        if  distance < 100
            endGreetings = 1;
        end
        
        if  distance < 50
            endHugs = 1;
        end
               
        
        deltax = x(corners(1,1)) - x(corners(3,1)) ;
        deltay = y(corners(1,1)) - y(corners(3,1)) ;
        distance = sqrt(deltax^2 + deltay^2) ;
        
        if distance < 100
            startGreetings = 1;
        end
        
        % If 1-2 Traversal
    else
        deltax = x(corners(3,2)) - x(corners(1,2)) ;
        deltay = y(corners(3,2)) - y(corners(1,2)) ;
        distance = sqrt(deltax^2 + deltay^2) ;
        
        if  distance < 75
            endGreetings = 1;
        end
        
        if  distance < 50
            endHugs = 1;
        end
        
        deltax = x(corners(1,1)) - x(corners(2,1)) ;
        deltay = y(corners(1,1)) - y(corners(2,1)) ;
        distance = sqrt(deltax^2 + deltay^2) ;
        
        if distance < 75
            startGreetings = 1;
        end
        
    end
    
end



% 1-2 Traversal
if traversal == 1
    
    if abs(sideSlopes(1) - sideSlopes(3)) < max(abs(sideSlopes(1)),abs(sideSlopes(3)))*.420 %Blaze it
        par = par + 1;
    elseif abs(sideSlopes(1) - sideSlopes(3)) < max(abs(sideSlopes(1)),abs(sideSlopes(3)))*.60
        almostPar = almostPar + 1;
    end
    
    if abs(-1/sideSlopes(1) - sideSlopes(2)) < max(abs(-1/sideSlopes(1)),abs(sideSlopes(2)))*.420
        perp = perp + 1;
    elseif abs(-1/sideSlopes(1) - sideSlopes(2)) < max(abs(-1/sideSlopes(1)),abs(sideSlopes(2)))*.60
        almostPerp = almostPerp + 1;
    end
    
    if abs(-1/sideSlopes(2) - sideSlopes(3)) < max(abs(-1/sideSlopes(2)),abs(sideSlopes(3)))*.420
        perp = perp + 1;
    elseif abs(-1/sideSlopes(2) - sideSlopes(3)) < max(abs(-1/sideSlopes(2)),abs(sideSlopes(3)))*.60
        almostPerp = almostPerp + 1;
    end
    
    if par + almostPar == 1 && perp + almostPerp >= 1
        perp = 2;                        % If perp to one, perp to the other
    end
    
    if endGreetings && perp == 0
        if abs(-1/sideSlopes(1) - sideSlopes(3)) < max(abs(-1/sideSlopes(1)),abs(sideSlopes(3)))*.420
            perp = perp + 1;
        elseif abs(-1/sideSlopes(1) - sideSlopes(3)) < max(abs(-1/sideSlopes(1)),abs(sideSlopes(3)))*.60
            almostPerp = almostPerp + 1;
        end
    end
    
    % 2-1 Traversal
elseif traversal == 2 && realsize == 3
    
    if abs(sideSlopes(2) - sideSlopes(3)) < max(abs(sideSlopes(2)),abs(sideSlopes(3)))*.420
        par = par + 1;
    elseif abs(sideSlopes(2) - sideSlopes(3)) < max(abs(sideSlopes(2)),abs(sideSlopes(3)))*.60
        almostPar = almostPar + 1;
    end
    
    if abs(-1/sideSlopes(1) - sideSlopes(2)) < max(abs(-1/sideSlopes(1)),abs(sideSlopes(2)))*.420
        perp = perp + 1;
    elseif abs(-1/sideSlopes(1) - sideSlopes(2)) < max(abs(-1/sideSlopes(1)),abs(sideSlopes(2)))*.60
        almostPerp = almostPerp + 1;
    end
    
    if abs(-1/sideSlopes(2) - sideSlopes(3)) < max(abs(-1/sideSlopes(2)),abs(sideSlopes(3)))*.420
        perp = perp + 1;
    elseif abs(-1/sideSlopes(2) - sideSlopes(3)) < max(abs(-1/sideSlopes(2)),abs(sideSlopes(3)))*.60
        almostPerp = almostPerp + 1;
    end
    
    if par + almostPar == 1 && perp + almostPerp >= 1
        perp = 2;                        % If perp to one, perp to the other
    end
    
    if endGreetings && perp == 0
        if abs(-1/sideSlopes(1) - sideSlopes(3)) < max(abs(-1/sideSlopes(1)),abs(sideSlopes(3)))*.420
            perp = perp + 1;
        elseif abs(-1/sideSlopes(1) - sideSlopes(3)) < max(abs(-1/sideSlopes(1)),abs(sideSlopes(3)))*.60
            almostPerp = almostPerp + 1;
        end
    end
    
else
    
    quartPerp = 0;
    %4 sided shapes
    
    if abs(sideSlopes(1) - sideSlopes(4)) < max(abs(sideSlopes(1)),abs(sideSlopes(4)))*.420
        par = par + 1;
    elseif abs(sideSlopes(1) - sideSlopes(4)) < max(abs(sideSlopes(1)),abs(sideSlopes(4)))*.60
        almostPar = almostPar + 1;
    end
    
    if abs(sideSlopes(2) - sideSlopes(3)) < max(abs(sideSlopes(2)),abs(sideSlopes(3)))*.420
        par = par + 1;
    elseif abs(sideSlopes(2) - sideSlopes(3)) < max(abs(sideSlopes(2)),abs(sideSlopes(3)))*.60
        almostPar = almostPar + 1;
    end
    
    if abs(-1/sideSlopes(1) - sideSlopes(2)) < max(abs(-1/sideSlopes(1)),abs(sideSlopes(2)))*.420
        perp = perp + 1;
        if length(1) > 150 && length(2) > 150 && abs(length(1) - length(2)) < 50
            quartPerp = 1;
        end
    end
    
    if abs(-1/sideSlopes(2) - sideSlopes(4)) < max(abs(-1/sideSlopes(2)),abs(sideSlopes(4)))*.420
        perp = perp + 1;
        if length(2) > 150 && length(4) > 150 && abs(length(2) - length(4)) < 50
            quartPerp = 1;
        end
    end
    
    if abs(-1/sideSlopes(4) - sideSlopes(3)) < max(abs(-1/sideSlopes(4)),abs(sideSlopes(3)))*.420
        perp = perp + 1;
        if length(4) > 150 && length(3) > 150 && abs(length(4) - length(3)) < 50
            quartPerp = 1;
        end
    end
    
    if abs(-1/sideSlopes(3) - sideSlopes(1)) < max(abs(-1/sideSlopes(3)),abs(sideSlopes(1)))*.420
        perp = perp + 1;
        if length(3) > 150 && length(1) > 150 && abs(length(3) - length(1)) < 50
            quartPerp = 1;
        end
    end
    
    if par == 2
        perp = 4;       % ****ALL RHOMBUSES AND PARALLELOGRAMS WILL BE CAUGHT AS SQUARES/RECTANGLES****
    elseif perp == 4
        par = 2;
    end
end


%% FINDING CENTERS

[numNeigh,~] = size(xEdges);


for e = 1:numNeigh
    xcenter = xcenter + x(index(e));
    ycenter = ycenter + y(index(e));
end

xcenter = xcenter/numNeigh;
ycenter = ycenter/numNeigh;

[numTotal, ~] = size(x);


t_xcenter = 0;
t_ycenter = 0;
for f = 1:numTotal
    t_xcenter = t_xcenter + x(f);
    t_ycenter = t_ycenter + y(f);
end

t_xcenter = t_xcenter/numTotal;
t_ycenter = t_ycenter/numTotal;

centersAllign = 0;
deltax = xcenter - t_xcenter;
deltay = ycenter - t_ycenter;
distance = sqrt(  deltax^2  + deltay^2 ) ;

if distance < mean(length)/4
    centersAllign = 1;
end

centerSpaced = 0;

if ~notAlone( xcenter , ycenter , xEdges, yEdges, 50 )
    centerSpaced = 1;
end

centerSpacedforApproxs = 1;

for r = 1:realsize
    xmid = ( ( x(corners(r,2)) ) + x(corners(r,1)) )/2 ;
    ymid = ( ( y(corners(r,2)) ) + y(corners(r,1)) )/2 ;
   
    deltax = xmid - xcenter;
    deltay = ymid - ycenter;
    if sqrt(deltax^2 + deltay^2) < 50
        centerSpacedforApproxs = 0;
    end
end

%% THREE-SIDED SHAPES

if realsize == 3 && startGreetings
    
    if corners(1,2) == corners(2,2)     %Catches weird acute-angeled shapes
        string = 'KAMEHAMEHA';
        return
    end
    
    if perfectFit + goodFit == 1 && par == 1 && perp == 2
        string = '5/7';                                    %Catches weird Stars
        return;
    end
        
    if perfectFit == 1 && longPerfFit == 1 && centersAllign && ~highSideVariance && endGreetings && centerSpacedforApproxs   %Catches acute 3-sided Semicircles
        string = 'Semicircle';
        return
    end
    
    
    % Lasted this far? Give yourself a treat: https://www.youtube.com/watch?v=uEiDBFu8FIw
    
    
    if perfectFit + goodFit == 2 && perp <= 2           % Catches Trapezoids, Quarter Circles and Stars
        
        small1 = 0;
        small2 = 0;
        [~,trapSide] = max(length);
        for pp = 1:3
            if pp == trapSide
                continue
            end
            if small1 == 0
                small1 = length(pp);
            else
                small2 = length(pp);
            end
        end
        % 2-1 Traversal
        if traversal == 2
            xmid = ( x(corners(trapSide,1)) + x(corners(trapSide,2)) )/2 ;          % Checking if mid-point of long side is close to true center
            ymid = ( y(corners(trapSide,1)) + y(corners(trapSide,2)) )/2 ;
            deltax = xmid - t_xcenter ;
            deltay = ymid - t_ycenter ;
            if sqrt(deltax^2 + deltay^2) < mean(length)/3 && ~notAlone( xcenter , ycenter , xEdges, yEdges, fitScale ) && highSideVariance == 0  && endGreetings
                string = 'Trapezoid';
                if perp + almostPerp == 1 && lowSideVariance && abs(small1 - small2) < min(length)/3.5
                    string = 'Quarter Circle';
                end
                return;
            end
            xmid = ( x(corners(2,2)) + x(corners(3,2)) )/2 ;
            ymid = ( y(corners(2,2)) + y(corners(3,2)) )/2 ;
            deltax = xmid - t_xcenter ;
            deltay = ymid - t_ycenter ;
            if sqrt(deltax^2 + deltay^2) < 75 && notAlone( xcenter , ycenter , xEdges, yEdges, fitScale ) && longPerfFit == 0 && trapSide == 1 && abs(300-xdim) < 100
                string = 'Star';
                return;
            end
            
        else
            
            % 1-2 Traversal
            if traversal == 1
                
                xmid = ( x(corners(trapSide,1)) + x(corners(trapSide,2)) )/2 ;
                ymid = ( y(corners(trapSide,1)) + y(corners(trapSide,2)) )/2 ;
                deltax = xmid - t_xcenter ;
                deltay = ymid - t_ycenter ;
                if sqrt(deltax^2 + deltay^2) < mean(length)/3 && ~notAlone( xcenter , ycenter , xEdges, yEdges, fitScale ) && highSideVariance == 0  && endGreetings
                    string = 'Trapezoid';
                    if perp + almostPerp == 1 && lowSideVariance && abs(small1 - small2) < min(length)/3.5
                        string = 'Quarter Circle';
                    end
                    return;
                end
                xmid = ( x(corners(1,2)) + x(corners(3,2)) )/2 ;
                ymid = ( y(corners(1,2)) + y(corners(3,2)) )/2 ;
                deltax = xmid - t_xcenter ;
                deltay = ymid - t_ycenter ;
                if sqrt(deltax^2 + deltay^2) < 75 && notAlone( xcenter , ycenter , xEdges, yEdges, fitScale ) && longPerfFit == 0 && trapSide == 2 && abs(300-xdim) < 100
                    string = 'Star';
                    return;
                end
            end
        end
    end
    
    if perfectFit + goodFit <= 2       %Only tringles pass
        return
    end
    
    
    
    if perfectFit + goodFit == 3
    
        
        if  endHugs && centersAllign && highSideVariance == 0
            string = 'Tringle';
            return
        end
        
        if  par == 1 && perp == 2 && sum(length) < 300
            string = 'Cross';
            return
        end
        
        
    end
    
    return;
end

if realsize < 4
    return
end

%% FOUR SIDED SHAPES
%Anything beyond this point must be a square, rectangle, circle, trapezoid or unknown

endGreetings = 0;
endHugs = 0;
deltax = x(corners(2,2)) - x(corners(4,2)) ;
deltay = y(corners(2,2)) - y(corners(4,2)) ;
distance = sqrt(  deltax^2  + deltay^2 ) ;

if distance < 75
    endGreetings = 1;
end

if distance < 25
    endHugs = 1;
end

startGreetings = 0;
deltax = x(corners(1,1)) - x(corners(3,1)) ;
deltay = y(corners(1,1)) - y(corners(3,1)) ;
distance = sqrt(  deltax^2  + deltay^2 ) ;

if distance < 75
    startGreetings = 1;
end



if perfectFit + goodFit <= 1 && centersAllign && centerSpaced && endGreetings && startGreetings   %Catches circles
    string = 'Circle';  %***All regular n-sided shapes with n > 4 are likely to be caught here as circles
    return
end


if endGreetings && startGreetings && centersAllign && centerSpacedforApproxs
    
    if perfectFit + goodFit == 4 && par + almostPar == 2 && perp >= 2
        if (( max(length) - min(length)) < .20* mean(length) )
            string = 'Square';
        else
            string = 'Rectangle';
        end
        
    elseif perfectFit == 4 && par == 1 && perp <= 2 && highSideVariance == 0
        string = 'Trapezoid';
    elseif ((perfectFit + goodFit >= 2 && ( longPerfFit == 1 || longestPerfFit == 1 ) && ((perp <= 1 && tiny == 0 && perfectFit <= 3) || (perp <= 2 && tiny == 1  && perfectFit <= 2 )) && centerSpaced) || (perfectFit + goodFit == 3 && longestPerfFit == 1 && par == 1 && perp == 0 && highSideVariance == 0 && centerSpaced)) && quartPerp == 0
        string = 'Semicircle';
    elseif perfectFit >= 2 && perp >= 1 && centerSpaced && longPerfFit >= 2 && quartPerp
        string = 'Quarter Circle';
    end
    
end
