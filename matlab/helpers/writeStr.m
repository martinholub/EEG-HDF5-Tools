% Writes a string dataset to the specified HDF5 file.
%
%   >> writeStr(fileId, dataset, value)
%
% Input:
%
%   fileId            
%                     The file id.
%   dataset           
%                     The path of the dataset.
%
%   value             
%                     The value of the dataset.
%

function writeStr(fileId, dataset, value)
if isempty(value)
    [fileType, spaceId] = constructEmptyStr();
    datasetId = H5D.create(fileId, dataset, fileType, spaceId, ...
        'H5P_DEFAULT');
elseif all(size(value) > 1)
valueType = H5T.copy('H5T_FORTRAN_S1');
dims = size(value);
flippedDims = fliplr(dims);
spaceId = H5S.create_simple(ndims(value),flippedDims, []);
datasetId = H5D.create(fileId, dataset, valueType, spaceId, ...
    'H5P_DEFAULT');
H5D.write(datasetId, valueType, 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT', ...
    value);
else
    [fileType, memType, spaceId] = constructNonEmptyStr(value);
    datasetId = H5D.create(fileId, dataset, fileType, spaceId, ...
        'H5P_DEFAULT');
    H5D.write(datasetId, memType, 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT', ...
        value);
end
H5D.close(datasetId);
H5S.close(spaceId);

    function [fileType, spaceId] = constructEmptyStr()
        % Constructs the type and space for a empty string
        fileType = H5T.copy('H5T_FORTRAN_S1');
        spaceId = H5S.create('H5S_NULL');
    end % constructEmptyStr

    function [fileType, memType, spaceId] = constructNonEmptyStr(value)
        % Constructs the type and space for a string
        fileType = H5T.copy('H5T_FORTRAN_S1');
        H5T.set_size(fileType, numel(value));
        memType = H5T.copy ('H5T_C_S1');
        H5T.set_size (memType, numel(value))
        spaceId = H5S.create('H5S_SCALAR');
    end % constructNonEmptyStr

end % writeStr