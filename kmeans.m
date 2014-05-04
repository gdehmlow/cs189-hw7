function [ indices, centroids ] = kmeans( data, k_, max_iters)
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

% We'll choose the random centroids by first finding the maximum size
% along all dimensions and use that to create our hypercube from which
% we will draw our random centroids
max = -Inf;
min = Inf;
for i = 1:n
    for k = 1:d
        val = data(i,k);
        if val > max
            max = val;
        end
        if val < min
            min = val;
        end
    end
end

max_clusters = -Inf;
retry = 1;
iters = 0;
while (retry && iters < max_iters)
    iters = iters + 1;
    retry = 0;
    % Choose k centroids at random
    centroids = cell(k_,1);
    for k = 1:k_
        centroids{k} = (max - min).*rand(1,d) + min;
    end

    % Make initial partition of objects into k clusters
    indices = kmeans_partition(data, centroids);
    reassignment_occurred = 1;
    no_reinit = 1;

    % Loop until we don't reassign a point: 
    while (reassignment_occurred && no_reinit)

      % E step: calculate centroid (mean) of each cluster
        cluster_sizes = zeros(k_,1); % number of points in cluster
        cluster_vals  = cell(k_);    % cumulative sum data points in cluster
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

        no_reinit = 1;
        % for each cluster
        for k = 1:k_
            if cluster_sizes(k) > 0
                centroids{k} = cluster_vals{k} ./ cluster_sizes(k);
            % If the cluster has no points, reinitialize it
            else
                centroids{k} = (max - min).*rand(1,d) + min;
            end
        end

      % M step: reassign objects to closest centroid
        % inefficient that we're creating new indices array each time, w/e
        new_indices = kmeans_partition(data, centroids);
        if isequal(indices, new_indices)
            reassignment_occurred = 0;
        else
            indices = new_indices;
        end

        used_clusters = zeros(k_,1);
        for i = 1:n
            used_clusters(indices(i)) = 1;
        end
        
        num_clusters = sum(used_clusters);
        if (num_clusters > max_clusters)
            max_clusters = num_clusters;
            best_indices = indices;
            best_centroids = centroids;
        end
            
        
        if (num_clusters < k)
            retry = 1;
        end
    end
    
    disp(strcat('num clusters: ', num2str(num_clusters)))
end

disp(strcat('best num clusters: ', num2str(max_clusters)))
indices = best_indices;
centroids = best_centroids;

