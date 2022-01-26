function data = loadH5(filename, path)
% data = loadH5(filename)
% data = loadH5(filename, path_in_file)
%
% Load data from a HDF5 file to a Matlab structure.
%
% Parameters
% ----------
%
% filename
%     Name of the file to load data from
% path_in_file : optional
%     Path to the part of the HDF5 file to load
%
%
% Author: Pauli Virtanen <pav@iki.fi>
% This script is in the Public Domain. No warranty.
%
% This version distributed in WEC-Sim has some updates.


if nargin > 1
  pathParts = regexp(path, '/', 'split');
else
  path = '';
  pathParts = [];
end

loc = H5F.open(filename, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
try
  data = loadOne(loc, pathParts, path);
  H5F.close(loc);
catch exc
  H5F.close(loc);
  rethrow(exc);
end


function data = loadOne(loc, pathParts, fullPath)
% Load a record recursively.

while ~isempty(pathParts) && strcmp(pathParts{1}, '')
  pathParts = pathParts(2:end);
end

data = struct();

num_objs = H5G.get_num_objs(loc);

% 
% Load groups and datasets
%
for j_item = 0:num_objs-1
  objtype = H5G.get_objtype_by_idx(loc, j_item);
  objname = H5G.get_objname_by_idx(loc, j_item);

  % objtype index 
  objtype = objtype+1;
  
  if objtype == 1
    % Group
    name = regexprep(objname, '.*/', '');
  
    if isempty(pathParts) || strcmp(pathParts{1}, name)
      if ~isempty(regexp(name,'^[a-zA-Z].*','ONCE'))
	groupLoc = H5G.open(loc, name);
	try
	  subData = loadOne(groupLoc, pathParts(2:end), fullPath);
	  H5G.close(groupLoc);
	catch exc
	  H5G.close(groupLoc);
	  rethrow(exc);
	end
	if isempty(pathParts)
      data.(name) = subData;
	else
	  data = subData;
	  return
	end
      end
    end
   
  elseif objtype == 2
    % Dataset
    name = regexprep(objname, '.*/', '');
  
    if isempty(pathParts) || strcmp(pathParts{1}, name)
      if ~isempty(regexp(name,'^[a-zA-Z].*','ONCE'))
	datasetLoc = H5D.open(loc, name);
	try
	  subData = H5D.read(datasetLoc, ...
	      'H5ML_DEFAULT', 'H5S_ALL','H5S_ALL','H5P_DEFAULT');
	  H5D.close(datasetLoc);
	catch exc
	  H5D.close(datasetLoc);
	  rethrow(exc);
	end
	
	subData = fixData(subData);
	
	if isempty(pathParts)
      data.(name) = subData;
	else
	  data = subData;
	  return
	end
      end
    end
  end
end

% Check that we managed to load something if path walking is in progress
if ~isempty(pathParts)
  error('Path "%s" not found in the HDF5 file', fullPath);
end


function data = fixData(data)
% Fix some common types of data to more friendly form.

if isstruct(data)
  fields = fieldnames(data);
  if length(fields) == 2 && strcmp(fields{1}, 'r') && strcmp(fields{2}, 'i')
    if isnumeric(data.r) && isnumeric(data.i)
      data = data.r + 1j*data.i;
    end
  end
end

if isnumeric(data) && ndims(data) > 1
  % permute dimensions
  data = permute(data, fliplr(1:ndims(data)));
end
