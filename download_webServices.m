%
%
function download_webServices(NET,STA,LOC,YEAR,DDD,CHA_E,CHA_N,CHA_Z)

% if exist(STA,'dir') ~= 7;
%     mkdir(STA);
%     fprintf('%s directory created\n',STA);
% end
directory_check = sprintf('./%s/%s/mseed',NET,STA);
if exist(directory_check,'dir') ~=7;
    mkdir(directory_check);
    fprintf('%s directory created\n',directory_check);
end
%  DDD = datevec2doy([YEAR,MONTH,DAY,0,0,0])
%         for STA = {'N54A','M54A','MCWV'} %'N54A','M54A','MCWV'
%             STA=char(STA);
%             if(STA=='M54A')
%                 NET='TA';
%                 LOC='--';
%                 CHA_E='BHE';
%                 CHA_N='BHN';
%                 CHA_Z='BHZ';
%             end
%             if(STA=='N54A')
%                 NET='TA';
%                 LOC='--';
%                 CHA_E='BHE';
%                 CHA_N='BHN';
%                 CHA_Z='BHZ';
%             end
%             if(STA=='MCWV')
%                 NET='US';
%                 LOC='00';
%                 CHA_E='BH1';
%                 CHA_N='BH2';
%                 CHA_Z='BHZ';
%             end


%% Obligitory fix for US network name change

if strcmp(NET,'US') == 1
    
    time = doy2date(DDD,YEAR);
    change_time = datenum('2011-05-02 00:00:00');
    if strcmp(CHA_E,'BHE') == 1
        if time > change_time
            CHA_E = 'BH1';
        end;
    end
    if strcmp(CHA_N,'BHN') == 1
        if time > change_time;
            CHA_N = 'BH2';
        end
    end
    if strcmp(CHA_E,'BH1') == 1
        if time < change_time;
            CHA_E = 'BHE';
        end
    end
    if strcmp(CHA_N,'BH2') == 1
        if time < change_time;
            CHA_N = 'BHN';
        end
    end
end
%% END OF NONSENSE










ymd=ord2date([YEAR DDD]);
MONTH=ymd(2);
DAY=ymd(3);
START=[num2str(YEAR),'-',num2str(MONTH,'%02d'),'-',num2str(DAY,'%02d'),'T00:00:00.000000'];
END=[num2str(YEAR),'-',num2str(MONTH,'%02d'),'-',num2str(DAY,'%02d'),'T23:59:59.999999'];
['http://service.iris.edu/fdsnws/dataselect/1/query?net=',NET,'&sta=',STA,'&loc=',LOC,'&cha=',CHA_E,'&start=',START,'&end=',END]
if exist([NET,'/',STA,'/mseed/',STA,'.',CHA_E,'.',num2str(YEAR),'.',num2str(DDD,'%03d')],'file') == 0 && check_uptime(STA,NET,CHA_E,LOC,doy2date(DDD,YEAR)) == 1
    try
        %%%Try to download data.
        urlwrite(['http://service.iris.edu/fdsnws/dataselect/1/query?net=',NET,...
            '&sta=',STA,'&loc=',LOC,'&cha=',CHA_E,'&start=',START,'&end=',END],...
            [NET,'/',STA,'/mseed/',STA,'.',CHA_E,'.',num2str(YEAR),'.',num2str(DDD,'%03d')]);
    catch exception
        disp([CHA_E ' did not download'])
    end
end
if exist([NET,'/',STA,'/mseed/',STA,'.',CHA_N,'.',num2str(YEAR),'.',num2str(DDD,'%03d')],'file') == 0 && check_uptime(STA,NET,CHA_N,LOC,doy2date(DDD,YEAR)) == 1
    try
        urlwrite(['http://service.iris.edu/fdsnws/dataselect/1/query?net=',NET,...
            '&sta=',STA,'&loc=',LOC,'&cha=',CHA_N,'&start=',START,'&end=',END],...
            [NET,'/',STA,'/mseed/',STA,'.',CHA_N,'.',num2str(YEAR),'.',num2str(DDD,'%03d')]);
    catch exception
        disp([CHA_N ' did not download'])
    end
end
if exist([NET,'/',STA,'/mseed/',STA,'.',CHA_Z,'.',num2str(YEAR),'.',num2str(DDD,'%03d')],'file') == 0 && check_uptime(STA,NET,CHA_Z,LOC,doy2date(DDD,YEAR)) == 1
    try
        urlwrite(['http://service.iris.edu/fdsnws/dataselect/1/query?net=',NET,...
            '&sta=',STA,'&loc=',LOC,'&cha=',CHA_Z,'&start=',START,'&end=',END],...
            [NET,'/',STA,'/mseed/',STA,'.',CHA_Z,'.',num2str(YEAR),'.',num2str(DDD,'%03d')]);
    catch exception
        disp([CHA_Z ' did not download'])
    end
end
end











