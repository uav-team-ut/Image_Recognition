% Determines the new point to traverse through

function [ n_index ] = mimicShadow( yArray, xArray, avoidy, avoidx )

try
    
    if xArray(1) < avoidx
        selection = 1;        % FIND SHADOW UP
    end
    
    if xArray(1) >= avoidx
        selection = 0;        % FIND SHADOW DOWN
    end
    
    x2index = 5;
    y2index = 5;
    
    x2 = xArray( x2index );
    y2 = yArray( y2index );
    
    deltax = x2-avoidx;
    deltay = y2-avoidy;
    
    if selection == 0
        while ((x2 < xArray(1)) || sqrt((deltax)^2 + (deltay)^2) <= 20 )
            x2index = x2index + 1;
            y2index = y2index + 1;
            
            x2 = xArray( x2index );
            y2 = yArray( y2index );
            
            deltax = x2-avoidx;
            deltay = y2-avoidy;
        end
        
    else if selection == 1
            while  x2 > xArray(1)  || sqrt(deltax^2 + deltay^2) <= 20
                x2index = x2index + 1;
                y2index = y2index + 1;
                
                x2 = xArray( x2index );
                y2 = yArray( y2index );
                
                deltax = x2-avoidx;
                deltay = y2-avoidy;
            end
        end
    end
    
    if deltax > 150 || deltay > 150
        [n_index] = echoShadow( xArray, yArray, avoidy, avoidx );
    else
        n_index = x2index;
    end
    
catch
    [n_index] = echoShadow( xArray, yArray, avoidy, avoidx );
end

