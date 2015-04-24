function runWithFeatures(f, name, featurelist, frac, fpcost)
  fprintf('running test %s\n', name);

  addpath('viz')
  addpath('tests')
  tree = trainDecisionTree(frac, featurelist, fpcost);
  save('tree')

  terrains = ['data/terrain1'; 'data/terrain2'; 'data/terrain3'; 'data/terrain4'];
  terrain_count = size(terrains,1);
  im = cell(terrain_count);
  dem = cell(terrain_count);
  safe = cell(terrain_count);

  for i=1:terrain_count
	[im{i}, dem{i}, safe{i}] = loadTerrain(terrains(i,:));
    [pred, confidence] = predictSafety(tree, im{i}, dem{i}, featurelist);

	accuracy = calcAccuracy(pred, safe{i});
	fprintf('[%s] Accuracy for %d: %f\n', name, i, accuracy);
	fprintf(f, '[%s] Accuracy for %d: %f\n', name, i, accuracy);

	[X,Y, t, auc] = perfcurve(safe{i}(:), confidence(:), 1);
	fprintf('[%s] AUC for %d: %f\n', name, i, auc);
	fprintf(f, '[%s] AUC for %d: %f\n', name, i, auc);

	%% predicted safe region
	figure;
	imagesc(pred);
	title(sprintf('[%s] Predicted for %d',  name, i));

	%% error map
	figure;
	imagesc(pred - safe{i});
	title(sprintf('[%s] Error Map for %d (yellow=false positive)',  name, i));
  end
end
