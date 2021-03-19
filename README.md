# EEC201_Project

Team doubleSpeak: Begum Kasap, Rishad Raiyan

## Abstract

This project aims to identify speakers by making use of mel-frequency cepstrum, vector quantization and LGB algorithm. Audio files are pre-processed in order to normalize their amplitudes and remove any silent portions. A Hamming window frame of size 256 is used to compute STFT. Frame increment is set to 256/3. 20 mel-filter banks are used to get 20 MFCC coefficients. A codebook is generated from training dataset using 20 MFCCs and 16 clusters. The Test dataset is compared against the codebook and the speakers are classified based on average distortion between test data samples and codebooks' centroids. A total of 11 audio files were provided for training and testing purposes. If we use all 11 audio files for training and testing, we achieved 100% accuracy from the provided training dataset and 81.82% accuracy from the provided test data set. If we use only 8 audio files for training and 11 audio files for testing, our algorithm can correctly reject 2/3 of new unknown skeapers and achieves 71.73% testing accuracy. Furthermore, we collected additional training and testing audio recordings from 3 different people. We achieved an accuracy of 100% on the new training dataset and 71.43% accuracy from the new test data set. The human performance accuracy is recorded as 62.5% (average between two human performances). Therefore, our algorithm performs better than human benchmark. 
 
## Run instructions

After downloading the gitHub repo, you may run 'classifying_voices.mlx' to display the accuracies on different datasets (provided and new). This script also plots the time-domain plot and spectrums of training dataset before and after pre-processing. The MFCC coefficients (Cepstrum) as well as Mel-frequency filter bank are also plotted. 

You may run 'VQ.m' to plot speaker's data samples and computed centroids in the codebook in a 2D MFCC space. MFCC-2 and MFCC-3 are chosen for these 2D plots. 

### A. Speech Data Files

The provided dataset for this project comprised of 11 speechfiles recorded by 11 distinc speakers saying 'Zero'. Each speachfile is named in format S{x}.wav where {x} is the ID of the speaker (x = 1...11). The speechfiles are located under /Data folder. We aim to train a voice model by creating a VQ codebook in the MFCC vector space for each speaker under 'training_data'. The codebook will contain information on voice characteristic of each (known) speaker. Next, we try identifying the speaker ID of speachfiles located under 'test_data'. In order to have a benchmark, we recorded how accurate humans can identify the speakers and took the average between two human separate performances. We recorded an accuracy of 62.5% as human performance. 

### B. Speech Preprocessing and Feature Extraction

Speech signals are quasi-stationary meaning that when examined with Short-Time Fourier Transform (STFT) with a sufficiently short frame (20.48 msec in this project) their frequency characteristics are mostly stationary. The variation of frequency characteristics over a long duration (>1/5 seconds) would reveal information on different sounds being produced. Although short-time spectral analysis is a good starting point to characterize speech signal it is not sufficient for the speaker recognition task. We compute Mel-Frequency Cepstrum Coefficients (MFCC) from the spectrums in order to parametrically represent speech signal. Since humans are good are recognizing speakers, MFCC's are based on the known variation of the human ear’s critical bandwidths with frequency. We use a Mel-Filter bank with 20 filters spaced linearly at low frequencies and logarithmically at high frequencies to capture the phonetically important characteristics of speech. In the end we have 20 MFCCs which are our features to be used in speaker identification. These steps are summarized in Figure B0 below. The steps described in this section are implemented under the function 'mfcc.m' present in this repo. 

<p align="center">
  <img src="/images/FigB0.jpg?raw=true" alt="Figure B0: Block diagram of the MFCC processor" width=600>
  <br>
  <em>Figure B0: Block diagram of the MFCC processor</em>
</p>

#### Pre-Processing Continuous speech and Generating Spectrum

We first start by pre-processing the speechfiles. Figure B1 shows the time domain plot of unprocessed 11 speechfiles. One can notice that the speechfiles are long and we need to crop the beginning and end portions of the speach where the speaker is not talking. Also each speaker's voice has a different amplitude and different mean. For example, S9, S10 and S11 have a certain offset and does not have a mean of zero. We should normalize the amplitudes of the time-domain speaker data, by dividing by maximum absolute amplitude, so that our speaker identifier algorithm is robust against variations in volume of the speaker. We also remove the offset before normalizing.

<p align="center">
  <img src="/images/FigB1.jpg?raw=true" alt="Figure B1: Time domain plots of raw speechfiles">
  <em>Figure B1: Time domain plots of raw speechfiles</em>
</p>

Let's also take a look into the frequency content over time of unprocessed speechfiles. We use STFT to generate the spectrograms plotted in Figure B2. The speechfiles have a sampling rate of 12.5kHz. A Hamming window size of **256 samples/20.48 msec** is used to generate the spectrograms. The Frame increment between windows is set to 1/3 of frame size. A window size of 256 samples was chosen because typical adult female voice frequency is from 165Hz to 255Hz and typical adult male voice frequency is from 85Hz to 180Hz. Therefore, we can have at least 49 samples (12.5kHz/255Hz) and at most 147 samples (12.5kHz/85Hz) within a period of any voice signal. When choosing the window size for STFT we need to make sure we have at least one or two periods of voice signals within a frame  and 256 samples frame size is a good fit. 

<p align="center">
  <img src="/images/FigB2.jpg?raw=true" alt="Figure B2: Spectrograms of raw speechfiles"
  <em>Figure B2: Spectrograms of raw speechfiles</em>
</p>

When we observe the spectrograms of the speechfiles we notice that most of the frequency content is at lower frequencies and the periodogram has high amplitude in time when the speaker starts speaking. We can remove the silent portions of the audio files by only keeping the data with a normalized amplitude of 0.02 (-34dB) or higher. Figure B3 shows the time-domain plots and figure B4 shows the spectrograms of the processed data. 

<p align="center">
  <img src="/images/FigB3.jpg?raw=true" alt="Figure B3: Time domain plots of Processed speechfiles">
  <em>Figure B3: Time domain plots of Processed speechfiles</em>
</p>

<p align="center">
  <img src="/images/FigB4.jpg?raw=true" alt="Figure B4: Spectrograms of Processed speechfiles">
  <em>Figure B4: Spectrograms of Processed speechfiles</em>
</p>

#### Mel Spectrum
Studies have shown that humans perceive the frequency contents of sounds in a non-linear scale. Each tone with an actual frequency f (Hz) have a corresponding subjective pitch in a scale called 'mel' scale. The mel-frequency scale has linear spacing below 1kHz and logarithmic spacing above 1kHz. One can simulate the mel-frequency scale by generating a filter bank spaced uniformly on the mel-scale. We use a total of 20 filters in this project and the plot of used mel-spaced filter bank response is shown in Figure B5. This filter bank response is generated using 'melfb.m'.

<p align="center">
  <img src="/images/FigB5.jpg?raw=true" alt="Figure B5: Mel-Spaced Filter Bank Response with 20 coefficients" width=600>
  <br>
  <em>Figure B5: Mel-Spaced Filter Bank Response with 20 coefficients</em>
</p>

After applying the Mel-spaced filter bank response to our processed speeechfile spectrum, we get the Mel-Spectrum shown in Figure B6. We see that applying mel-spaced filterbank made the low-frequency components stand out more.

<p align="center">
  <img src="/images/FigB6.jpg?raw=true" alt="Figure B6: Mel-Spectrum" width=600>
  <br>
  <em>Figure B6: Mel-Spectrum</em>
</p>

Finally, we compute the cepstrum and convert log mel spectrum back to time. We apply discrete-cosine transform (DCT) to log mel spectrum and obtain mel frequency cepstrum coefficients (MFCC). MFCCs are the features of our speaker identification algorithm. We normalized the MFCC to make them in range [-1 1] and avoid sparsity of our features. We plot the normalized MFCC of 11 speechfiles in Figure B7. The 0 coefficient is ignored since it represents the mean of the continuous time audio data and is irrelevant in speaker identification. 

<p align="center">
  <img src="/images/FigB7.jpg?raw=true" alt="Figure B7: MFCC" width=600>
  <br>
  <em>Figure B7: Normalized Mel Frequency Cepstrum Coefficients (MFCC)</em>
</p>


### Notch Filter
A notch filter/band-stop filter prevents a specific range of frequencies from passing through. In speech recognition, it can be used to drop a particular frequency range from the speech signal. Usually, human speech consists of frequencies of around 100-300Hz. 
To determine the robustness of our speech recognition system, we chopped-off different frequency intervals from the speech signals and recorded its effect on the system accuracy. We started off by taking even intervals along the entire frequency range. Afterwards, we tried leaving off adult male and female voice ranges as well. 

### Results
When cropping off lower frequencies, (0 - 1250Hz), the system got only a single testing example correct. For the rest of the testing samples, the Euclidean distance from the training centroids were extremely high and subsequently they were detected as an unknown speaker. The results are slightly better when we cropped off a slightly higher range (1250 – 2500 Hz). Although its not as good as the original test set. But using a notch filter with any interval starting off at higher than 2500 Hz gave the same results as using the entire frequency range. 
Adult female vocal frequencies range from 165Hz to 255Hz. When we cropped off this portion of the audio, the estimation accuracy drastically fell for female speakers in the test set (Speaker 1 – 9). The system was only able to correctly detect two speakers in this case while the rest were detected as unknown. Strangely, when dropping the adult male frequency range (85-180 Hz), we expected the system to not be able to detect any of the male speakers in the test set. Since, this range is disjoint from the adult female vocal frequency range, we also expected the system to have similar accuracy to using the entire frequency range for female speakers. While the later assumption is somewhat true with only an exception in a single case, the first assumption was not true. The detection system was able to correctly guess both the male speakers from the test set.

![image](https://user-images.githubusercontent.com/45767121/111536741-e0cdf380-8727-11eb-8a91-68deef96a24d.png)


