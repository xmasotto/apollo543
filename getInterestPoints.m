function [px, py] = getInterestPoints(dem, sigma)
  %% get interest points
  softdem = imfilter(dem, fspecial('gaussian', 10*4+1, sigma));
  avgdem = imfilter(dem, fspecial('gaussian', 10*20+1, 20));

  windowSize = 5;
  maxes = ordfilt2(softdem, windowSize^2, ones(windowSize, windowSize));
  maxima = double(softdem >= maxes & softdem > avgdem);

  [py, px] = find(maxima > 0);
end
