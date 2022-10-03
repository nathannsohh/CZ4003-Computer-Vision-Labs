%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% Contrast Stretching

% a
Pc = imread('mrttrainbland.jpeg');
whos Pc
P = rgb2gray(Pc);
whos P

% b
imshow(P)

% c
min(P(:)), max(P(:))

% d
P2(:,:) = imsubtract(P(:,:), 13);
P2(:,:) = immultiply(P2(:,:), 255 / (204 - 13));
min(P2(:)), max(P2(:))

% e
imshow(P2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Histogram Equalization

% a
imhist(P,10)
imhist(P,256)

% b
P3 = histeq(P,255);
imhist(P3, 10)
imhist(P3, 256)

% c
P3 = histeq(P3, 255);
imhist(P3, 10)
imhist(P3, 256)

imshow(P3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Linear Spatial Filtering

% a
N = 5;
sigma1 = 1;
sigma2 = 2;
ind = -floor(N/2) : floor(N/2);
[X Y] = meshgrid(ind, ind);

% Create Gaussian Mask
h1 = exp(-(X.^2 + Y.^2) / (2*sigma1*sigma1))/(2*pi*sigma1*sigma1);
h2 = exp(-(X.^2 + Y.^2) / (2*sigma2*sigma2))/(2*pi*sigma2*sigma2);
% Normalize so that total area (sum of all weights) is 1
h1 = h1 / sum(h1(:));
h2 = h2 / sum(h2(:));

mesh(h1)
mesh(h2)

% b
Gn = imread('ntu-gn.jpeg');

gn1 = conv2(Gn, h1);
gn2 = conv2(Gn, h2);
imshow(uint8(gn1))
imshow(uint8(gn2))

% c
Sp = imread('ntu-sp.jpeg');
sp1 = conv2(Sp, h1);
sp2 = conv2(Sp, h2);
imshow(uint8(sp1))
imshow(uint8(sp2))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% Median Filtering

g1 = medfilt2(Gn, [3 3]);
g2 = medfilt2(Gn, [5 5]);

imshow(g1)
imshow(g2)

s1 = medfilt2(Sp, [3 3]);
s2 = medfilt2(Sp, [5 5]);

imshow(s1)
imshow(s2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% Suppressing Noise Interference Patterns

% a
I = imread("pckint.jpeg");
imshow(I)

% b
F = fft2(I);
S = abs(F);
imagesc(fftshift(S.^0.1));
colormap('default');

% c
imagesc(S.^0.1)
colormap('default')

% d
x1 = 241; y1 = 9;
x2 = 17; y2 = 249;
F(x1-2:x1+2, y1-2:y1+2) = 0;
F(x2-2:x2+2, y2-2:y2+2) = 0;
S = abs(F);
imagesc(fftshift(S.^0.1));
colormap('default');

% e
result = uint8(ifft2(F));
imshow(result)

% f
I2 = imread("primatecaged.jpeg");
I2 = rgb2gray(I2);
imshow(I2);

F = fft2(I2);
S = abs(F);
imagesc(S.^0.0001);
colormap('default')

x1 = 5; y1 = 247;
x2 = 253; y2 = 11;
x3 = 10; y3 = 236;
x4 = 248; y4 = 22;


F(x1-2:x1+2, y1-2:y1+2) = 0;
F(x2-2:x2+2, y2-2:y2+2) = 0;
F(x3-2:x3+2, y3-2:y3+2) = 0;
F(x4-2:x4+2, y4-2:y4+2) = 0;

S = abs(F);
imagesc(S.^0.1);
colormap('default')

result = uint8(ifft2(F));
imshow(result)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 
% Undoing Perspective Distortion of Planar Surface

% a
P = imread('book.jpeg');
imshow(P)

% b
[X Y] = ginput(4);
[X Y]
% X = [5; 144; 308; 258];
% Y = [159; 28; 48; 216];

% c
Xim = [0; 0; 210; 210];
Yim = [297; 0; 0; 297];
A = [
    [X(1), Y(1), 1, 0, 0, 0, -Xim(1)*X(1), -Xim(1)*Y(1)];
    [0, 0, 0, X(1), Y(1), 1, -Yim(1)*X(1), -Yim(1)*Y(1)];
    [X(2), Y(2), 1, 0, 0, 0, -Xim(2)*X(2), -Xim(2)*Y(2)];
    [0, 0, 0, X(2), Y(2), 1, -Yim(2)*X(2), -Yim(2)*Y(2)];
    [X(3), Y(3), 1, 0, 0, 0, -Xim(3)*X(3), -Xim(3)*Y(3)];
    [0, 0, 0, X(3), Y(3), 1, -Yim(3)*X(3), -Yim(3)*Y(3)];
    [X(4), Y(4), 1, 0, 0, 0, -Xim(4)*X(4), -Xim(4)*Y(4)];
    [0, 0, 0, X(4), Y(4), 1, -Yim(4)*X(4), -Yim(4)*Y(4)];
];

v = [Xim(1); Yim(1); Xim(2); Yim(2); Xim(3); Yim(3); Xim(4); Yim(4)];
u = A \ v;
U = reshape([u;1], 3, 3)';
w = U*[X'; Y'; ones(1,4)];
w = w ./ (ones(3,1) * w(3,:));

% d
T = maketform('projective', U');
P2 = imtransform(P, T, 'XData', [0 210], 'YData', [0 297]);

% e
imshow(P2);

% f
[X Y] = ginput(4);
% X = [146; 150; 177; 174];
% Y = [162; 183; 177; 155];

Xim = [0; 0; 297; 297];
Yim = [0; 210; 210; 0];
A = [
    [X(1), Y(1), 1, 0, 0, 0, -Xim(1)*X(1), -Xim(1)*Y(1)];
    [0, 0, 0, X(1), Y(1), 1, -Yim(1)*X(1), -Yim(1)*Y(1)];
    [X(2), Y(2), 1, 0, 0, 0, -Xim(2)*X(2), -Xim(2)*Y(2)];
    [0, 0, 0, X(2), Y(2), 1, -Yim(2)*X(2), -Yim(2)*Y(2)];
    [X(3), Y(3), 1, 0, 0, 0, -Xim(3)*X(3), -Xim(3)*Y(3)];
    [0, 0, 0, X(3), Y(3), 1, -Yim(3)*X(3), -Yim(3)*Y(3)];
    [X(4), Y(4), 1, 0, 0, 0, -Xim(4)*X(4), -Xim(4)*Y(4)];
    [0, 0, 0, X(4), Y(4), 1, -Yim(4)*X(4), -Yim(4)*Y(4)];
];

v = [Xim(1); Yim(1); Xim(2); Yim(2); Xim(3); Yim(3); Xim(4); Yim(4)];
u = A \ v;
U = reshape([u;1], 3, 3)';
w = U*[X'; Y'; ones(1,4)];
w = w ./ (ones(3,1) * w(3,:));

T = maketform('projective', U');
P3 = imtransform(P2, T, 'XData', [0 297], 'YData', [0 210]);
imshow(P3);
