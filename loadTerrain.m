function [im, dem, safe] = loadTerrain(name)
  %% load image
  im_filename = strcat(name, '/image.pgm');
  im = im2double(imread(im_filename));

  %% load safe image
  safe_filename = strcat(name, '/safe.pgm');
  if exist(safe_filename, 'file') == 2
	safe = im2double(imread(safe_filename));
  else
	safe = [];
  end

  %% load dem
  dem_filename = strcat(name, '/dem.raw');
  dem_file = fopen(dem_filename, 'r');
  dem = transpose(fread(dem_file, [500 500], 'real*4', 'ieee-be'));

  %% upsample with cubic interpolation, rescale
  [ix, iy] = meshgrid((1:1000)/2, (1:1000)/2);
  dem = interp2(dem, ix, iy, 'cubic', 0);

  %% rescale height
  dem = dem .* 10;
end
