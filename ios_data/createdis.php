<?php

    //creating response array
    $response = array();
    
    if($_SERVER['REQUEST_METHOD']=='POST'){
        
        //getting values
        $dname = $_POST['dis_name'];
        $imgname = $_POST['img_name'];
        $test = $_POST['test'];

        
        //including the db operation file
        require_once 'DbOperation.php';
        
        $db = new DbOperation();
        
        //inserting values
        if($db->createDis($dname,$imgname,$test)){
            $response['error']=false;
            $response['message']='Dis added successfully';
        }else{
            
            $response['error']=true;
            $response['message']='Could not add dis';
        }
        
    }else{
        $response['error']=true;
        $response['message']='You are not authorized';
    }
    echo json_encode($response);
?>