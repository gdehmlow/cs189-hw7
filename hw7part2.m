cd 'CelebrityDatabase';
directory = dir('*.jpg');
imcell = cell(1,numel(directory));
for i = 1:numel(directory)
    imcell{i} = imread(directory(i).name);
end
cd '..'
unmasked_pixels = find(mask);
%im_vector = im(unmasked_pixels);
%load('mask.mat');