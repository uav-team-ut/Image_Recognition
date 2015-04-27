x = zeros(length(lines),3);

for j = 1:length(lines)
    for k = 1:2
        x(j,k) = lines(j).point1(k) - lines(j).point2(k);
    end
end

triangleCounter = 0;
squareCounter = 0;
pentagonCounter = 0;
hexagonCounter = 0;

for i = 1:length(x)
   for j = 1:length(x)
       if i ~=j
        angle = atan2d(norm(cross(x(i,:),x(j,:))),dot(x(i,:),x(j,:)));
        if angle > 40 && angle < 80
            triangleCounter = triangleCounter +1;
        end
        if angle > 80 && angle < 100
            squareCounter = squareCounter +1;
        end
        if angle > 100 && angle < 110
            pentagonCounter = pentagonCounter +1;
        end
        if angle > 130 && angle < 110
            hexagonCounter = hexagonCounter +1;
        end
       end
   end
end

mattSchaub = [triangleCounter,squareCounter,pentagonCounter,hexagonCounter];
mattStafford = [' Triangle ',' Square ',' Pentagon ',' Hexagon '];
mattRyan = mattSchaub == max(mattSchaub);
mattStafford
mattRyan
