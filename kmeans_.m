function [ indices, centroids ] = kmeans_( data, k_, max_iters)
% Runs k means on the data
% Inputs -
%   data: n x d matrix - n data points with dimension d
%   k: number of clusters
% Outputs -
%   indices: array (size n) containing which cluster 1 < i < k each data
%            point belongs to
%   centroids: cell array (size k) containing the centroids, dim d vecs
n = size(data,1);
d = size(data,2);

iters = 0;
best_variance = Inf;

% We'll keep retrying kmeans until at least one point belongs to every
% centroid or we reach the maximum number of iterations
while (iters < max_iters)
    iters = iters + 1;
    
    % Choose k centroids at random from data points
    centroids = cell(k_,1);
    random_indices = randi([1,n],1,k_);
    for k = 1:k_
        centroids{k} = data(random_indices(k),:);
    end

    % Make initial partition of objects into k clusters
    indices = kmeans_partition(data, centroids);
    reassignment_occurred = 1;

    % Loop until we don't reassign a point: 
    while (reassignment_occurred)
        
        % E step: calculate centroid (mean) of each cluster
        cluster_sizes = zeros(k_,1); % number of points in cluster
        cluster_vals  = cell(k_,1);  % cumulative sum data points in cluster
        
        % initialize the cluster cumulative sums
        for k = 1:k_
            cluster_vals{k} = zeros(1,d);
        end
        % for each point
        for i = 1:n
            k = indices(i); % get the cluster index k for this point
            cluster_sizes(k) = cluster_sizes(k) + 1;
            cluster_vals{k} = cluster_vals{k} + data(i,:);
        end

        % for each cluster
        for k = 1:k_
            if cluster_sizes(k) > 0
                centroids{k} = cluster_vals{k} ./ cluster_sizes(k);
            % If the cluster has no points, reinitialize it
            else
                centroids{k} = data(randi([1,n],1,1),:);
            end
        end

        % M step: reassign objects to closest centroid
        new_indices = kmeans_partition(data, centroids);
        if isequal(indices, new_indices)
            reassignment_occurred = 0;
        else
            indices = new_indices;
        end
    end
    
    % We keep track of cluster variances; in the end, the clustering with
    % the lowest total variance will be chosen as the best one
    
    % First create column masks for each cluster so that we can select
    % only rows which belong to a each cluster
    cluster_masks = zeros(n,k_);
    for i = 1:n
        cluster_masks(i,indices(i)) = i;
    end
    
    % Next calculate the means of distances from each point in the cluster
    % to the centroid
    cluster_means = zeros(1,k_);
    for k = 1:k_
        mask = cluster_masks(:,k);
        mask(mask==0)=[]; 
        cluster_points = data(mask,:);
        num_points_in_cluster = size(cluster_points,1);
        total_dist = 0;
        for i = 1:num_points_in_cluster
            total_dist = total_dist + norm(cluster_points(i,:) - centroids{k});
        end
        cluster_means(k) = total_dist / num_points_in_cluster;
    end
    
    % Calculate the variance of mean distances per cluster
    current_variance = var(cluster_means);
    if current_variance < best_variance
        best_variance = current_variance;
        best_indices = indices;
        best_centroids = centroids;
    end
    disp(strcat('  Iter ', num2str(iters), ' var: ', num2str(current_variance)));
end

disp(strcat('  Best variance:', num2str(best_variance)));
indices = best_indices;
centroids = best_centroids;

