addpath('viz')
addpath('tests')

terrain1 = 'data/terrain1';
terrain2 = 'data/terrain2';
terrain3 = 'data/terrain3';
terrain4 = 'data/terrain4';
terrain_name = terrain1;

[im, dem, safe] = loadTerrain(terrain_name);

features = computeFeatures(dem, 18, 16, 2);
features = smoothFeature(features, 'maxAngle', 2);

%% evaluate!
baseOverlap = 3.9;
baseAngle = 10;
ratioOverlap = 1.2;
ratioAngle = 2;
overlapSearchSpace = linspace(baseOverlap / ratioOverlap, baseOverlap * ratioOverlap, 5);
angleSearchSpace = linspace(baseAngle / ratioAngle, baseAngle * ratioAngle, 100);
lineSearch(safe, features, overlapSearchSpace, angleSearchSpace);

%%% n = 10;
%%% i = 4;
%%% j = 5;
n = 1;
i = 1;
j = 1;

safeAngle = 10.3;
safeOverlap = 3.9;
safe2 = features.('maxAngle') < safeAngle;
safe3 = features.('maxOverlap') < safeOverlap;
pred = features.('maxAngle') < safeAngle & features.('maxOverlap') < safeOverlap;

%% graph the interest points
%%% interest = ones(size(dem));
%%% [px, py] = getInterestPoints(dem, sigma);
%%% for p = 1:length(px)
%%%   interest(py(p), px(p)) = 0;
%%% end
%%% figure;
%%% showMesh(dem, interest, n, i, j);
%%% title('interest points');

figure;
showMesh(dem, safe3, n, i, j)
title('overlap hazard')

figure;
showMesh(dem, safe, n, i, j)
title('actual')

figure;
imshow(safe);
title('safe');
