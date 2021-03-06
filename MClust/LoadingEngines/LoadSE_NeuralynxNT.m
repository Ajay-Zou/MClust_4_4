function [T,WV] = LoadSE_NeuralynxNT(a,b,c)

% MClust Loading engine wrapper
% [T,WV] = LoadSE_NeuralynxNT(a,b,c)

if nargin == 1
    [T,WV] = LoadSE_NeuralynxNT0(a);
elseif nargin == 3
    [T,WV] = LoadSE_NeuralynxNT0(a,b,c);
elseif nargin == 2
    % New "get" construction"
    if strcmp(a, 'get')
        switch (b)
            case 'ChannelValidity'
                T = [true false false false]; return;
            case 'ExpectedExtension'
                T = '.nse'; return;
            otherwise
                error('Unknown get condition.');
        end
    else
        error('2 argins requires "get" as the first argument.');
    end
end