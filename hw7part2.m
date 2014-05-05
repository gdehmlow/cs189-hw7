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
unmasked_pixels = find(mask);
images = zeros(n, size(unmasked_pixels,1));
for i = 1:n
    %image = reshape(rgb2gray(imcell{i})', 1, w*h);
    image = rgb2gray(imcell{i});
    %full_im = zeros(size(mask));
    im_vector = image(unmasked_pixels);
    size(im_vector);
    %full_im(unmasked_pixels) = im_vector;
    images(i,:) = im_vector;
end

efs = mapminmax(eigenfaces(images, 10), 0, 255);

disp('10 Celebrity Eigenfaces');
full_im = zeros(size(mask));
figure;
for i = 1:10
    full_im(unmasked_pixels) = efs(i,:);
    subplot(2, 5, i), imshow(full_im, []);
    title(num2str(i));
end
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0, 0, 30, 20]);
saveas(gcf, '10celebeigenfaces', 'jpg');

%unmasked_pixels = find(mask);

%efs = eigenfaces(imcell);
    
%im_vector = im(unmasked_pixels);
%load('mask.mat');