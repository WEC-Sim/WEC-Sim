function outputData = reverseDimensionOrder(inputData)
% This function reverse the order of the dimensions in data.
% Called by readBEMIOH5() to permute data into the correct format.
% 
% This required permutation is a legacy of the ``Load_H5``
% function that reordered dimensions of hydroData after reading
% 
% Parameters
% ----------
%     inputData : array 
%         Any numeric data array
% 
% Returns
% -------
%     outputData : array 
%         Input data array with the order of its dimensions reversed
% 

if isnumeric(inputData) && ndims(inputData) > 1
    outputData = permute(inputData, ndims(inputData):-1:1);
end

end
