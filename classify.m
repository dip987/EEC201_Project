function [speaker_number, all_distances] = classify(lbg_codebook)
%Classify -> takes in the generated LBG Codebook and returns which speaker
%it matches. Make sure the training "codebook.mat" exists before running
%this function. Returns -1 if none 
load './codebook.mat' codebook
min_dist = inf; % Set this to the threshold value
speaker_number = -1;
all_distances = [];
for i=1:length(codebook)
    dist = distance(codebook{i}, lbg_codebook);
    all_distances = [all_distances dist]; %#ok<AGROW>
    if dist < min_dist
        min_dist = dist;
        speaker_number = i;
    end
end
disp(min_dist)

