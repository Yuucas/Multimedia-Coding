function [dict, flag_dict, offset_dict, strLenght_dict, string_dict] = lzss_encode(input, search_window_size)

% Initial sequences
dict = [];
flag_dict = [];
offset_dict = [];
strLenght_dict = [];
string_dict = '';
matched_string = '';
flag = 0;
position = 1;
 
while position <= length(input)
    % Lookahead buffer size
    lookahead_buffer_size = position - search_window_size;
    j_reverse = search_window_size;
    matched_string = '';
    if (lookahead_buffer_size < 1)
        j_reverse = j_reverse + lookahead_buffer_size - 1;
        lookahead_buffer_size = 1;
    end
    current_idx_position = position;
    for j = lookahead_buffer_size:position-1
       % If any string is matched, Flag = 1
       if(input(current_idx_position) == input(j)) 
           flag = 1;
           [matched_idx, matched_position] = match(input, current_idx_position, j);
           % Find max length
           if(strlength(matched_idx) > strlength(matched_string))
                matched_string = matched_idx;   
                position = matched_position;
                matched_offset = j_reverse;
           end
       end
       j_reverse = j_reverse - 1;
    end
    % Flag = 0 occurs, if there is no any matched string 
    if(flag==0)   
        % Put next unmatched string and flag to dictionary
        dict = [dict, strcat('(', string(flag), ',', input(position), ')')]; 
        flag_dict = [flag_dict, 0];
        offset_dict = [offset_dict, 0];
        strLenght_dict = [strLenght_dict, 0];
        % Next unmatced string
        string_dict = [string_dict, input(position)];  
        position = position+1;
        continue
    end
    % Add variables into dictionary
    dict = [dict, strcat('(', string(flag), ',', string(matched_offset), ',', string(strlength(matched_string)), ')')]; %Next matched matrix that is put in the dictionary    
    flag_dict = [flag_dict, 1];
    offset_dict = [offset_dict, matched_offset];
    strLenght_dict = [strLenght_dict, strlength(matched_string)];
    flag = 0;
end

 
function [matched_idx, matched_position] = match(input, k, l)
    str = '';
    % Put together matching symbols
    while(input(k) == input(l))
        str = strcat(str, input(k));  
        k = k + 1;
        l = l + 1;
        % Stop if cursor exceeds input length
        if(k > length(input) || l > length(input)) 
            break
        end
     end
    matched_idx = str;
    matched_position = k;
end

end