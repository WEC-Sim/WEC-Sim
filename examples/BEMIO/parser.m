function area = parser(varargin)

options.dofs = [1 3 5];
options.bodies = 1;

optionNames = fieldnames(options);


for i = 1:length(varargin) % check if it can start at 2 if 1 variable?
    optInds(i) = isnumeric(varargin{i});
    if optInds(i) == 1 
        i
        if any(strcmpi(varargin{i-1},optionNames))
            options.(varargin{i-1}) = varargin{i};
        else
            error('%s is not a recognized parameter name')
        end
    end
end

options