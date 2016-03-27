img = imread('tests\test_qr.jpg');

message = read_qr(img);

disp(message)