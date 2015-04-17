addpath('viz')
addpath('tests')

terrain1 = 'data/terrain1';
terrain2 = 'data/terrain2';
terrain3 = 'data/terrain3';
terrain4 = 'data/terrain4';
terrain_name = terrain4;

[im, dem, safe] = loadTerrain(terrain_name);

features = computeFeatures(dem, 18, 16, 2);
features = smoothFeature(features, 'maxAngle', 2);

n = prod(size(dem));
Y = reshape(safe, [n 1]);
X = zeros(n, 0);
%%X(:,1) = reshape(features.('maxAngle'), [n 1]);
%%X(:,2) = reshape(features.('maxOverlap'), [n 1]);

winsize = 0;
for y = -winsize:winsize
    for x = -winsize:winsize
        X(:,end+1) = reshape(imtranslate(features.('maxAngle'), [y, x]), [n 1]);
        X(:,end+1) = reshape(imtranslate(features.('maxOverlap'), [y, x]), [n 1]);
    end
end

heightFeatures = getHeightFeatures(dem);
%% X = [X heightFeatures];

disp('got features, training decision tree')

ind = randi(n, [100000 1]);
tree = fitctree(X(ind,:), Y(ind), 'MinLeafSize', 100);

pred = predict(tree, X);
pred = reshape(pred, size(dem));
pred = medfilt2(pred, [3, 3]);

r = 18;
pred(1:r,:) = 0;
pred(end-r+1:end,:) = 0;
pred(:,1:r) = 0;
pred(:,end-r+1:end) = 0;

errors = xor(pred, safe);
accuracy = 1 - sum(errors(:)) / prod(size(errors));
disp(sprintf('ACCURACY: %0.5f', accuracy))

figure;
imshow(pred);
title('prediction')

figure;
imshow(safe);
title('true')


%% Testing Generalization
[im, dem, safe] = loadTerrain(terrain1);

features = computeFeatures(dem, 18, 16, 2);
features = smoothFeature(features, 'maxAngle', 2);

n = prod(size(dem));
Y = reshape(safe, [n 1]);
X = zeros(n, 0);
%%X(:,1) = reshape(features.('maxAngle'), [n 1]);
%%X(:,2) = reshape(features.('maxOverlap'), [n 1]);

winsize = 5;
for y = -winsize:winsize
    for x = -winsize:winsize
        X(:,end+1) = reshape(imtranslate(features.('maxAngle'), [y, x]), [n 1]);
        X(:,end+1) = reshape(imtranslate(features.('maxOverlap'), [y, x]), [n 1]);
    end
end

heightFeatures = getHeightFeatures(dem);
X = [X heightFeatures];

pred = predict(tree, X);
pred = reshape(pred, size(dem));
pred = medfilt2(pred, [3, 3]);

r = 18;
pred(1:r,:) = 0;
pred(end-r+1:end,:) = 0;
pred(:,1:r) = 0;
pred(:,end-r+1:end) = 0;

errors = xor(pred, safe);
accuracy = 1 - sum(errors(:)) / prod(size(errors));
disp(sprintf('ACCURACY: %0.5f', accuracy))

figure;
imshow(pred);
title('prediction')

figure;
imshow(safe);
title('true')
