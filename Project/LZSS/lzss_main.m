%% Text Implementation
% Enter the type of input to find the bitrate and output
% Input can be: 'text', 'audio', and 'image'
string = ['Text\balls.txt'];
formatSpec = '%s';
fileID = fopen(string,'rt');
input = fscanf(fileID,formatSpec);

searchWindow = 50;

[dict, flag_dict, offset_dict, strLenght_dict, string_dict] = lzss_encode(input, searchWindow);
output = lzss_decode(flag_dict, offset_dict, strLenght_dict, string_dict, 'text');
[bitRatio, total_bits] = lzss_findRatio(input, string_dict, offset_dict, maxLength_dict, flag_dict, 'text');

%% Audio Implementation
% Enter the type of input to find the bitrate and output
% Input can be: 'text', 'audio', and 'image'
filenamein = 'Audio\70stereo.wav';

info = audioinfo(filenamein);
[x,F] = audioread(filenamein,'native') ; 
fprintf('\n'); 
fprintf('Sampling frequency:      F = %d',F); fprintf(' [Hz] \n'); 
fprintf('Resolution:          nbits = %d',info.BitsPerSample); fprintf(' [bit] \n');

if info.NumChannels == 2
    xmono = int16(mean(x'));
end

Delta = 2^8;  % quantization with quantization step  2^8
xmono16bits = int16(sign(xmono)).*int16(floor((single(abs(xmono))/Delta))); 
inputArr = uint8(xmono16bits + 127);

searchWindow = 50;

[dict, flag_dict, offset_dict, strLenght_dict, string_dict] = lzss_encode_img(input, searchWindow);
output = lzss_decode(flag_dict, offset_dict, strLenght_dict, string_dict, 'audio');
[bitRatio, total_bits] = lzss_findRatio(input, string_dict, offset_dict, maxLength_dict, flag_dict, 'audio');

filenameout = '70mono8bits_test.wav';
audiowrite(filenameout,output,F,'BitsPerSample',8);

%% Image Implementation
% Enter the type of input to find the bitrate and output
% Input can be: 'text', 'audio', and 'image'
filename = 'Images\barbara.tiff';
info = imfinfo(filename);
x = imread(filename);  
inputArr = reshape(x, 1, numel(x));

searchWindow = 50;

[dict, flag_dict, offset_dict, strLenght_dict, string_dict] = lzss_encode_img(input, searchWindow);
output = lzss_decode(flag_dict, offset_dict, strLenght_dict, string_dict, 'image');
[bitRatio, total_bits] = lzss_findRatio(input, string_dict, offset_dict, maxLength_dict, flag_dict, 'image');

outLen = length(output);
decodedImage = reshape(output, sqrt(outLen), sqrt(outLen));