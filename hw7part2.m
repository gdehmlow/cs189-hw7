cd 'CelebrityDatabase';
directory = dir('*.jpg');
imcell = cell(1,numel(directory));
for i = 1:numel(directory)
    imcell{i} = imread(directory(i).name);
end
cd '..'
load('mask.mat');

n = size(imcell,2);
[w, h, d] = size(imcell{1});

% Transform images to grayscale vectors and mask them
mask = mask(:,:,1);
unmasked_pixels = find(mask)';
images = zeros(n, size(unmasked_pixels,2));
for i = 1:n
    image = reshape(rgb2gray(imcell{i})', 1, w*h);
    %full_im = zeros(size(mask));
    im_vector = image(unmasked_pixels);
    size(im_vector);
    %full_im(unmasked_pixels) = im_vector;
    images(i,:) = im_vector;
end

% Since we're doing rgb, just use one channel of the mask as the mask
efs = eigenfaces(images, 10);

%unmasked_pixels = find(mask);

%efs = eigenfaces(imcell);
    
%im_vector = im(unmasked_pixels);
%load('mask.mat');