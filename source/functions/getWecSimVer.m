function git_ver = getWecSimVer

ws_exe = which('wecSim');
ws_dir = fileparts(ws_exe);
git_ver_file = [ws_dir '/../.git/refs/heads/master'];
git_ver = textread(git_ver_file,'%s');