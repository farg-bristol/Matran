classdef AnalysisData < mni.bulk.BulkData
    %AnalysisData Describes a bulk dat entry which specifies data for a
    %finite element analysis.
    %    
    % Valid Bulk Data Types:
    %   - 'AERO'    
    %   - 'EIGR' 
    %   - 'EIGRL'
    %   - 'FLUTTER'
    %   - 'FREQ1'
    %   - 'RANDPS'
    %   - 'MKAERO1'
    
    methods % construction
        function obj = AnalysisData(varargin)
            
            %Initialise the bulk data sets
            addBulkDataSet(obj, 'AERO', ...
                'BulkProps'  , {'ACSID', 'VELOCITY', 'REFC', 'RHOREF', 'SYMXZ', 'SYMXY'}, ...
                'PropTypes'  , {'i'    , 'r'       , 'r'   , 'r'     , 'r'    , 'r'    }, ...
                'PropDefault', {0      , 0         , 0     , 0       , 0      , 0      }, ...
                'AttrList'   , {'VELOCITY', {'nonnegative'}, 'REFC', {'nonnegative'}, 'RHOREF', {'nonnegative'}, ...
                'SYMXZ', {'integer'}, 'SYMXY', {'integer'}}, ...
                'Connections', {'ACSID', 'mni.bulk.CoordSystem', 'AeroCoordSys'});
            addBulkDataSet(obj, 'EIGR', ...
                'BulkProps'  , {'SID', 'METHOD', 'F1', 'F2', 'NE', 'ND', 'NORM', 'G', 'C'}, ...
                'PropTypes'  , {'i'  , 'c'     , 'r' , 'r' , 'i' , 'i' , 'c'   , 'i', 'i'}, ...
                'PropDefault', {''   , ''      , 0   , 0   , 0   , 0   , 'MASS', 0  , 0  }, ...    
                'IDProp'     , 'SID', ...
                'AttrList'   , {'NE', {'positive'}});            
            addBulkDataSet(obj, 'EIGRL', ...
                'BulkProps'  , {'SID', 'V1', 'V2', 'ND', 'MSGLVL', 'MAXSET', 'SHFSCL', 'NORM'}, ...
                'PropTypes'  , {'i'  , 'r' , 'r' , 'i' , 'r'     , 'r'     , 'r'     , 'c'   }, ...
                'PropDefault', {''   , 0   , 0   , 0   , 0       , 0       , 0       , 'MASS'}, ...    
                'IDProp'     , 'SID', ...
                'AttrList'   , {'MSGLVL', {'integer', 'nonnegative', '<=' 4}});         
            addBulkDataSet(obj, 'FLUTTER', ...
                'BulkProps'  , {'SID', 'METHOD', 'DENS', 'MACH', 'RFREQ', 'IMETH', 'NVALUE_OMAX', 'EPS'}, ...
                'PropTypes'  , {'i'  , 'c'     , 'i'   , 'i'   , 'i'    , 'c'    , 'i'          , 'r'}  , ...
                'PropDefault', {0    , ''      , 0     , 0     , 0      , 'l'    , 0            ,  1e-3}, ...
                'IDProp'     , 'SID', ...
                'Connections', {'DENS', 'FLFACT', 'Density', 'MACH', 'FLFACT', 'Mach', 'RFREQ', 'FLFACT', 'ReducedFreq'});
            addBulkDataSet(obj, 'FREQ1', ...
                'BulkProps'  , {'SID', 'F1', 'DF', 'NDF'}, ...
                'PropTypes'  , {'i'  , 'r' , 'r' , 'i'}  , ...
                'PropDefault', {''   , ''  , ''  , 0}    , ...                
                'AttrList'   , {'F1', {'nonnegative'}, 'DF', {'nonnegative'}});
            addBulkDataSet(obj, 'RANDPS', ...
                'BulkProps'  , {'SID', 'J', 'K', 'X', 'Y', 'TID'}, ...
                'PropTypes'  , {'i'  , 'i', 'i', 'r', 'r', 'i'}  , ...
                'PropDefault', {''   , '' , '' , 0  , 0  , ''}   , ...            
                'IDProp'     , 'SID', ...
                'Connections', {'TID', 'mni.bulk.List', 'Table'});
            addBulkDataSet(obj, 'MKAERO1', ...
                'BulkProps'  , {'M', 'K'}, ...
                'PropTypes'  , {'r', 'r'}, ...
                'PropDefault', {0  , 0}  , ...
                'PropMask'   , {'M', 8, 'K', 8}, ...
                'AttrList'   , {'M', {'nrows', 8}, 'K', {'nrows', 8}});
            varargin = parse(obj, varargin{:});
            preallocate(obj);
            
        end
    end
        
    methods % assigning data during import
        function [bulkNames, bulkData] = parseH5DataGroup(obj, h5Struct)
            %parseH5DataGroup Parse the data in the h5 data group
            %'h5Struct' and return the bulk names and data.
            
            if ~strcmp(obj.CardName, 'EIGRL')
                error('Update code for new h5 entry.');
            end
            
            %Just need to index into the 'IDENTITY' field then pass it on
            [bulkNames, bulkData, ~] = mni.bulk.BulkData.parseH5Data(h5Struct.IDENTITY);
            
        end
        function assignH5BulkData(obj, bulkNames, bulkData)
            %assignH5BulkData Assigns the object data during the import
            %from a .h5 file.
            
            prpNames   = obj.CurrentBulkDataProps;
            
            %Build the prop data
            prpData       = cell(size(prpNames));
            prpData(ismember(prpNames, bulkNames)) = bulkData(ismember(bulkNames, prpNames));
            switch obj.CardName
                case 'MKAERO1'
                    m_lab = cellstr(strcat('M', num2str((1 : 8)')))';
                    prpData{ismember(prpNames, 'M')} = ...
                        vertcat(bulkData{ismember(bulkNames, m_lab)});
                    k_lab = cellstr(strcat('K', num2str((1 : 8)')))';
                    prpData{ismember(prpNames, 'K')} = ...
                        vertcat(bulkData{ismember(bulkNames, k_lab)});
                otherwise
                    
            end
            assignH5BulkData@mni.bulk.BulkData(obj, prpNames, prpData)
            
        end
    end
    
end

