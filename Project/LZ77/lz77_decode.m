function output = lz77_decode(offset_dict, maxLength_dict, string_dict, type)

% Enter the type of the encoded sequence
switch type
    case 'text'
        output = '';
    case 'audio'
        output = [];
    case 'image'
        output = [];
end
    
j = 1;
while j <= length(offset_dict)
    % If offset is zero, get the string directly in same cursor
    if offset_dict(j) == 0
        output = [output, string_dict(j)];
    % If offset is greater than 0, get the sequences in the specified
    % interval
    elseif offset_dict(j) > 0 
        m = 1;
        while m <= maxLength_dict(j)
        output = [output, output(end-offset_dict(j)+1)];
        m = m + 1;
        end
        output = [output, string_dict(j)];
    end
    j = j + 1;
end
end