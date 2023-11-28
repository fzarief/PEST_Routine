%
%  R1=simulateR(name,SI,PlotOn);
%
%   Simulate response
%
%    name = 'Afifah';
%    SI = 50 ;
%    PlotOn = true;
%
%   copyright Petro Julkunen, UEF Applied Physics, 2019
%

function [R1,B]=simulateR(name,SI,PlotOn)

if nargin<2
    error('requires two inputs: name as character string and SI as value between 0 and 100');
end
if ~ischar(name)
    error('first input needs to be a string');
end
if nargin<3
    PlotOn=false;
end


max_S=sum(double(name)-80);
B(1)=sum(double(name(1:floor(numel(name)/2)))-80)./max_S*100;
B(2)=numel(name)*0.015*B(1);

R1=sim_resp(B(1),B(2),SI);

if PlotOn
    plot(0:100,normcdf(0:100, B(1), B(2)),'k'), hold on
    plot(SI,R1,'ro','MarkerSize',10,'MarkerFaceColor','r')
end

if R1==1
    fprintf("RESPONSE\nReal threshold = %0.2f%%\n",B(1))
else
    fprintf("NO RESPONSE\nReal threshold = %0.2f%%\n",B(1))
end

end


%%%%
function resp=sim_resp(t,s,m)

r = rand(1,1);
pc = normcdf(m,t,s);
if pc < r
    resp = 0;
else
    resp = 1;

end
end