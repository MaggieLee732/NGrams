% STOCHASTIC LANGUAGE MODELING USING N-GRAMS
% Important variables used
% nNum = which n-gram to use- either none, bigram, or trigram
% num = number of sentences the user inputs to test the test string against
% nCount = number of times the word being tested is in the correct sequence
% seenCount = number of times the word being tested has been counted

corpus = {}; % holds sentences to be tested against
nTest = 0;          
while(nTest ~= 1)         % Loop if input is not valid
    prompt = 'Please enter the type of n-gram to use (1, 2,or 3): ';
    nNum = input(prompt);
    if(nNum == 1 || nNum == 2 || nNum == 3)        % Tests if input is valid
        nTest = 1;
    else
        disp("Invalid input");
    end
end


% GETS NUMBER OF SENTENCES FROM USER
integerTest = 0;          
while(integerTest ~= 1)         % Loop if input is not integer
    prompt = 'Please enter the number of sentences (as an integer): ';
    num = input(prompt);
    if(~mod(num,1) == 1)        % Tests if input is integer
        integerTest = 1;
    else
        disp("Invalid input");
    end
end

% COLLECTS SENTENCES FROM USER AND ADDS EXTRA SPECES BASED ON N-GRAM NUMBER
for i=1:num
    prompt = 'Enter sentence: '; 
    strInput = input(prompt,'s');
    str = lower(strInput);
    splitStr = strsplit(str);
    strLength = length(splitStr);
    for j=1:strLength
        corpus{i,j} = splitStr{1,j};
    end
    nextBlank = j+1;
    for y=1:nNum            % Adding blank cells at the end of matrix row
        corpus{i,nextBlank} = [];
        nextBlank = nextBlank + 1;
    end
    strLength = strLength + nNum;
    for s=1:nNum-1                    % Shifts sentence over depending on nNum
        numOfShifts = strLength -1;
        for x=numOfShifts:-1:2
            corpus{i,numOfShifts} = corpus{i,numOfShifts-1};
            numOfShifts = numOfShifts - 1;
        end
        corpus{i,s} = '0';
    end
    corpus{i,strLength} = '0';
end
disp(corpus);
[row,col] = size(corpus);


% INPUT FOR SENTENCE TO TEST
prompt = 'Enter sentence to be tested: ';
strInput = input(prompt, 's');
str = lower(strInput);
strTest = strsplit(str);
strLength = length(strTest);

nextBlank = strLength+1;
for y=1:nNum            % Adding blank cells at the end of matrix row
    strTest{1,nextBlank} = [];
    nextBlank = nextBlank + 1;
end

strLength = strLength + nNum;
for s=1:nNum-1                    % Shifts sentence over depending on nNum
    numOfShifts = strLength -1;
    for x=numOfShifts:-1:2
        strTest{1,numOfShifts} = strTest{1,numOfShifts-1};
        numOfShifts = numOfShifts - 1;
    end
    strTest{1,s} = '0';
end
strTest{1,strLength} = '0';
disp(strTest);

nCount = zeros(1,strLength); % holds count of times the n amount of words are in order
seenCount = zeros(1,strLength); %holds count of word being tested

% LOOP THROUGH ENTIRE CORPUS
for i=nNum:strLength             % Loop for words in strTest, start at 2 because already checked first word
    for j=1:num                 % Loop for number of sentences 
        for y=nNum:col             % Loop for number of words in each sentence
            if strcmp(strTest(1,i), corpus(j,y))    % Test if a single word matches
                if nNum == 1
                    seenCount(1,i) = seenCount(1,i) + 1;
                    nCount(1,i) = nCount(1,i) + 1;
                end
                if nNum == 2            % If the type is 2, then add 1 to seenCount and test previous word
                    seenCount(1,i) = seenCount(1,i) + 1;
                    if strcmp(strTest(1,i-1), corpus(j,y-1)) % If Previous word matches, add 1 to nCount;
                        nCount(1,i) = nCount(1,i) + 1;
                    end
                end
                if nNum == 3 && (strcmp(strTest(1,i-1), corpus(j,y-1))) % Test if type is 3 and if previous word matches                
                    seenCount(1,i) = seenCount(1,i) + 1;
                    if strcmp(strTest(1,i-2), corpus(j,y-2))
                        nCount(1,i) = nCount(1,i) + 1;
                    end
                end
            end
        end
    end
end
disp("n: " + nCount);
disp("s: " + seenCount);
for i=nNum:strLength            % Divide nGram count with times seen
    if nCount(1,i) ~= 0
        nCount(1,i) = nCount(1,i) / seenCount(1,i);
    end
end
probability = 1;
for i=nNum:strLength            % Multiplies probbility of each word to get total probability
    probability = probability * nCount(1,i);
end
disp("The probability of the sentence occuring is: " + probability);