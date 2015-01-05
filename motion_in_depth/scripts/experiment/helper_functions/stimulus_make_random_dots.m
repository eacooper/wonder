function [dots] = stimulus_make_random_dots(dotsSize,xmax,ymax,numDots)

% Stimulus settings:
dots = zeros(2, numDots);

xmax = min(xmax, ymax) / 2;
ymax = xmax;

dots(1, :) = 2*(xmax)*rand(1, numDots) - xmax;
dots(2, :) = 2*(ymax)*rand(1, numDots) - ymax;

