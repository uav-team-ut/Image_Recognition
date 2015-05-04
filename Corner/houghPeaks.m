%I want to test this on a cropped image later. This currently probably
%doesn't do its job yet.

%Read Image
%Note that the current image is already filtered. 
I  = imread('../test_images/tri1.jpg');
%Read image is converted to 2dim matrix
BW = rgb2gray(I);

%Image is passed through hough transform. Returns hough matrix, theta and
%rho
[H,T,R] = hough(BW);
% Hough peaks are found
P  = houghpeaks(H,50);
%hough image is plotted. Now idea what it means, but it looks cool
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
plot(T(P(:,2)),R(P(:,1)),'s','color','white');

%struct of lines is detected
lines = houghlines(BW,T,R,P);