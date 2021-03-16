function [speaker_number] = classify(lbg_codebook)
%Classify -> takes in the generated LBG Codebook and returns which speaker
%it matches. Make sure the training "codebook.mat" exists before running
%this function. Returns -1 if none 
load './codebook.mat' codebook
min_dist = inf; % Set this to the threshold value
speaker_number = -1;
for i=1:length(codebook)
    dist = distance(codebook{i}, lbg_codebook);
    if dist < min_dist
        min_dist = dist;
        speaker_number = i;
    end
end

