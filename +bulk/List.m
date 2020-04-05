classdef List < bulk.BulkData
    %List Describes a set of bulk data that can have an arbitrary number of
    %data points.
    %
    % Valid Bulk Data Types:
    %   - AEFACT
    %   - SET1
    %   - PAERO1
    %   - FLFACT
    %   - TABDMP1
    
    properties (Constant)
        ValidDampingType = {'G', 'CRIT', 'Q'};
    end
    
    methods % construction
        function obj = List(varargin)
            
            %Initialise the bulk data sets
            addBulkDataSet(obj, 'AEFACT', ...
                'BulkProps'  , {'SID', 'Di'}, ...
                'PropTypes'  , {'i'  , 'r'} , ...
                'PropDefault', {''   , '' } , ...
                'ListProp'   , {'Di'});
            addBulkDataSet(obj, 'SET1', ...
                'BulkProps'  , {'SID', 'Gi'}, ...
                'PropTypes'  , {'i'  , 'r'} , ...
                'PropDefault', {''   , '' } , ...
                'ListProp'   , {'Gi'}, ...
                'Connections', {'Gi', 'bulk.Node', 'Nodes'});
            %Initialise the bulk data sets
            addBulkDataSet(obj, 'PAERO1'   , ...
                'BulkProps'  , {'PID', 'Bi'}, ...
                'PropTypes'  , {'i'  , 'i'} , ...
                'PropDefault', {''   , ''}  , ...
                'ListProp'   , {'Bi'});
            addBulkDataSet(obj, 'FLFACT', ...
                'BulkProps'  , {'SID', 'Fi'}, ...
                'PropTypes'  , {'i'  , 'r' }, ...
                'PropDefault', {0    , 0   }, ...
                'ListProp'   , {'Fi'});
            addBulkDataSet(obj, 'TABDMP1', ...
                'BulkProps'  , {'TID', 'TYPE', 'Fi', 'Gi', 'Token'}, ...
                'PropTypes'  , {'i'  , 'c'   , 'r' , 'r' , 'c'}    , ...
                'PropDefault', {''   , 'G'   , ''  , ''  , ''}     , ...
                'ListProp'   , {'Fi', 'Gi'}               , ...
                'SetMethod'  , {'TYPE', @validateTYPE});
            
            varargin = parse(obj, varargin{:});
            preallocate(obj);
            
            
        end
    end
    
    methods % validation
        function validateTYPE(obj, val, prpName, varargin)
            val = upper(val);
            msg = sprintf(['Expected ''%s'' to be a cell array ', ...
                'of strings with each element being one of the following '  , ...
                'tokens:\n\n\t- %s\n\n'], prpName, strjoin(obj.ValidDampingType, ', '));
            assert(iscellstr(val), msg); %#ok<ISCLSTR>
            assert(all(ismember(val, obj.ValidDampingType)), msg);
            obj.TYPE = val;
            
        end
    end
    
end

