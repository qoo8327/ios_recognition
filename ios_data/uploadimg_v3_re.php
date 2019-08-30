<?php
//$disname = $_POST["disname"];
$response = array();
$target_dir = "uploads_recon";
if(!file_exists($target_dir)){
    mkdir($target_dir, 0777, true);
}

$target_dir = $target_dir . "/" . basename($_FILES["file"]["name"]);

if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_dir)) {

    #$old_name = basename($_FILES["file"]["name"]);
    #$new_name = md5(uniqid(mt_rand(), true)).$old_name;
    #copy("uploads/".$old_name, "uploads/".$new_name);
    #unlink('uploads/'.$old_name);
    $command = escapeshellcmd("python clientImg.py uploads_recon/". basename( $_FILES["file"]["name"]));
    $output = shell_exec($command);
    $response["Message"] = "The file ". basename( $_FILES["file"]["name"]). " has been uploaded.";
    $response["Answer"] = $output;
    header("Content-Type: application/json");
    echo json_encode($response);


} else {

    echo json_encode([
    "Message" => "Sorry, there was an error uploading your file.",
    "Status" => "Error",
    "userId" => $_REQUEST["userId"]
    ]);

}
?>