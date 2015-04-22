function [tree] = trainDecisionTree(frac)

terrains = ['data/terrain1'; 'data/terrain2'; 'data/terrain3'; 'data/terrain4'];

terrain_count = size(terrains,1);
im = cell(terrain_count);
dem = cell(terrain_count);
safe = cell(terrain_count);
samples = cell(terrain_count,2);

for i=1:terrain_count
    [im{i}, dem{i}, safe{i}] = loadTerrain(terrains(i,:));

    Y = safe{i}(:);
    X = getFeatures(dem{i});

    samples{i,1} = X;
    samples{i,2} = Y;
end

disp('got features, training decision tree')

f_count = 100000;
features = zeros(0, size(samples{1,1},2));
labels = zeros(0, 1);
train_idx = zeros(0,0);
test_idx = zeros(0,0);
for i=1:terrain_count
    [nx, ny] = size(dem{i});    
    
    [trainIdx, testIdx] = splitTrainTest(nx,ny, frac);
    
    features(end+1:end+numel(trainIdx), :) = samples{i,1}(trainIdx,:);
    labels(end+1:end+numel(trainIdx), :) = samples{i,2}(trainIdx,:);
    train_idx(:, terrain_count) = trainIdx;
    test_idx(:, terrain_count) = testIdx;
end

% tree = fitctree(X(ind,:), Y(ind), 'MinLeafSize', 100);
disp('Fitting Tree')
tree = fitctree(features, labels,  'MinLeaf', 100);
disp('Fitted Tree')

end

