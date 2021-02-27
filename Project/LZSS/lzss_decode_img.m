function output = lzss_decode_img(flag_dict, offset_dict, strLenght_dict, string_dict)

output = [];
j = 1;
k = 1;
while j <= length(flag_dict)
    if flag_dict(j) == 0
        output = [output, string_dict(k)];
        k = k + 1;
    elseif flag_dict(j) == 1
        m = 1;
        while m <= strLenght_dict(j)
            output = [output, output(end-offset_dict(j)+1)];
            m = m + 1;
        end
    end
    j = j + 1;
end
end