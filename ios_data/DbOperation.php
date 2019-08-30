<?php
    
    class DbOperation
    {
        private $conn;
        
        //Constructor
        function __construct()
        {
            require_once dirname(__FILE__) . '/Config.php';
            require_once dirname(__FILE__) . '/DbConnect.php';
            // opening db connection
            $db = new DbConnect();
            $this->conn = $db->connect();
        }
        
        //Function to create a new user
        public function createDis($dname, $imgname, $test)
        {
            $stmt = $this->conn->prepare("INSERT INTO user_upload(dis_name, img_name, test) values(?, ?, ?)");
            $stmt->bind_param("sss", $dname, $imgname, $test);
            $result = $stmt->execute();
            $stmt->close();
            if ($result) {
                return true;
            } else {
                return false;
            }
        }
    
    }
?>