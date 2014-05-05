load('train_small.mat');

% Config
use = 5;
calculate_labeling_error = 0;
calculate_similar_digits = 1;

% Loading and preprocessing
images_ = train{use}.images;
dim = size(images_,1) * size(images_,2);
n = size(images_, 3);
images = double(reshape(images_, dim, n))';
stdev = std(images,0,2);
stdev = repmat(stdev,1,dim);
means = mean(images,2);
means = repmat(means,1,dim);
images = (images-means)./stdev;
labels = train{use}.labels;

disp('5 means')
[indices5, centroids5] = kmeans_(images, 5, 1);
figure;
for i = 1:5
    subplot(1, 5, i), imshow(reshape(centroids5{i}, 28, 28), []);
    title(num2str(i));
end
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0, 0, 10, 4]);
saveas(gcf, '5meansplus', 'jpg');

disp('10 means')
[indices10, centroids10] = kmeans_(images, 10, 1);
figure;
for i = 1:10
    subplot(1, 10, i), imshow(reshape(centroids10{i}, 28, 28));
    title(num2str(i));
end
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0, 0, 20, 4]);
saveas(gcf, '10meansplus', 'jpg');

if calculate_labeling_error
    disp('Calculating labeling error...');
    % Error will lie between 0.0 and 1.0, 0.0 being the best. It's actually,
    % before normalizing, between 1.0 and 10.0, 10.0 being the best.
    best_error = 1.0;
    for i = 1:10
        [indices10, centroids10] = kmeans_(images, 10, 5);
        error = 0.0;
        for k = 1:10
            num_labels = zeros(1,10);
            for l = 1:n
                if indices10(l) == k
                    num_labels(labels(l)+1) = num_labels(labels(l)+1) + 1;
                end
            end
            num_labels = num_labels ./ sum(num_labels);
            error = error + max(num_labels);
        end
        error = ((-error + 1) / 9) + 1;
        if error < best_error
            best_error = error;
            best_indices = indices10;
            best_centroids = centroids10;
        end
    end
    figure;
    for i = 1:10
        subplot(1, 10, i), imshow(reshape(best_centroids{i}, 28, 28));
        title(num2str(i));
    end
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperPosition', [0, 0, 20, 4]);
    saveas(gcf, '10meansbest', 'jpg');
    disp(strcat('Best error: ', num2str(best_error)));
end

if calculate_similar_digits
    disp('Calculating similar digits...');
    [indices10, centroids10] = kmeans_(images, 10, 5);
    num_labels = zeros(10,10);
    for k = 1:10
        for l = 1:n
            if indices10(l) == k
                num_labels(k,labels(l)+1) = num_labels(k,labels(l)+1) + 1;
            end
        end
        num_labels(k,:) = num_labels(k,:) ./ sum(num_labels(k,:));
    end
    
    for k = 1:10
        [m, ind] = max(num_labels(k,:));
        if m < .7
            fprintf('  %d [%d], (%.2f) looks like:', ind-1, k, m);
            for i = 1:10
                if i ~= ind && num_labels(k,i) > .1
                    fprintf(' %d (%.2f),', i-1, num_labels(k,i));
                end
            end
            fprintf('\n');     
        end
    end
    
    figure;
    for i = 1:10
        subplot(1, 10, i), imshow(reshape(centroids10{i}, 28, 28));
        title(num2str(i));
    end
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperPosition', [0, 0, 20, 4]);
    saveas(gcf, '10meansnearestdigits', 'jpg');
end

disp('20 means')
[indices20, centroids20] = kmeans_(images, 20, 3);
figure;
for i = 1:20
    subplot(1, 20, i), imshow(reshape(centroids20{i}, 28, 28));
    title(num2str(i));
end
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0, 0, 26, 4]);
saveas(gcf, '20meansplus', 'jpg');
