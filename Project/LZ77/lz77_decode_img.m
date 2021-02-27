function output = lz77_decode_img(offset_dict, maxLength_dict, uint8_dict)

output = [];
j = 1;

while j <= length(offset_dict)
    if offset_dict(j) == 0
        output = [output, uint8_dict(j)];
    elseif offset_dict(j) > 0 
        m = 1;
        while m <= maxLength_dict(j)
        output = [output, output(end-offset_dict(j)+1)];
        m = m + 1;
        end
        output = [output, uint8_dict(j)];
    end
    j = j + 1;
end
end