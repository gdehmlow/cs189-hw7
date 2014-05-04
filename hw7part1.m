load('train_small.mat');

images_ = train{1}.images;
dim = size(images_,1) * size(images_,2);
n = size(images_, 3);
images = normr(double(reshape(images_, n, dim)));
labels = train{1}.labels;

[indices, centroids] = kmeans(images, 20);