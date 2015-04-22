function [train_idx, test_idx] = splitTrainTest(nx, ny, frac)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

indx = 1:nx;
indy = 1:ny;
n = nx*ny;
f_count = frac*n;

s_train = ceil(sqrt(f_count));
t_indx = randi(nx-s_train+1, [1 1]);
train_indx = t_indx: t_indx+s_train-1;
t_indy = randi(ny-s_train+1, [1 1]);
train_indy = t_indy: t_indy+s_train-1;
[train_INDX, train_INDY] = meshgrid(train_indx, train_indy);
train_INDX = train_INDX(:);
train_INDY = train_INDY(:);
[INDX, INDY] = meshgrid(indx, indy);
INDX = INDX(:);
INDY = INDY(:);
mask1 = INDX<t_indx;
mask2 = INDX>=t_indx+s_train;
mask3 = INDY<t_indy;
mask4 = INDY>=t_indy+s_train;
test_INDX = INDX((mask1 | mask2) | (mask3 | mask4));
test_INDY = INDY((mask1 | mask2) | (mask3 | mask4));

train_idx = sub2ind([nx ny], train_INDX, train_INDY);
test_idx = sub2ind([nx ny], test_INDX, test_INDY);
end

