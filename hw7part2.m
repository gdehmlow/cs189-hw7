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

% Transform images to grayscale vectors and mask them to make the 
% computation less heavy
mask = mask(:,:,1);
unmasked_pixels = find(mask);
images = zeros(n, size(unmasked_pixels,1));
for i = 1:n
    image = rgb2gray(imcell{i});
    im_vector = image(unmasked_pixels);
    images(i,:) = im_vector;
end

% The result of eigenfaces isn't normalized to be a grayscale image, so
% mapminmax takes eigenfaces and rowwise normalizes between 0-255
[efs, S, mean_face] = eigenfaces(images);
disp_efs = mapminmax(efs, 0, 255);

% Plot and save the eigenfaces
full_im = zeros(size(mask));
figure;
for i = 1:10
    full_im(unmasked_pixels) = disp_efs(i,:);
    subplot(2, 5, i), imshow(full_im, []);
    title(num2str(i));
end
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0, 0, 30, 20]);
saveas(gcf, '10celebeigenfaces', 'jpg');

% Pick 5 random faces to 'reconstruct', though more accurately we're
% going to project the faces onto the subspace defined by the eigenfaces
% and see what they look like
rand_indices = randperm(n, 5);
figure;
for i = 1:5
    recon_face = reconstruct(images(rand_indices(i),:), mean_face, efs, 10);
    full_im(unmasked_pixels) = recon_face;
    subplot(2, 5, i), imshow(full_im, []);
    title(num2str(rand_indices(i)));
end
for i = 1:5
    orig_face = images(rand_indices(i),:);
    full_im(unmasked_pixels) = orig_face;
    subplot(2, 5, i+5), imshow(full_im, []);
    title(num2str(rand_indices(i)));
end
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0, 0, 30, 20]);
saveas(gcf, '5celebrecon', 'jpg');

% Now lets compute the average L2 error over the 5 randomly chosen faces
% as a function of the number of eigenfaces used to reconstruct them
figure;
x_axis = zeros(1,n);
errors = zeros(1,n);
for p = 1:n
    x_axis(p) = p;
    total_error = 0.0;
    for i = 1:5
        orig_face = images(rand_indices(i),:);
        recon_face = reconstruct(images(rand_indices(i),:), mean_face, efs, p);
        total_error = total_error + norm(recon_face - orig_face);
    end
    errors(p) = total_error / 5.0;
end
semilogy(errors);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0, 0, 40, 30]);
saveas(gcf, '5celeberrors', 'jpg');
        
% Section 3
% Reconstruct student faces from celebrity database
cd 'StudentDatabase';
directory = dir('*.jpg');
imcell = cell(1,numel(directory));
for i = 1:numel(directory)
    imcell{i} = imread(directory(i).name);
end
cd '..'

n_students = size(imcell,2);
[w, h, d] = size(imcell{1});
images = zeros(n_students, size(unmasked_pixels,1));
for i = 1:n_students
    image = rgb2gray(imcell{i});
    im_vector = image(unmasked_pixels);
    images(i,:) = im_vector;
end

figure;
x_axis = zeros(1,n);
errors = zeros(1,n);
rand_indices = randperm(n_students, 5);
for p = 1:n
    x_axis(p) = p;
    total_error = 0.0;
    for i = 1:5
        orig_face = images(rand_indices(i),:);
        recon_face = reconstruct(images(rand_indices(i),:), mean_face, efs, p);
        total_error = total_error + norm(recon_face - orig_face);
    end
    errors(p) = total_error / 5.0;
end
semilogy(errors);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0, 0, 40, 30]);
saveas(gcf, '5studenterrors', 'jpg');