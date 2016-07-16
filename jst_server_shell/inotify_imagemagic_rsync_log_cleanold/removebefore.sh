#!/bin/bash
#Json杨浩

tools_bin=/data/picture_action/tools.sh #正式

if [ -f $tools_bin ]; then
        . $tools_bin patch
    else
            exit 1
        fi


/bin/rm -f $inotify_path$(date "+%Y%m%d" -d '2 day ago')*.*
/bin/rm -rf ${tmp_path}bak_$(date "+%Y%m%d" -d '4 day ago')*
/bin/rm -rf ${tmp_path}bak_ai_$(date "+%Y%m%d" -d '4 day ago')*
