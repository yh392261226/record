<?php
/**
 * Redis HSET HGET HGETALL HDEL DEL PHP多维数组用例
 * 2019-08-01
 * Json
 *
 */


$redis = new Redis();
$redis->connect('127.0.0.1', '6379');
$data = [ //模拟数据
    1 => 1,
    2 => 2,
    3 => 3,
    4 => 4,
    5 => json_encode(['a', 'b']),
    6 => json_encode(['m', 'n']),
    7 => json_encode(['p', 'q', ['v', ['t']]]),
];

//逐行插入
foreach ($data as $key => $val)
{
    $adddata[$key]['status'] = $redis->hSet('test', $key, $val);
    if ($adddata[$key]['status'] === 0) {
        $adddata[$key]['result'] = 'exists';
    //add failure because already exists!
    } elseif ($adddata[$key]['status'] === 1) {
        $adddata[$key]['result'] = 'success';
    //add success!
    } else {
        $adddata[$key]['result'] = 'failure';
        //error
    }
} unset($key, $val);
print_r($adddata) . "\n"; //打印插入结果

//删掉特定行
$deldata = $redis->HDEL('test', 4);
if ($deldata)
{
    echo "delete success! \n";
}

$result = [];
//获取全部
$getalldata = $redis->HGETALL('test');
if (!empty($getalldata) && is_array($getalldata))
{
    $result = decode_json_array($getalldata);
    error_log(var_export($result, true), 3, './result.log');
}

$result = [];
//获取单条
$getonedata = $redis->HGET('test', 7);
if ('' != trim($getonedata))
{
    $result = decode_json_array($getonedata);
    error_log(var_export($result, true), 3, './result_1.log');
}

//删除所有
$delalldata = $redis->DEL('test');
if ($delalldata)
{
    echo "delete all success ! \n";
}







/**
 * 反解多维数组中的Json
 */
function decode_json_array($data)
{
    if ('' == $data) return ;
    $result = [];
    if (is_array($data))
    {
        foreach ($data as $key => $val)
        {
            $result[$key] = decode_json_array($val, true);
        }
    }
    else
    {
        if (is_json($data))
        {
            $result = json_decode($data, true);
        }
        else
        {
            $result = $data;
        }
    }
    return $result;
}

/**
 * 验证是否为Json
*/
function is_json($string)
{
    json_decode($string);
    return (json_last_error() == JSON_ERROR_NONE);
}
