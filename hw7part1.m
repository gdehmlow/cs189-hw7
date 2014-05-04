load('train_small.mat');

use = 5;
images_ = train{use}.images;
dim = size(images_,1) * size(images_,2);
n = size(images_, 3);
images = double(reshape(images_, dim, n))';
labels = train{use}.labels;


disp('5 means')
[indices5, centroids5] = kmeans(images, 5, 10);
figure;
for i = 1:5
    subplot(1, 5, i), imshow(reshape(centroids5{i}, 28, 28));
    title(num2str(i));
end
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0, 0, 10, 4]);
saveas(gcf, '5means', 'jpg');

disp('10 means')
[indices10, centroids10] = kmeans(images, 10, 10);
figure;
for i = 1:10
    subplot(1, 10, i), imshow(reshape(centroids10{i}, 28, 28));
    title(num2str(i));
end
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0, 0, 20, 4]);
saveas(gcf, '10means', 'jpg');

disp('20 means')
[indices20, centroids20] = kmeans(images, 20, 10);
figure;
for i = 1:20
    subplot(1, 20, i), imshow(reshape(centroids20{i}, 28, 28));
    title(num2str(i));
end
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0, 0, 26, 4]);
saveas(gcf, '20means', 'jpg');
