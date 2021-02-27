function [bitRatio, total_bits] = lz77_findRatio(input, string_dict, offset_dict, maxLength_dict, type)

% Total number of bits for each offset
offset_bits = 0;
for i=1:1:length(offset_dict)
    offset_bits = offset_bits + length(de2bi(offset_dict(i)));
end

% Total number of bits for each length
length_bits = 0;
for i=1:1:length(maxLength_dict)
    length_bits = length_bits + length(de2bi(maxLength_dict(i)));
end

switch type
    case 'text'        
        % Find unique symbols in dictionary
        transSymbols = unique(string_dict);    
        % Get probabilities for each symbol
        for i=1:1:length(transSymbols)
            occur = find(string_dict == transSymbols(i));
            prob(i) = length(occur)/length(string_dict);
        end
        % Implement Huffman coding to find codeword of each unique symbol
        [dictionary,avglen] = huffmandict(cellstr([transSymbols(:)]),prob);
        codewords = huffmanenco(cellstr([string_dict(:)]),dictionary);
        % Total input bits
        input_bits = size(input,2)*8;
        % Find total bits in dictionary
        total_bits = offset_bits + length_bits + length(codewords);
        bitRatio =input_bits/total_bits;
    case 'audio'       
        % Find input bits
        binInput = dec2bin(inputArr, 8);
        binInput_length = length(str2num(binInput(:))');
        % Find encoded bits
        binEncoded = dec2bin(uint8_dict, 8);
        binEncoded_length = length(str2num(binEncoded(:))');
        % Find total bits in dictionary
        total_bits = offset_bits + length_bits + binEncoded_length;
        bitRatio = binInput_length/compToplam;
    case 'image'
        % Find input bits
        binInput = dec2bin(inputArr, 8);
        binInput_length = length(str2num(binInput(:))');
        % Find encoded bits
        binEncoded = dec2bin(uint8_dict, 8);
        binEncoded_length = length(str2num(binEncoded(:))');
        % Find total bits in dictionary
        total_bits = offset_bits + length_bits + binEncoded_length;
        bitRatio = binInput_length/compToplam;
end
    
end