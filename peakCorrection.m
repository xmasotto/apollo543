function [dem2, px2, py2] = peakCorrection(im, dem, px, py, threshold)
  visualize = 0;

  winsize = 3;
  sigma = 2;

  %% get rid of bad interest points
  ind = py > 1 + winsize & px > 1 + winsize ...
		& py < size(im, 1) - winsize - 1 &px < size(im, 2) - winsize - 1;
  py = py(ind);
  px = px(ind);
  n = length(px);

  scores = -ones(1, n);
  bestDx = zeros(n);
  bestDy = zeros(n);
  bestA = zeros(n);

  cos30 = cos(30 * pi / 180);
  sin30 = sin(30 * pi / 180);

  k = (2*winsize+1)^2;
  patches = zeros(n, k);

  for dx = [-1 0 1]
	for dy = [-1 0 1]
	  [Ix, Iy] = meshgrid(dx+(-winsize:winsize), dy+(-winsize:winsize));

	  for i = 1:n
		patch = im(dy+((py(i)-winsize):(py(i)+winsize)), dx+((px(i)-winsize):(px(i)+winsize)));
		patch = (patch - mean(patch(:))) / std(patch(:));
		patches(i, :) = reshape(patch, [1 k]);
	  end

	  for a = linspace(0.05, 2)
		%% disp(sprintf('dx: %d, dy: %d, a: %0.5f', dx, dy, a));
	  	ddx = -2*a*Ix;
	  	ddy = -2*a*Iy;
	  	r = sqrt(ddx .* ddx + ddy .* ddy + 1);
	  	rendered = -cos30 * ddx ./ r + sin30 ./ r;
		rendered = (rendered - mean(rendered(:))) / std(rendered(:));
		rendered = reshape(rendered, [1 k]);

		for i = 1:n
		  dempatch = dem(dy+((py(i)-winsize):(py(i)+winsize)), dx+((px(i)-winsize):(px(i)+winsize)));
		  score = norm(rendered - patches(i, :));
		  score = score + a * 3;

		  %% score = 1000 - dot(rendered, patches(i, :));
		  %% score = norm(rendered - patches(i, :));
		  if scores(i) < 0 || score < scores(i)
			scores(i) = score;
			bestDx(i) = dx;
			bestDy(i) = dy;
			bestA(i) = a;
			bestPatch{i} = reshape(patches(i,:), [2*winsize+1, 2*winsize+1]);
			bestPatch2{i} = reshape(rendered, [2*winsize+1, 2*winsize+1]);
		  end
		end
	  end
	end
  end

  patchFilter = fspecial('gaussian', [2*winsize+1 2*winsize+1], sigma);
  patchFilter = patchFilter ./ max(patchFilter(:));

  if visualize
	figure;
	hist(scores, 100)
	title('histogram of scores');
  end

  [Ix, Iy] = meshgrid(1:size(im, 2), 1:size(im, 1));
  iter = 0;
  for i = 1:n
	%% if scores(i) > threshold
	%%   continue
	%% end

	iter = iter + 1;
	px(i) = px(i) + bestDx(i);
	py(i) = py(i) + bestDy(i);

	xrange = (px(i)-winsize):(px(i)+winsize);
	yrange = (py(i)-winsize):(py(i)+winsize);

	olddem = dem(yrange, xrange);
	newdem = -bestA(i) * ((Ix(yrange, xrange) - px(i)).^2 ...
						  + (Iy(yrange, xrange) - py(i)).^2);

	oldcenter = olddem(winsize:winsize+2,winsize:winsize+2);
	newcenter = newdem(winsize:winsize+2,winsize:winsize+2);
	newdem = newdem + max(oldcenter(:) - newcenter(:));
	%% newdem = newdem + mean(oldcenter(:)) - mean(newcenter(:));
	combined = patchFilter .* max(newdem, olddem) + (1-patchFilter) .* olddem;

	diff = std(combined(:) - olddem(:)) / mean(combined(:) - olddem(:));
	if diff < 1 || 1
	  dem(yrange, xrange) = combined;
	end

	if visualize
	  figure;

  	  subplot(3, 2, 1);
  	  imshow(bestPatch{i})
  	  title('original');

  	  subplot(3, 2, 2);
  	  imshow(bestPatch2{i});
  	  title(sprintf('fit dx=%d, dy=%d, a=%0.3f, score=%0.3f', bestDx(i), bestDy(i), bestA(i), scores(i)));

	  subplot(3, 2, 3);
	  mesh(olddem);
	  set(gca,'Ydir','reverse')
	  title('original patch');

	  subplot(3, 2, 4);
	  mesh(max(newdem, olddem));
	  set(gca,'Ydir','reverse')
	  title('parabola');

	  subplot(3, 2, 5);
	  mesh(patchFilter);
	  set(gca,'Ydir','reverse')
	  title(sprintf('patchFilter, sigma=%0.3f', sigma));

	  subplot(3, 2, 6);
	  mesh(combined);
	  set(gca,'Ydir','reverse')
	  title(sprintf('combined, correction = %0.5f', max(newdem(:)) - max(olddem(:))));
	  if iter > 10
		break;
	  end
	end
  end

  dem2 = dem;
  px2 = px;
  py2 = py;

end
