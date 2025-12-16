function encrypted_message = crypt(message, key_matrix, codepoints, pad_char)
% CRYPT Encrypts or decrypts a message using modular arithmetic given a key
% matrix
%
% encrypted_message = CRYPT(message, key_matrix, codepoints) 
%
% encrypted_message = CRYPT(message, key_matrix, codepoints, pad_char)
% uses an optional pad_char to pad the message.
%
% Inputs:
%   message - the message to encrypt/decrypt as a char array
%   key_matrix - the encryption/decryption key as an Fp matrix
%   codepoints - valid codepoints as a row vector
%   pad_char - optional padding character to reshape the message into an array (default: ' ')
%
% Output:
%   encrypted_message - the encrypted/decrypted message as a char array row
%   vector
%
% Example:
%   load ascii_codepoints;
%   p = numel(codepoints);
%   K = Fp(randi([0 p-1],30,25),p);
%   L = inv(K'*K)*K';
%   encrypted = crypt('Hello World', K, codepoints);
%   decrypted = crypt(encrypted, L, codepoints);

% Honors EA1
% Homework Program 7
%
% Name: Branovacki, Alek
% Date: 11/5/2025

% Step 1: arguments block and input validation
arguments 
    message char
    key_matrix Fp
    codepoints {mustBeNumeric, mustBeVector}
    pad_char char = ' '
end

message_codes = uint16(message); % get the characters of the message
if ~all(ismember(message_codes, codepoints)) % make sure that all characters in the message are valid codepoints
    error('Message contains invalid codepoints not in the codepoints vector');
end

p = modulus(key_matrix); % get the modulus of the key matrix
if numel(codepoints) ~= p % make sure that the number of elements in the codepoints vector is equal to the modulus of the Fp key matrix,
    error('Number of codepoints must equal the modulus of the key matrix');
end

% Step 2: reshaping the message into an array having the same number of rows as the number of columns of the key matrix
num_rows = size(key_matrix, 2); % get the number of columns
message_length = length(message); % get the message length
padded_length = ceil(message_length / num_rows) * num_rows; % calculate the desired length of the padded message   
if message_length < padded_length % pad the message if necessary
    num_pads = padded_length - message_length; % calculate how many pads needed
    message = [message, repmat(pad_char, 1, num_pads)]; % add the padding to the message with repmat (a more versatile version of the pad function)
end
M = uint16(message); % Convert to uint16 codepoints
M = reshape(M, num_rows, []);  % reshape into matrix to have the correct number of rows
    
% Step 3: convert message codepoints to integers in range [0, p-1]
C = arrayfun(@(x) find(codepoints == x, 1) - 1, M); % find the index of each codepoint with arrayfun and an anonymous function
C = Fp(C, p); % convert to Fp type so we can use modular arithmetic
    
% Step 4: multiply the converted vector by the key matrix and reshape into a row vector
encrypted_codes = key_matrix * C; % multiply by key matrix
encrypted_codes = reshape(encrypted_codes, 1, []); % reshape into row vector
    
% Step 5: convert encrypted codes back into codepoints
encrypted_codepoints = codepoints(uint16(encrypted_codes) + 1); % from assignment document
    
% Step 6: convert back to character array using char
encrypted_message = char(encrypted_codepoints);
    
end

% Testing the code
% 
% load solzhenitsyn % loads a char array into the variable txt
% load ascii_codepoints; % or use hack_codepoints for the Hack font
% p = numel(codepoints);
% K = Fp(randi([0 p-1],30,25),p);
% L = inv(K'*K)*K';
% w = crypt(txt,K,codepoints) % you should see the encrypted message
% v = crypt(w,L,codepoints) % you should see the original message
% 
% w =
% 
%     ']Z%aW*Q8;*2O{Uw
%      `3,th^#rN\99tGe@[nrKOCg%}wo*_[u7vUCW['Y}E^tevS<|IY]_g"PtT?MH
%      vMI|lwwL~8%kn5=MSg9cF<^E@U/n6AcD|X|AogAY\tso5 ^'#&\xtyE@*g`
%      lkFFa[)imu.]a
%      /d*FOb{'!6QZWfOYE"-D@MRiSDdt!rwhdIK[XQ8/jl]sH-
%      ,{wIy7cx$_O>66UC_h=m41ZP&E:*N,~`dAM-#&T}(W\QvvB XfJW1k{GK;w]IXH8BT623+4N<Jrs-nS#eh~Ts4|xjXcBVsM
%      kUiAo8,wbv="u7boay*MU^qk
%      Q2tK%5ZMfMIE-F\T/V^nl9I
%      ~/\c0_BIR3Wt{vJQ(ckUxH1mf 6
%      \Xw^Z?)A+3]>^K`'~ }1d4o0sFhr}z#z\"g%+=RVC:xF@ ^N'wiX
%      o'!;e``^\HEzaZ5ApcbHRk<$VA]:y<ZKX^{CyA%' JwkY#J_/H'#APnW_VnI%Rm=
%      &-}g3hv?]lnNcY?a?5(6k!3mhw%q**<I5y0/#Q*zu>7.
%      d98L^b16qD}E$PvC=pc;/TTI9?xu|otgHS}F]t&,O0Z
%      Y7{_GJP}+Wjz[%{PDX F%nQ65iHQxc@~n $fkMd>dF%Fii_%I*S)en?s4jbp[-Q}.#x kIYU?s@+=.wlM2Rv
%      [9}?K<mtA;`3qrOuOlX
%      \R|tf$J5y_*bTuhGj5eb+$~zP2!q0b`Ifm0Np(^VYpv
%      pIsY_uksx_6e(UfFIg re?|d}fr7q[Wi]JBc*gAs*~.M,<s$+=l8a2;qCi6!@Y*a?Y)(Wq%@-VVXvqznw]=dF+8HEZc\X2I]MhK^#?0_P]O(#Oe> '
% 
% 
% v =
% 
%     'An engineer? I had grown up among engineers, and I could remember the
%      engineers of the twenties very well indeed: their open, shining intellects,
%      their free and gentle humor, their agility and breadth of thought, the ease
%      with which they shifted from one engineering field to another, and, for
%      that matter, from technology to social concerns and art.  Then, too, they
%      personified good manners and delicacy of taste; well-bred speech that
%      flowed evenly and was free of uncultured words; one of them might play a
%      musical instrument, another dabble in painting; and their faces always bore
%      a spiritual imprint.
% 
%      Aleksandr Solzhenitsyn, "The Gulag Archipelago," tr. Thomas Whitney
% 
%                            '