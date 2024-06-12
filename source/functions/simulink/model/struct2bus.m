% struct2bus(s, BusName)
%
% Converts the structure s to a Simulink Bus Object with name BusName
function struct2bus(s, BusName)
sfields = fieldnames(s);

% Loop through the structure
for i = 1:length(sfields)
    
    % Create BusElement for each field
    elems(i) = Simulink.BusElement;
    elems(i).Name = sfields{i};
    elems(i).Dimensions = size(s.(sfields{i}));

    if isstruct(s.(sfields{i}))
        if contains(sfields{i},'hf')
            subBusName = [BusName '_hf'];
        else
            subBusName = [BusName '_' sfields{i}];
        end
        struct2bus(s.(sfields{i}), subBusName);
        elems(i).DataType = ['Bus: ' subBusName];
    else
        elems(i).DataType = class(s.(sfields{i}));
    end

    elems(i).SampleTime = -1;
    elems(i).Complexity = 'real';
    elems(i).SamplingMode = 'Sample based';
    
end

% Create main fields of Bus Object and generate Bus Object in the base
% workspace.
BusObject = Simulink.Bus;
BusObject.HeaderFile = '';
BusObject.Description = sprintf('');
BusObject.Elements = elems;
assignin('base', BusName, BusObject);
