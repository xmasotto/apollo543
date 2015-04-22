function [accuracy] = calcAccuracy(predicted, actual)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

errors = xor(predicted, actual);
accuracy = 100* (1 - sum(errors(:)) / numel(errors));
end

