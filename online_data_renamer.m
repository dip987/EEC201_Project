folder = './Data/Online/';
a=dir(['./Data/Online/' '/*.wav']);
num_data=size(a,1);

for i=1:num_data
    old_file_name = strcat(folder, a(i).('name'));
    [y, Fs] = audioread(old_file_name);
%     delete old_file_name
    new_file_name=strcat(folder,'s', num2str(i), '.wav'); 
    audiowrite(new_file_name, y, Fs);
end