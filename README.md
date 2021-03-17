# EEC201_Project

Team doubleSpeak: Begum Kasap, Rishad Raiyan

## Abstract

This project aims to identify speakers by making use of mel-frequency cepstrum, vector quantization and LGB algorithm. Audio files are pre-processed in order to normalize their amplitudes and remove any silent portions. A Hamming window frame of size 256 is used to compute STFT. Frame increment is set to 256/3. 20 mel-filter banks are used to get 20 MFCC coefficients. A codebook is generated from training dataset using 20 MFCCs and 16 clusters. The Test dataset is compared against the codebook and the speakers are classified based on average distortion between test data samples and codebooks' centroids. A total of 11 audio files were provided for training and testing purposes. If we use all 11 audio files for training and testing, we achieved 100% accuracy from the provided training dataset and 81.82% accuracy from the provided test data set. If we use only 8 audio files for training and 11 audio files for testing, our algorithm can correctly reject 2/3 of new unknown skeapers and achieves 71.73% testing accuracy. Furthermore, we collected additional training and testing audio recordings from 3 different people. We achieved an accuracy of 100% on the new training dataset and 71.43% accuracy from the new test data set. The human performance accuracy is recorded as 62.5% (average between two human performances). Therefore, our algorithm performs better than human benchmark. 

## Run instructions

After downloading the gitHub repo, you may run 'classifying_voices.mlx' to display the accuracies on different datasets (provided and new). This script also plots the time-domain plot and spectrograms of training dataset before and after pre-processing. The MFCC coefficients as well as Mel-frequency filter bank are also plotted. 

You may run 'VQ.m' to plot speaker's data samples and computed centroids in the codebook in a 2D MFCC space. MFCC-2 and MFCC-3 are chosen for these 2D plots. 

### A. Speech Data Files

The provided dataset for this project comprised of 11 speechfiles recorded by 11 distinc speakers saying 'Zero'. Each speachfile is named in format S{x}.wav where {x} is the ID of the speaker (x = 1...11). The speechfiles are located under /Data folder. We aim to train a voice model by creating a VQ codebook in the MFCC vector space for each speaker under 'training_data'. The codebook will contain information on voice characteristic of each (known) speaker. Next, we try identifying the speaker ID of speachfiles located under 'test_data'. In order to have a benchmark, we recorded how accurate humans can identify the speakers and took the average between two human separate performances. We recorded an accuracy of 62.5% as human performance. 

### B. Speech Preprocessing

We first start by pre-processing the speechfiles. Figure B1 shows the time domain plot of unprocessed 11 speechfiles. 

<p align="center">
  <img src="https://github.com/dip987/EEC201_Project/tree/main/images/FigB1.jpg?raw=true" width="350" alt="Figure B1: Time domain plots of raw speechfiles">
</p>

Write a function that reads a sound file and turns it into a sequence of MFCC (acoustic vectors) using the speech processing steps described previously. Helpful matlab functions include: wavread, hamming, fft, dct, and own function melfb_own.m

**TEST2:** In Matlab one can playthe sound file using “sound”.  Record the sampling rateand compute how many milliseconds of speech are contained in a block of 256 samples? Now plot the signal to view it in the time domain.  It should be obvious that the raw data are long and may need to be normalized because of different strengths.  

Use STFT to generateperiodogram.Locate the region in the plot that contains most of the energy, in time (msec) and frequency (in Hz) of the input speech signal.Try different frame size: for example N = 128, 256 and 512.  In each case, set the frame increment M to be about N/3.  
