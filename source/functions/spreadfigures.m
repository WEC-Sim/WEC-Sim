function spreadfigures(handles,howtospread)
% SPREADFIGURES  Spread figures on screen.
%
% SPREADFIGURES(HANDLES) takes an array of numeric handles to figures
% and spreads the associated figures over the upper half of the screen.
%
% SPREADFIGURES(HANDLES,HOWTOSPREAD) takes an array of numeric handles
% to figures and spreads the associated figures according to
% HOWTOSPREAD that can either be 'vertical', 'horizontal', or 'square'.
%
% SPREADFIGURES without an argument spreads all figures on the upper
% half of the screen.
%
% Example:  % Display the fourier approximations of a square wave:
%           x = [0:0.001:1].';
%           terms = [];
%           for idx = 1:16;
%             terms = [terms ,1/(1+2*(idx-1))*sin(4*pi*(1+2*(idx-1))*x)];
%             figure;
%             plot(x,sum(terms,2));
%           end;
%           spreadfigures;
%
% See also: CLOSE

if nargin==0
  handles = sort(get(0,'Children')); % Only spread visible figures.
  %handles = allchild(0); % If hidden figures should be spread as
  %well.
end
if nargin<=1
  howtospread = 'square';
end
if nargin ==2
  if isempty(handles)
    handles = sort(get(0,'Children'));
  end
end

nooffigs = numel(handles);
set(0,'units','pixels');
screensize = get(0,'screensize');
gridposition = [screensize(1), ...
                ceil(screensize(2)+screensize(4)*(1/4-1/10)), ...
                screensize(3), ...
                ceil(screensize(4))*3/4];

% The position array is ordered as [left bottom width height].
if strcmp(howtospread,'vertical')
  nHorzfigs = 1;
  nVertfigs = nooffigs;
elseif strcmp(howtospread,'horizontal')
  nHorzfigs = nooffigs;
  nVertfigs = 1;
elseif strcmp(howtospread,'square')
  nHorzfigs =  ceil(sqrt(nooffigs));
  nVertfigs = round(sqrt(nooffigs));
else
  error('howtospread should be one of vertical, horizontal, or square')
end


for idx=nooffigs:-1:1
  leftBottom = [gridposition(1)+mod((idx-1)*gridposition(3)/nHorzfigs,gridposition(3)), ...
                gridposition(4)*(1-1/nVertfigs)+gridposition(2)-mod(floor((idx-1)/nHorzfigs)*gridposition(4)/nVertfigs,gridposition(4))];
  figureSize = [gridposition(3)/nHorzfigs, ...
                0.75*gridposition(4)/nVertfigs];

  set(handles(idx),'position', [leftBottom figureSize])
  figure(handles(idx)); % Bring the figure to front
end

% drawnow; % Makes the figures show within program loops if platform is
         % Windows.

% end spreadfigures
