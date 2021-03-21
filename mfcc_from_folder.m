function [cepstrum,t_out] = mfcc_from_folder(folder, N, p,verbose)
% Get data from the folder Make sure folder name ends with '/'
% with additional voice recordings will be used
% N = Frame size for STFT = 256
% p = number of mel frequency filters = 20
% verbose= 1 or 0. Set verbose = 1 to display the figures
%% Read file
a=dir([folder, '/*.wav']);
num_data=size(a,1); % total number of .wav files in training_data folder

for i=1:num_data
    %file_name = strcat(folder, a(i).('name'));
    file_name=strcat(folder,'s', num2str(i), '.wav');
    [file, Fs] = audioread(file_name);
    %file(~any(file,2),:)=[]; %delete zeroes in sound file

    file_vector{i} = file(:,1);
    t{i}=(0:length(file_vector{i})-1)./Fs;    
end
%% TEST 2
% Time domain plots of training data
if(verbose==1)
    figure;
    for i=1:num_data
        subplot(3,ceil(num_data/3),i);
        plot(t{i},file_vector{i});
        title(strcat(dataType ,' Data s',num2str(i),'.wav'));
        xlabel('Time (s)');
        ylabel('Amplitude');
    end
end
%% Spectrogram of Raw Data
% spectrogram() uses STFT to generate periodograms
%N = 256; % Frame size
axiss = 'yaxis';
win = hamming(N, 'periodic');
%nover = nsec_spct/2;
nover = round(N*2/3); % frame_overlap = 1-frame_increment
spectrumtype = 'psd';
if(verbose==1)
    figure;
    for i=1:num_data
        subplot(3,ceil(num_data/3),i);
        spectrogram(file_vector{i}, win, nover, N, Fs, axiss,spectrumtype);
        title(strcat('Raw',' ', dataType ,' Data s',num2str(i),'.wav'));
    end
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
if(verbose==1)
    figure;
    for i=1:num_data
        subplot(3,ceil(num_data/3),i);
        plot(t_crop{i},file_vector_norm_crop{i});
        title(strcat('Normalized and Cropped ', ' ', dataType, ' Data s',num2str(i),'.wav'));
        xlabel('Time (s)');
        ylabel('Amplitude');
        ylim([-1.05,1.05]);
    end
end
%% Spectrogram of Normalized and cropped Training Data
% spectrogram() uses STFT to generate periodograms
%N = 256; % Frame size
axiss = 'yaxis';
win = hamming(N, 'periodic');
%nover = nsec_spct/2;
nover = round(N*2/3); % frame_overlap = 1-frame_increment
spectrumtype = 'psd';
if(verbose==1)
    figure;
    for i=1:num_data
        subplot(3,ceil(num_data/3),i);
        spectrogram(file_vector_norm_crop{i}, win, nover, N, Fs, axiss,spectrumtype);
        title(strcat('Normalized and Cropped ',' ', dataType, ' Data s',num2str(i),'.wav'));
    end
end
%% TEST 3
% N = 256; %Frame Size
% Fs = 12500; %sampling frequency
% p = number of mel filters in bank

% mel-freq filter bank
m = melfb(p, N, Fs);
if(verbose==1)
    figure;
    plot(linspace(0, (Fs/2), N/2+1), m'),
    title('Mel-spaced filterbank'), xlabel('Frequency (Hz)');
end
% Compute MFCCs for training data
if(verbose==1)
    figure;
end
for i=1:num_data
    [stft{i},f_stft,t_stft{i}] = spectrogram(file_vector_norm_crop{i}, win, nover, N, Fs, axiss,spectrumtype);
    stft_mel{i} = m * (stft{i}.*conj(stft{i})); % matrix multiply STFT^2 with mel filter bank
    MFCC{i} = dct(log10(stft_mel{i})); % cepstrum 
    MFCC{i} = MFCC{i} ./ max(max(abs(MFCC{i}))); % normalize MFCC to be between [-1 1]
    if(verbose==1)
        % plot MFCC coefficients for different speakers   
        subplot(3,ceil(num_data/3),i);
        imagesc(t_stft{i}.*1e-3,[1 p],MFCC{i});
        set(gca,'YDir','normal')
        xlabel('Time (ms)');
        ylabel('MFCC Coefficients');
        title(strcat('MFCC ',' ', dataType, ' Data s',num2str(i),'.wav'));
        colorbar
        caxis([-1 1])
    end
end

% Plot Mel Spectrum
if(verbose==1)
    figure;
    for i=1:num_data
        % plot MFCC coefficients for different speakers   
        subplot(3,ceil(num_data/3),i);
        imagesc(t_stft{i}.*1e3,f_stft.*1e3,pow2db(stft_mel{i}));
        set(gca,'YDir','normal')
        xlabel('Time (ms)');
        ylabel('Frequency (kHz)');
        zlabel('Power (dB)');
        title(strcat('Mel-Spectrum ',' ', dataType, ' Data s',num2str(i),'.wav'));
        colorbar
        %caxis([-1 1])
    end
end

% Output of function
cepstrum = MFCC;
t_out = t_stft;
end