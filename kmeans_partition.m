function [ indices ] = kmeans_partition( data, centroids )
% Partition the data by assigning each point to the nearest centroid
% Inputs -
%   data: n x d matrix - n points with dimension d
%   centroids: cell array (size k) of centroids with dimension d
% Outputs -
%   indices: array (size n) containing which cluster 1 < i < k each data
%            point is closest to

k_= size(centroids);
n = size(data,1);
indices = zeros(n,1);
for i = 1:n
    min_k = Inf;
    min_val = Inf;
    for k = 1:k_
        dist = norm(data(i,:) - centroids{k});
        if dist < min_val
            min_val = dist;
            min_k = k;
        end
    end
    indices(i) = min_k;
end

end

