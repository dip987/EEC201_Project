function [speaker_number,D,clusterID_test] = classify(cepstrum_test,codebook,codebook_size)
%Classify -> takes in the generated LBG Codebook and returns which speaker
%it matches. 
%Returns -1 if speaker cannot be matched to noone of training speaker database 



% Nearest Codeword Search for each codebook
for i=1:codebook_size
    euc_dist = zeros(size(cepstrum_test, 1), size(codebook{i},1));
    clusterID_test{i} = zeros(size(cepstrum_test,1), 1);
    for j=1:size(codebook{i},1)
        euc_dist(:,j) = sum(((cepstrum_test-codebook{i}(j,:)).^2),2);
    end
    [~,clusterID_test{i}] = min(euc_dist, [], 2);

    % Compute D (distortion)

    D(i)=0;
    for j=1:size(codebook{i},1)
        if(~isempty(find(clusterID_test{i}==j, 1)))
            D(i) = D(i) + sum((cepstrum_test(clusterID_test{i}==j,:)-codebook{i}(j,:)).^2,'all');         
        end
    end
    D(i) = D(i)./size(cepstrum_test,1);
end
min_dist = 0.2; % Set this to the threshold value
if(min(D, [], 2) < min_dist)
    [~,speaker_number] = min(D, [], 2);
else
    speaker_number=-1;
end