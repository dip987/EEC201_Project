clc
clear all
close all
%%
[cepstrum,t] = mfcc('train',256,20);
%% TEST 5

figure;
plot(cepstrum{10}(2,:)',cepstrum{10}(3,:)','o');
hold on
grid on
plot(cepstrum{3}(2,:),cepstrum{3}(3,:)','x');
legend('speaker 10','speaker 3');
title('2D MFCC space');
xlabel('MFCC - 2');
ylabel('MFCC - 3');

%% TEST 6
K=4; % number of clusters
N = 20; %number of MFCC features to use;
distortion_eps = 0.05;
for i=1:size(cepstrum,2)
    [codebook{i}, clusterID{i}, D{i}] = LBG((cepstrum{i}(1:N,:))', K, distortion_eps);
end
%%

figure;
plot(cepstrum{10}(2,:),cepstrum{10}(3,:)','o');
hold on
grid on
plot(codebook{10}(:,2),codebook{10}(:,3),'o','Color','b','LineWidth',10);
plot(cepstrum{3}(2,:)',cepstrum{3}(3,:)','x','Color','r');
plot(codebook{3}(:,2),codebook{3}(:,3),'X','Color','r','LineWidth',10);
legend('speaker 10','Centroids 10','speaker 3','Centroids 3');
title('2D MFCC space, K=4 clusters');
xlabel('MFCC - 2');
ylabel('MFCC - 3');

%%
CM = hsv(15); 
figure;
plot(cepstrum{1}(2,:),cepstrum{1}(3,:)','o','Color',CM(1,:));
hold on
grid on
plot(codebook{1}(:,2),codebook{1}(:,3),'o','Color',CM(1,:),'LineWidth',20);
for i=2:size(cepstrum,2)
    plot(cepstrum{i}(2,:)',cepstrum{i}(3,:)','o','Color',CM(i,:));
    plot(codebook{i}(:,2),codebook{i}(:,3),'o','Color',CM(i,:),'LineWidth',20);
end
legend('speaker 1','Centroids 1','speaker 2','Centroids 2',...
       'speaker 3','Centroids 3','speaker 4','Centroids 4',...
       'speaker 5','Centroids 5','speaker 6','Centroids 6',...
       'speaker 7','Centroids 7','speaker 8','Centroids 8',...
       'speaker 9','Centroids 9','speaker 10','Centroids 10',... 
       'speaker 11','Centroids 11');
title('2D MFCC space, K=4 clusters');
xlabel('MFCC - 2');
ylabel('MFCC - 3');
