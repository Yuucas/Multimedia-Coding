function [dict, offset_dict, maxLength_dict, uint8_dict] = lz77_encode_img(input, searchWindow, lookaheadBuffer)
             
% % Find search buffer range
searchBuffer = searchWindow - lookaheadBuffer;
% Index of search range
searchBuffer_range = [1, searchBuffer];

% Initial sequences
dict = '';
uint8_dict = [];
maxLength_dict = [];
offset_dict = [];

% Initialize the first unmatched characters
for cursorPosition = searchBuffer_range(1):searchBuffer_range(2)
    dict = strcat(dict, '(', string(0), ',', string(0), ',', string(input(cursorPosition)), ')');
    uint8_dict = [uint8_dict, input(cursorPosition)];
    maxLength_dict = [maxLength_dict, 0];
    offset_dict = [offset_dict, 0];
end

% Initial cursor position
cursorPosition = searchBuffer + 1; 

while cursorPosition <= length(input)
    
    % Initial max length and offset
    maxLength = 0;
    offset = 0;
    
    for j = searchBuffer_range(2):-1:searchBuffer_range(1)
        % Find offset of input in search buffer
        if input(j) == input(cursorPosition)
            current_offset = searchBuffer_range(2) - j + 1;
            matchedStringLength = getLength(input, current_offset, cursorPosition);
            % Find max length 
            if maxLength < matchedStringLength
                maxLength = matchedStringLength;
                offset = current_offset;
            end
        end
    end
    % Move cursor to next position
    cursorPosition = cursorPosition + maxLength + 1;
    % Change search buffer range
    searchBuffer_range = searchBuffer_range + maxLength + 1;
    % Add variables into triplets and add triplets into dictionary
    dict = strcat(dict, '(', string(offset), ',', string(maxLength),',', string(input(cursorPosition-1)), ')');
    % Add the character after matching sequences
    uint8_dict = [uint8_dict, input(cursorPosition-1)];
    % Add the max length of matches
    maxLength_dict = [maxLength_dict, maxLength];
    % Add the offset of matches
    offset_dict = [offset_dict, offset];
end

function matchedStringLength = getLength(input, offset, cursor)
% Find the length of matched string in sequence, starting from an offset in search buffer and cursor position

% convert offset to index in sequence
idx = cursor - offset;
% Initial length
matchedStringLength = 0; 

while (matchedStringLength + cursor < length(input)) && (input(idx + matchedStringLength) == input(cursor + matchedStringLength))
    matchedStringLength = matchedStringLength + 1;
end
end

end