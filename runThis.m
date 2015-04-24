addpath('viz')
addpath('tests')

load('tree.mat')

terrains = {'terrain1', 'terrain2', 'terrain3', 'terrain4'};

terrain_count = length(terrains);
im = cell(1, terrain_count);
dem = cell(1, terrain_count);
safe = cell(1, terrain_count);

for i=1:terrain_count
  name = terrains{i};
  [im{i}, dem{i}, safe{i}] = loadTerrain(sprintf('data/%s', name));

  tic;
  [pred, score] = predictSafety(tree, im{i}, dem{i});
  ptime = toc;
  fprintf('[%s] Time: %0.5f\n', name, ptime);

  %% save predicted image
  imwrite(pred, sprintf('out/pred_%s.pgm', name));
  imwrite(pred, sprintf('out/pred_%s.png', name));

  if numel(safe{i}) > 0
	d = pred - safe{i};
	accuracy = sum(d(:) == 0) / numel(d);
	precision = sum(pred(:) & safe{i}(:)) / sum(pred(:));
	recall = sum(pred(:) & safe{i}(:)) / sum(safe{i}(:));

	fprintf('[%s] Accuracy: %0.5f\n', name, accuracy);
	fprintf('[%s] Precision: %0.5f\n', name, precision);
	fprintf('[%s] Recall: %0.5f\n', name, recall);

	figure;
	imagesc(pred);
	title(sprintf('[%s] Prediction (Accuracy=%0.3f)', name, accuracy));
	axis off
	savefig(sprintf('out/fig_pred_%s.fig', name));

	figure;
	imagesc(pred - safe{i});
	title(sprintf('[%s] Error (Precision=%0.3f, Recall=%0.3f)', name, precision, recall));
	axis off
	savefig(sprintf('out/fig_err_%s.fig', name));
  end

end
