function [ efs, S, mean_face ] = eigenfaces( images )
% Construct eigenfaces from a set of input images
% Input -
%   images: n x (w*h) matrix - grayscale images on each row
% Output - 
%   efs: n x (w*h) matrix - eigenface images

[n, wh] = size(images);

% Calculate the mean image
mean_face = mean(images);

% Center the images around the mean
diffs = zeros(n, wh);
for i = 1:n
    image = images(i,:);
    diffs(i,:) = image - mean_face;
end

% Transpose to get correct format for SVD
diffs = diffs';

% USV' gives us the eigenvectors in U, eigenvalues in V, singular matrix
% in S. S is useful for reconstruction; see Piazza 526
[U,S,V] = svd(diffs,'econ');
efs = U';

end

