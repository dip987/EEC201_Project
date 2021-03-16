function [codebook, clusterID, D] = LBG(X, K, distortion_eps)
% X = input matrix of size M*N where N is number of features and M is number
% of sampels
% K = number of clusters, must be a power of 2
% distortion_eps: (D'-D/D)<distortion_eps
%%
% Step 1: Initialize single-vector cocebook : centroid of all training vectors
codebook = mean(X,1); %1*N vector

D_prime = 0;
while size(codebook,1) < K
    eps = 0.01;
    % Step 2: double size of codebook by splitting
    codebook = [codebook.*(1-eps);codebook.*(1+eps)];
    
    while(1)
        % step 3: Nearest-Neighbor Search
        for i=1:size(codebook,1)
            euc_dist(:,i) = sum(((X-codebook(i,:)).^2),2);
        end
        [~,clusterID] = min(euc_dist, [], 2);

        %Step 4: Centroid update
        for i=1:size(codebook,1)
            codebook(i,:) = mean(X(clusterID==i,:));
        end

        % Compute D (distortion)
        D=0;
        for i=1:size(codebook,1)
            D = D + sum((X(clusterID==i)-codebook(i,:)).^2,'all');       
        end
        D = D./size(X,1);
        
        if((D_prime-D)/D < distortion_eps)
            break
        end
        D_prime = D;
    end
end

%final size of codebook is K*N, K=number of clusters, N=number of features
end