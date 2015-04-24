function [px2, py2, pz2] = getPeakFromShadow(im, dem, px, py)
  n = length(px);

  px2 = px;
  py2 = py;
  pz2 = zeros(n, 1);
  threshold = 0.3;

  actual = zeros(n, 1);

  %% fix centering
  for i = 1:n
	x = px(i);
	y = py(i);

	%% correct the y offset
	bestScore = 1;
	bestDy = 0;
	for dy = [-1 0 1]
	  winsize = 3;
	  yrange = (dy+y-winsize):(dy+y+winsize);
	  xrange = (x-winsize):(x+winsize);
	  impatch = im(yrange, xrange);

	  together = (mean(impatch, 2) - flipud(mean(impatch, 2))) / 2;
	  score = norm(together);

	  if score < bestScore
		bestScore = score;
		bestDy = dy;
	  end
	end
	py(i) = y + dy;
  end

  for i = 1:n
	x = px(i);
	y = py(i);
	pz2(i) = dem(y, x);
	actual(i) = dem(y, x);

	left = max(1, x - 30);
	intensities = diff(im(y, left:x));
	dist = length(intensities) - max(find(intensities < threshold));

	if length(dist) > 0
	  %% get rid of outliers
	  newHeight = dem(y, x-dist) + tan(30 * pi / 180) * (dist-1);
	  peakSize = dem(y, x) - dem(y, x-dist);
	  if (newHeight - pz2(i)) / peakSize > -threshold
		pz2(i) = max(pz2(i), newHeight);
	  end
	end
  end

end
