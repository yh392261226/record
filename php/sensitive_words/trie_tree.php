<?php
//基于PHP + TRIE树实现敏感词过滤算法
class TreeMap
{
    public $data;  // 节点字符
    public $children = [];  // 存放子节点引用（因为有任意个子节点，所以靠数组来存储）
    public $isEndingChar = false;  // 是否是字符串结束字符

    public function __construct($data)
    {
        $this->data = $data;
    }
}

class TrieTree
{
    /**
     * 敏感词数组
     * 
     * @var array
     * @author qpf
     */
    public $trieTreeMap = array();

    public function __construct()
    {
        $this->trieTreeMap = new TreeMap('/');
    }

    /**
     * 获取敏感词Map
     * 
     * @return array
     * @author qpf
     */
    public function getTreeMap()
    {
        return $this->trieTreeMap;
    }

    /**
     * 添加敏感词
     * 
     * @param array $txtWords
     * @author qpf
     */
    public function addWords(array $wordsList)
    {
        foreach ($wordsList as $words) {
            $trieTreeMap = $this->trieTreeMap;
            $len = mb_strlen($words);
            for ($i = 0; $i < $len; $i++) {
                $word = mb_substr($words, $i, 1);
                if(!isset($trieTreeMap->children[$word])){
                    $newNode = new TreeMap($word);
                    $trieTreeMap->children[$word] = $newNode;
                }
                $trieTreeMap = $trieTreeMap->children[$word];
            }
            $trieTreeMap->isEndingChar = true;
        }
    }

    /**
     * 查找对应敏感词
     * 
     * @param string $txt
     * @return array
     * @author qpf
     */
    public function search($txt)
    {
        $wordsList = array();
        $txtLength = mb_strlen($txt);
        for ($i = 0; $i < $txtLength; $i++) {
            $wordLength = $this->checkWord($txt, $i, $txtLength);
            if($wordLength > 0) {
                // echo $wordLength;
                $words = mb_substr($txt, $i, $wordLength);
                $wordsList[] = $words;
                $i += $wordLength - 1;
            }
        }
        return $wordsList;
    }

    /**
     * 敏感词检测
     * 
     * @param $txt
     * @param $beginIndex
     * @param $length
     * @return int
     */
    private function checkWord($txt, $beginIndex, $length)
    {
        $flag = false;
        $wordLength = 0;
        $trieTree = $this->trieTreeMap; //获取敏感词树
        for ($i = $beginIndex; $i < $length; $i++) {
            $word = mb_substr($txt, $i, 1); //检验单个字
            if (!isset($trieTree->children[$word])) { //如果树中不存在，结束        
                break;
            }
            //如果存在
            $wordLength++; 
            $trieTree = $trieTree->children[$word];
            if ($trieTree->isEndingChar === true) {  
                $flag = true;
                break;
            }
        }
        if($beginIndex > 0) {
            $flag || $wordLength = 0; //如果$flag == false  赋值$wordLenth为0
        }
        return $wordLength;
    }
    
}

$data = ['白粉', '白粉人', '白粉人嫩','不该大'];
$wordObj = new TrieTree();
$wordObj->addWords($data);

$txt = "白粉啊,白粉人，我不该大啊";
$words = $wordObj->search($txt);
print_r($words);die;
