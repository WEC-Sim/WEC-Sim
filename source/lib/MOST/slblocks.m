function blkStruct = slblocks
% This function specifies that the library 'mylib'
% should appear in the Library Browser with the 
% name 'My Library'

    Browser.Library = 'MOST_Lib';
    Browser.Name = 'MOST';
    blkStruct.Browser = Browser;