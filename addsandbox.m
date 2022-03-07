function addsandbox()
%rmsandbox  Uninstall sandbox
%
%  See also: rmsandbox, 
%            modify_sandbox_path
%
%  Copyright 2016 The MathWorks, Inc.
%
% Edits Christopher Szczyglowski, University of Bristol 2020
%   - Refactored most of the code into 'modify_sandbox_path'
% Edits Fintan Healy, University of Bristol 2022
%   - Refactored to use settings so sandboxes aren't loaded multiple times

name = 'Matran';
s = settings;
[calling_dir,~,~] = fileparts(mfilename('fullpath'));
if hasGroup(s,"InstalledSandboxes")
    if hasGroup(s.InstalledSandboxes,name)
        installed_dir = s.InstalledSandboxes.(name).dir;
        warning("Package %s is already installed @ %s \n so installation will be skipped @ %s",...
            name,installed_dir,calling_dir);
        return
    else
        addGroup(s.InstalledSandboxes,name);
        addSetting(s.InstalledSandboxes.(name),'dir');
        s.InstalledSandboxes.(name).dir = calling_dir;
        addSetting(s.InstalledSandboxes.name,'ver');
        s.InstalledSandboxes.(name).ver = string(fileread('version.txt')); 
    end
end
sub_directory_to_add = ["tbx" , "unit_testing" , "examples"];
modify_sandbox_path(sub_directory_to_add, 'add');
end