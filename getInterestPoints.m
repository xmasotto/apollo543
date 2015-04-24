function [px, py] = getInterestPoints(dem, sigma)
  %% get interest points
  softdem = imfilter(dem, fspecial('gaussian', 10*4+1, sigma));
  avgdem = imfilter(dem, fspecial('gaussian', 10*20+1, 20));

  windowSize = 5;
  maxes = ordfilt2(softdem, windowSize^2, ones(windowSize, windowSize));
  maxima = double(softdem >= maxes & softdem > avgdem);

  [py, px] = find(maxima > 0);

  %% get rid of bad interest points
  winsize = 3;
  ind = py > 1 + winsize & px > 1 + winsize ...
		& py < size(dem, 1) - winsize - 1 &px < size(dem, 2) - winsize - 1;
  py = py(ind);
  px = px(ind);

end
