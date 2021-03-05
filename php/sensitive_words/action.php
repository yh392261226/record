<?php
/**
 * 敏感词过滤功能
 *
 *
 *
 */

$data = [];
$sensitive_words = file_exists('sensitive_words.php') ? include('sensitive_words.php') : [];
$search = array_keys($sensitive_words);
$replace = array_values($sensitive_words);
$start = implode(explode(' ', microtime()));
echo $start . "\n";
echo str_replace($search, $replace, '李洪志穿着裤衩去嫖娼') . "\n"; //这个方法比下面的方法快一倍
// echo strtr('孙晋美官僚主义日烂邵松高', $sensitive_words) . "\n";
$end = implode(explode(' ', microtime()));
echo $end . "\n";
echo "\n";