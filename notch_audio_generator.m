%% Read file
folder = './Data/Training_Data/';
new_folder = './Data/Notch/';
a=dir(['./Data/Training_Data/' '/*.wav']);
num_data=size(a,1);

for i=1:num_data
    file_name=strcat(folder,'s', num2str(i), '.wav'); 
    [file, Fs] = audioread(file_name);
    file_vector{i} = file(:,1);
end
notch_ranges = [0.4 0.6; 
                0.2 0.4;
                0.8 0.99];
file_number = 1;

for k=1:size(notch_ranges, 1)
    for i=1:num_data
        file = file_vector{i};
        new_audio = bandstop(file, notch_ranges(k, :));
        audiowrite(strcat(new_folder, num2str(file_number), '.wav'), new_audio, Fs);
        file_number = file_number + 1;
    end
end

