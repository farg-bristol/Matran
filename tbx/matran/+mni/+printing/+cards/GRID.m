classdef GRID < mni.printing.cards.BaseCard
    %FLUTTER_CARD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID;
        CP;
        X1;
        X2;
        X3;
        CD;
        PS;
        SEID;
    end
    
    methods
        function writeToFile(obj,fid,varargin)
            %writeToFile print DMI entry to file
            writeToFile@mni.printing.cards.BaseCard(obj,fid,varargin{:})
            p = inputParser();
            p.addRequired('ID')
            p.addRequired('X',@(x)numel(x)==3)
            p.addParameter('CP',0,@(x)x>=0)
            p.addParameter('CD',0,@(x)x>=-1)
            p.addParameter('PS','')
            p.addParameter('SEID',[],@(x)x>=0)
            p.parse(ID,X,varargin{:})
            
            obj.Name = 'GRID';
            obj.ID = p.Results.ID;
            obj.CP = p.Results.CP;
            obj.X1 = p.Results.X(1);
            obj.X2 = p.Results.X(2);
            obj.X3 = p.Results.X(3);
            obj.CD = p.Results.CD;
            obj.PS = p.Results.PS;
            obj.SEID = p.Results.SEID;            
        end
        
        function writeToFile(obj,fid)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            data = [{obj.ID},{obj.CP},{obj.X1},{obj.X2},...
                {obj.X3},{obj.CD},{obj.PS},{obj.SEID}];
            format = 'iifffisi';
            obj.fprint_nas(fid,format,data);
        end
    end
end

