%% Converting .txt files to .mat

close all
clear
clc
%%
sub=[1:7];

addpath(genpath('C:\Users\Hashini\Google Drive\Lab work\TIBS_LABNIRS\fNIRS TIBS\'));
for i=1:length(sub)
path_file_n=['subject' num2str(sub(i)) '_TRT_Hb.txt'];
        fid = fopen(path_file_n);
        
        h_wait = waitbar(0, 'Data loading... ');
        while 1
            tline = fgetl(fid);
            nindex = find(tline == ',');
            tline(nindex) = ' ';
            [token, remain] = strtok(tline);
            if strncmp(tline, 'Time Range',10) == 1
                [token remain] = strtok(remain);
                [token remain] = strtok(remain);
                stt = str2num(token);
                [token remain] = strtok(remain);
                stp = str2num(token);
            end
            %%%%'Time(sec)'
            if strcmp(token, 'Time(sec)') == 1
                index = 1;
                while 1
                    tline2 = fgetl(fid);
                    if ischar(tline2) == 0, break, end,
                    newlabel = strrep(tline2, 'Z', '');
                    nindex = find(newlabel == ',');
                    newlabel = str2num(newlabel);
                    nirs_data.oxyData(index, :) = newlabel(1,5:3:end-2);
                    nirs_data.dxyData(index, :) = newlabel(1,6:3:end-1);
                    nirs_data.tHbData(index, :) = newlabel(1,7:3:end);
                    waitbar((newlabel(1,1)-stt)/(stp-stt), h_wait);
                    time(index,1) = newlabel(1,1);
                    index = index + 1;
                end
                break
            end
        end
        close(h_wait);
        fclose(fid);
        fs = 1./(mean(diff(time)));
        nirs_data.fs = fs;
%         set(handles.edit_fs, 'string', num2str(fs));
        nirs_data.nch = size(nirs_data.oxyData,2);
        save(['C:\Users\hashini\Google Drive\Lab work\TIBS_LABNIRS\fNIRS TIBS\Subject' num2str(sub(i)) '\nirs_hbo_data_sub' num2str(sub(i)), '_trt.mat'],'nirs_data');
end