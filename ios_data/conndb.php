<?php
define('DB_USERNAME', 'root');
define('DB_PASSWORD', '');
define('DB_HOST', '127.0.0.1');
define('DB_NAME', 'upload_data');



if($_SERVER['REQUEST_METHOD']=='POST')
    $dname = $_POST['dis_name'];
    $test = $_POST['test'];
    if ($dname && $test != null)
        createDis($dname,$test);



function createDis($dname, $test)
{
    $conn = mysqli_connect(DB_HOST, DB_USERNAME, DB_PASSWORD, DB_NAME);
    if (!$conn) {die("Connection Failed.");}
    $stmt = "INSERT INTO user_upload(dis_name, test) VALUES ('".$dname."','".$test."')";
    $result = mysqli_query($conn, $stmt);
    if ($result) {
        return true;
    } else {
        return false;
    }
    $stmt->close();
}

?>