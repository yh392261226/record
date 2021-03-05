<?php
$db = new LevelDB("/Users/json/data/data/leveldb_data/test_db");

//write
// $batch = new LevelDBWriteBatch();
// $batch->put("key1", "value1");
// $batch->put("key2", "value2");
// $batch->put("key3", "value3");
// $batch->set("key4", "value4");
// $batch->delete("key3");
// $db->write($batch);

//getall
$it = new LevelDBIterator($db); // 等同于： $it = $db->getIterator();
// while($it->valid()) {
//     if ($it->last() != $it->key()) {
//         var_dump($it->key() . '=>' . $it->current() . "\n");
//     } else {
//         break;
//     }
// }

foreach($it as $key => $val) {
    echo "{$key} => {$val} \n";
}

for($it->last(); $it->valid(); $it->prev()) {
	echo $it->key() . ' => ' . $it->current() . "\n";
}

for($i=1; $i<=4; $i++) {
    $val = $db->get('key'.$i);
    if ($val) {
        echo 'key'.$i . ' => ' . $val . "\n";
    }
}



$db->close();