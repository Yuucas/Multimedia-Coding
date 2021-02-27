function output = lzss_decode(flag_dict, offset_dict, strLenght_dict, string_dict, type)


% Enter the type of the encoded sequence
switch type
    case 'text'
        output = '';
        j = 1;
        k = 1;
        while j <= length(flag_dict)
            if flag_dict(j) == 0
                output = strcat(output, string_dict(k));
                k = k + 1;
            elseif flag_dict(j) == 1
                m = 1;
                while m <= strLenght_dict(j)
                output = strcat(output, output(end-offset_dict(j)+1));
                m = m + 1;
                end
            end
            j = j + 1;
        end
end
    case 'audio'
        output = [];
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
    case 'image'
        output = [];
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


