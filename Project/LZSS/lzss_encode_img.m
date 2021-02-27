function [dict, flag_dict, offset_dict, strLenght_dict, string_dict] = lzss_encode_img(input, search_window_size)

% Initial sequences
dict = '';
flag_dict = [];
offset_dict = [];
strLenght_dict = [];
string_dict = [];
matched_string = [];
flag = 0;
position = 1;
 
while position <= length(input)
    % Lookahead buffer size
    lookahead_buffer_size = position - search_window_size;
    j_reverse = search_window_size;
    matched_string = [];
    if (lookahead_buffer_size < 1)
        j_reverse = j_reverse + lookahead_buffer_size - 1;
        lookahead_buffer_size = 1;
    end
    current_idx_position = position;
    for j = lookahead_buffer_size:position-1
       % If any string is matched, Flag = 1
       if(input(current_idx_position) == input(j))  % If any string is matched, Flag = 1 // p and j are the positions of matched strings
           flag = 1;
           [matched_idx, matched_position] = match_var(input, current_idx_position, j);
           % Find max length
           if(length(matched_idx) > length(matched_string))
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
        dict = [dict, strcat('(', string(flag), ',', string(input(position)), ')')]; 
        flag_dict = [flag_dict, 0];
        offset_dict = [offset_dict, 0];
        strLenght_dict = [strLenght_dict, 0];
        % Next unmatced string
        string_dict = [string_dict, input(position)];  
        position = position+1;
        continue
    end
    % Add variables into dictionary
    dict = [dict, strcat('(', string(flag), ',', string(matched_offset), ',', string(length(matched_string)), ')')]; %Next matched matrix that is put in the dictionary    
    flag_dict = [flag_dict, 1];
    offset_dict = [offset_dict, matched_offset];
    strLenght_dict = [strLenght_dict, length(matched_string)];
    flag = 0;
end

 
function [matched_idx, matched_position] = match_var(input, k, l)
    var = [];
    % Put together matching symbols
    while(input(k) == input(l))
        var = [var, input(k)];
        k = k + 1;
        l = l + 1;
        % Stop if cursor exceeds input length
        if(k > length(input) || l > length(input)) 
            break
        end
     end
    matched_idx = var;
    matched_position = k;
end

end