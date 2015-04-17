function lineSearch(safe, features, overlapSearchSpace, angleSearchSpace)
  maxAccuracy = 0;

  figure;
  for j = 1:length(overlapSearchSpace)
	safeOverlap = overlapSearchSpace(j);

	accuracy = zeros(1, length(angleSearchSpace));
	for i = 1:length(angleSearchSpace)
	  safeAngle = angleSearchSpace(i);

	  pred = features.('maxAngle') < safeAngle & features.('maxOverlap') < safeOverlap;
	  errors = xor(pred, safe);
	  accuracy(i) = 1 - sum(errors(:)) / prod(size(errors));
	  if accuracy(i) > maxAccuracy
		maxAccuracy = accuracy(i);
	  end
	end

	plot(angleSearchSpace, accuracy, 'DisplayName', sprintf('overlap=%0.2f', safeOverlap)), hold on;
	legend('-DynamicLegend');
  end

  ylim([0 1]);
  xlabel(sprintf('max accuracy: %0.4f', maxAccuracy));
  hold off;
end
