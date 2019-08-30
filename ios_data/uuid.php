<?
function create_uuid(){
    $str = md5(uniqid(mt_rand(), true));  
    return $str;
}
?>