function [cepstrum,t_out] = mfcc(dataType, N, p)
% dataType = 'train' or 'test'
% N = Frame size for STFT = 256
% p = number of mel frequency filters = 20

%% Read file
if strcmp(dataType,'train') 
    folder = './Data/Training_Data/';
    a=dir(['./Data/Training_Data/' '/*.wav']);
    num_data=size(a,1); % total number of .wav files in training_data folder
elseif strcmp(dataType,'test')
    folder = './Data/Test_Data/';
    a=dir(['./Data/Test_Data/' '/*.wav']);
    num_data=size(a,1); % total number of .wav files in training_data folder
end

for i=1:num_data
    file_name=strcat(folder,'s', num2str(i), '.wav');
    [file, Fs] = audioread(file_name);
    file(~any(file,2),:)=[]; %delete zeroes in sound file

    file_vector{i} = file(:,1);
    t{i}=(0:length(file_vector{i})-1)./Fs;    
end
%% TEST 2
% Time domain plots of training data
figure(1);
for i=1:num_data
    subplot(3,4,i);
    plot(t{i},file_vector{i});
    title(strcat(dataType ,' Data s',num2str(i),'.wav'));
    xlabel('Time (s)');
    ylabel('Amplitude');
end

%% Spectrogram of Raw Data
% spectrogram() uses STFT to generate periodograms
%N = 256; % Frame size
axiss = 'yaxis';
win = hamming(N, 'periodic');
%nover = nsec_spct/2;
nover = round(N*2/3); % frame_overlap = 1-frame_increment
spectrumtype = 'psd';
figure(2);
for i=1:num_data
    subplot(3,4,i);
    spectrogram(file_vector{i}, win, nover, N, Fs, axiss,spectrumtype);
    title(strcat('Raw ', dataType ,' Data s',num2str(i),'.wav'));
end

%% Normalize raw data to be between [-1,1] and centered around 0 (remove Offset)
for i=1:num_data
    file_vector{i} = file_vector{i}-mean(file_vector{i}); %center around zero
    %file_vector_norm{i} = ((file_vector{i} - min(abs(file_vector{i}))) ./ (max(abs(file_vector{i})) - min(abs(file_vector{i}))));
    file_vector_norm{i} = file_vector{i}./max(abs(file_vector{i})); %normalize amplitude by dividing by max
end

%% Crop silent portions of audio file
% Only keep data with normalized amplitude > 0.02 (-34dB)
for i=1:num_data 
    file_vector_norm_crop{i} =  file_vector_norm{i}(abs(file_vector_norm{i})>0.02);
    t_crop{i}=(0:length(file_vector_norm_crop{i})-1)./Fs;
end
%% Time domain plots of Normalized and cropped training data
figure(3);
for i=1:num_data
    subplot(3,4,i);
    plot(t_crop{i},file_vector_norm_crop{i});
    title(strcat('Normalized and Cropped ', dataType, ' Data s',num2str(i),'.wav'));
    xlabel('Time (s)');
    ylabel('Amplitude');
    ylim([-1.05,1.05]);
end

%% Spectrogram of Normalized and cropped Training Data
% spectrogram() uses STFT to generate periodograms
%N = 256; % Frame size
axiss = 'yaxis';
win = hamming(N, 'periodic');
%nover = nsec_spct/2;
nover = round(N*2/3); % frame_overlap = 1-frame_increment
spectrumtype = 'psd';

figure(4);
for i=1:num_data
    subplot(3,4,i);
    spectrogram(file_vector_norm_crop{i}, win, nover, N, Fs, axiss,spectrumtype);
    title(strcat('Normalized and Cropped ', dataType, ' Data s',num2str(i),'.wav'));
end
%% TEST 3
% N = 256; %Frame Size
% Fs = 12500; %sampling frequency
% p = number of mel filters in bank

% mel-freq filter bank
m = melfb(p, N, Fs);
figure(5);
plot(linspace(0, (Fs/2), N/2+1), m'),
title('Mel-spaced filterbank'), xlabel('Frequency (Hz)');

% Compute MFCCs for training data
for i=1:num_data
    [stft{i},~,t_stft{i}] = spectrogram(file_vector_norm_crop{i}, win, nover, N, Fs, axiss,spectrumtype);
    stft_mel{i} = m * (stft{i}.*conj(stft{i})); % matrix multiply STFT^2 with mel filter bank
    MFCC{i} = dct(log10(stft_mel{i})); % cepstrum 
    MFCC{i} = MFCC{i} ./ max(max(abs(MFCC{i}))); % normalize MFCC to be between [-1 1]
    
    % plot MFCC coefficients for different speakers
    figure(6);
    subplot(3,4,i);
    imagesc(t_stft{i},[1 p],MFCC{i});
    set(gca,'YDir','normal')
    xlabel('Time (s)');
    ylabel('MFCC Coefficients');
    title(strcat('MFCC  ', dataType, ' Data s',num2str(i),'.wav'));
    colorbar
    caxis([-1 1])
end

% Output of function
cepstrum = MFCC;
t_out = t_stft;
end