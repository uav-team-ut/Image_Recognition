javaaddpath('/users/bhupeshgandhi/documents/matlab/qr_code/core/core.jar');
javaaddpath('/users/bhupeshgandhi/documents/matlab/qr_code/javase/javase.jar');

x = im2double(imread('blurtest3.png'));
y = rgb2gray(x);
imshow(y)
LEN = 15;
THETA = 7;
PSF = fspecial('motion', LEN, THETA);
noise_mean = 0;
noise_var = 0.001;
blurred_noisy = imnoise(y, 'gaussian', noise_mean, noise_var);
estimated_nsr = 0;
wnr2 = deconvwnr(blurred_noisy, PSF, estimated_nsr);
estimated_nsr = noise_var / var(y(:));
wnr3 = deconvwnr(blurred_noisy, PSF, estimated_nsr);
final = wiener2(wnr3,[5 5]);
figure()
imshow(final)
try
message = decode_qr(final);
catch ME
    if strcmp(ME.identifier, 'MATLAB:FileIO:InvalidFid')
        disp('Could not find the specified file.');
        rethrow(ME);
    end
end