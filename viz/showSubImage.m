function showSubImage(im, k, i, j)
  b = length(im) / k;
  xrange = ((i-1)*b+1:i*b);
  yrange = ((j-1)*b+1:j*b);

  scale = 10;
  subim = im(yrange, xrange);
  imshow(imresize(subim, scale, 'nearest'));
end
