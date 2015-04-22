addpath('viz')
addpath('tests')
if exist('tree.mat', 'file') == 2
    load('tree.mat')
else
    tree = trainDecisionTree(0.1); % Use 10% of total points for training
    save('tree.mat','tree');
end

terrains = ['data/terrain1'; 'data/terrain2'; 'data/terrain3'; 'data/terrain4'];

terrain_count = size(terrains,1);
im = cell(terrain_count);
dem = cell(terrain_count);
safe = cell(terrain_count);

accuracies = [];
for i=1:terrain_count
    [im{i}, dem{i}, safe{i}] = loadTerrain(terrains(i,:));
    pred = predictSafety(tree,dem{i});
    
    accuracies(end+1) = calcAccuracy(pred, safe{i});
    fprintf('ACCURACY for %lu: %0.5f\n', i, accuracies(end));

    figure;
    imshow(pred);
    title(sprintf('Prediction for %lu, Accuracy: %0.3f', i, accuracies(end)));

    figure;
    imshow(safe{i});
    title(sprintf('True for %lu', i));
end

avg = mean(accuracies);
fprintf('Average Accuracy: %0.2f\n', avg);


