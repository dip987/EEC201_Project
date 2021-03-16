# EEC201_Project

Team doubleSpeak: Rishad Raiyan, Begum Kasap

## Abstract

This project aims to identify speakers by making use of mel-frequency cepstrum, vector quantization and LGB algorithm. Audio files are pre-processed in order to normalize their amplitudes and remove any silent portions. AHamming window frame of size 256 is used to compute STFT. Frame increment is set to 256/3. 20 mel-filter banks are used to get 20 MFCC coefficients. A codebook is generated from training dataset using 20 MFCCs and 16 clusters. The Test dataset is compared against the codebook and the speakers are classified based on average distortion between test data samples and codebooks' centroids. We achieved 100% accuracy from the provided training dataset and 81.82% accuracy from the provided test data set. We collected additional training and testing audio recordings from 3 different people. We achieved an accuracy of 100% on the new training dataset and 71.43% accuracy from the new test data set. 

## Run instructions

After downloading the gitHub repo, you may run 'classifying_voices.mlx' to display the accuracies on different datasets (provided and new). This script also plots the time-domain plot and spectrograms of training dataset before and after pre-processing. The MFCC coefficients are also plotted. 

You may run 'VQ.m' to plot speaker's data samples and computed centroids in the codebook in a 2D MFCC space. MFCC-2 and MFCC-3 are chosen for these 2D plots. 
