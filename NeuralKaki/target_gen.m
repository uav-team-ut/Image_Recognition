targets = zeros(8,16);

[x,y] = size(targets);

jstart = 1;
jend = jstart+1;

for i = 1:x,
	for j = jstart:jend,
		targets(i,j) = 1;
	end
	
	jstart = jstart+2;
	jend = jstart+1;
	
end