addpath('viz')
addpath('tests')

terrains = ['data/terrain1'; 'data/terrain2'; 'data/terrain3'; 'data/terrain4'];

terrain_count = size(terrains,1);
im = cell(terrain_count);
dem = cell(terrain_count);
safe = cell(terrain_count);
samples = cell(terrain_count,2);

for i=1:terrain_count
    [im{i}, dem{i}, safe{i}] = loadTerrain(terrains(i,:));

    features = computeFeatures(dem{i}, 18, 16, 2);
    features = smoothFeature(features, 'maxAngle', 2);

    n = numel(dem{i});
    Y = reshape(safe{i}, [n 1]);
    X = zeros(n, 0);

    winsize = 1;
    for y = -winsize:winsize
        for x = -winsize:winsize
            X(:,end+1) = reshape(imtranslate(features.('maxAngle'), [y, x]), [n 1]);
            X(:,end+1) = reshape(imtranslate(features.('maxOverlap'), [y, x]), [n 1]);
        end
    end

    heightFeatures = getHeightFeatures(dem{i});
    X = [X heightFeatures];
    samples{i,1} = X;
    samples{i,2} = Y;
end

disp('got features, training decision tree')

f_count = 100000;
features = zeros(0, size(samples{1,1},2));
labels = zeros(0, 1);
for i=1:terrain_count
    ind = randi(n, [f_count 1]);
    features(end+1:end+f_count, :) = samples{i,1}(ind,:);
    labels(end+1:end+f_count, :) = samples{i,2}(ind,:);
end

% tree = fitctree(X(ind,:), Y(ind), 'MinLeafSize', 100);
tree = fitctree(features, labels);

avg = 0;
for i=1:terrain_count
    pred = predict(tree, samples{i,1});
    pred = reshape(pred, size(dem{i,1}));
    pred = medfilt2(pred, [3, 3]);

    r = 21;
    pred(1:r,:) = 0;
    pred(end-r+1:end,:) = 0;
    pred(:,1:r) = 0;
    pred(:,end-r+1:end) = 0;

    errors = xor(pred, safe{i});
    accuracy = 1 - sum(errors(:)) / numel(errors);
    avg = avg + accuracy;
    fprintf('ACCURACY for %lu: %0.5f', i, accuracy);

    figure;
    imshow(pred);
    title(sprintf('Prediction for %lu, Accuracy: %0.3f', i, accuracy*100));

    figure;
    imshow(safe{i});
    title(sprintf('True for %lu', i));
end

avg = 100 * avg / 4;
fprintf('Average Accuracy: %0.2f', avg);
