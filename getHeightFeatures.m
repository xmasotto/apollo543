function [ features ] = getHeightFeatures(dem)
  win = 17;
  [H,W] = size(dem);
  features = reshape(dem, [H*W 1]);

  dem = padarray(dem, [win win], 'replicate');
  [newH,newW] = size(dem);

  [i,j] = meshgrid(win+1:W+win, win+1:H+win);

  dem_reshape = reshape(dem, [size(dem,1)*size(dem,2) 1]);

  for iter= -win:win
    ind = reshape(sub2ind([newH, newW], i+iter, j+iter), [H*W,1]);
    features(:,end+1) = dem_reshape(ind,1);
    
    ind = reshape(sub2ind([newH, newW], i+iter, j-iter), [H*W,1]);
    features(:,end+1) = dem_reshape(ind,1);
    
    ind = reshape(sub2ind([newH, newW], i+iter, j), [H*W,1]);
    features(:,end+1) = dem_reshape(ind,1);
    
    ind = reshape(sub2ind([newH, newW], i, j+iter), [H*W,1]);
    features(:,end+1) = dem_reshape(ind,1);
  end
  
  features = features - (mean(features,2) * ones(1,size(features,2)));
end
