function [ features ] = getHeightFeatures(dem)
  win = 17;
  feature_count = 35;
  [H,W] = size(dem);
  features = reshape(dem, [H*W 1]);

  dem = padarray(dem, [win win], 'replicate');
  [newH,newW] = size(dem);

  [i,j] = meshgrid(win+1:W+win, win+1:H+win);
								% i = linspace(win+1,W+win,W);
								% j = linspace(win+1,H+win,H);

  dem_reshape = reshape(dem, [size(dem,1)*size(dem,2) 1]);

  for iter= -win:win
    ind1 = reshape(sub2ind([newH, newW], i+iter, j+iter), [H*W,1]);
    features(:,end+1) = dem_reshape(ind1,1);
  end

  for iter= -win:win
    ind1 = reshape(sub2ind([newH, newW], i+iter, j-iter), [H*W,1]);
    features(:,end+1) = dem_reshape(ind1,1);
  end

  for iter= -win:win
    ind1 = reshape(sub2ind([newH, newW], i+iter, j), [H*W,1]);
    features(:,end+1) = dem_reshape(ind1,1);
  end

  for iter= -win:win
    ind1 = reshape(sub2ind([newH, newW], i, j+iter), [H*W,1]);
    features(:,end+1) = dem_reshape(ind1,1);
  end


  features = features - (mean(features,2) * ones(1,size(features,2)));
end
