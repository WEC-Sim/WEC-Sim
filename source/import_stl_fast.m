function varargout=import_stl_fast(filename,mode)
% function to import ASCII STL files into matlab.  This update uses the
% textscan function instead of reading the file line by line, which can
% significantly reduce import times for very large STL files.
%--------------------------------------------------------------
% 
% inputs:       filename:   string 
%               mode:       integer 1 or 2, see outputs:
%
% outputs:      mode 1: [points,triangles,tri norms]
%               mode 2: [vertices, tri norms]
%
% author: Eric Trautmann, 3/31/2011 
%         etrautmann@gmail.com
%         based on code by Luigi Giaccari. 
%         future revisions will include support for binary files
%-----------------------------------------------------------------
% Ex: 
% filename = 'file.stl'     
% [p,t,tnorm] = import_stl_fast(filename,1)

if nargin<2
    mode=1;%default value
end

if ~(mode==1 || mode==2)
    error('invalid mode')
end

if nargout<3 && mode==1
    error('invalid input number /mode setting')
end
if nargout>2 && mode==2
    error('invalid input number /mode setting')
end

%open file
fid=fopen(filename, 'r'); %Open the file, assumes STL ASCII format.
if fid == -1
    error('File could not be opened, check name or path.')
end

%=====================================================

fid=fopen(filename, 'r'); %Open the file, assumes STL ASCII format.

fmt = '%*s %*s %f32 %f32 %f32 \r\n %*s %*s \r\n %*s %f32 %f32 %f32 \r\n %*s %f32 %f32 %f32 \r\n %*s %f32 %f32 %f32 \r\n %*s \r\n %*s \r\n';
C=textscan(fid, fmt, 'HeaderLines', 1);
fclose(fid);

%extract normal vectors and vertices
tnorm = cell2mat(C(1:3));
tnorm = tnorm(1:end-1,:); %strip off junk from last line

v1 = cell2mat(C(4:6));
v2 = cell2mat(C(7:9));
v3 = cell2mat(C(10:12));

if (C{4}(end)== NaN)
    v1 = v1(1:end-1,:); %strip off junk from last line
    v2 = v2(1:end-1,:); %strip off junk from last line
    v3 = v3(1:end-1,:); %strip off junk from last line
end

v_temp = [v1 v2 v3]';
v = zeros(3,numel(v_temp)/3);

v(:) = v_temp(:);
v = v';

    varargout = cell(1,nargout);
    switch mode
        case 1
            [p,t]=fv2pt(v,length(v)/3);%gets points and triangles

            varargout{1} = p;
            varargout{2} = t;
            varargout{3} = tnorm;
        case 2
            varargout{1} = v;
            varargout{2} = tnorm;
    end
end

%%
function [p,t]=fv2pt(v,fnum)

%gets points and triangle indexes given vertex and facet number
c=size(v,1);

%triangles with vertex id data
t=zeros(3,fnum);
t(:)=1:c;

%now we have to keep unique points fro vertex
[p,i,j]=unique(v,'rows'); %now v=p(j) p(i)=v;
t(:)=j(t(:));
t=t';

end