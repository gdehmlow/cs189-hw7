function [ efs ] = eigenfaces( images, k )
% Construct eigenfaces from a set of input images
% Input -
%   images: n x (w*h) matrix - grayscale images on each row
%   k: number of top eigenfaces to be returned
% Output - 
%   efs: cell array of top k eigenface images


[n, wh] = size(images);

% Calculate the mean image
mean_image = mean(images);

% Center the images around the mean
diffs = zeros(n, wh);
for i = 1:n
    image = images(i,:);
    diffs(i,:) = image - mean_image;
end

% Transpose to get correct format for SVD
diffs = diffs';

% USV' gives us the eigenvectors in U, eigenvalues in V
[U,S,V] = svd(diffs,'econ');

efs = U';

% Calculate the eigenvectors and eigenvalues
%covariance_matrix = diffs' * diffs;
%[eigvals, eigvecs] = eig(covariance_matrix);

%efs = eigvecs(1:k);
%efs = zeros(k, wh);
end

