function [output] = distance(inputArg1,inputArg2)
% Returns the vector distance between two codebooks
total_dist = 0;
for i=1:size(inputArg1(1))
    min_dist = inf;
    for j=1:size(inputArg2(1))
        dist = sum((inputArg1(i, :) - inputArg2(j, :)).^2);
        if dist<min_dist
            min_dist = dist;
        end
    end
    total_dist = total_dist + min_dist;
    output = total_dist;
end

