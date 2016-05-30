<?php
$userlists = array(
     array(
         'ip' =>'169.55.101.148',
         'username' => 'image',
         'userpass' => 'WXKo{JdU*gc99j$',
     ),
     array(
         'ip' => '169.55.101.158',
         'username' => 'phoebe',
         'userpass' => 'xB6Qoam7hGNV2T5P',
     ),
);

function getIpByName($username, $userlists)
{
    foreach ($userlists as $key => $val)
    {
        if ($val['username'] == $username)
        {
            return $val['ip'];
        }
    }
}

echo getIpByName('phoebe', $userlists);
