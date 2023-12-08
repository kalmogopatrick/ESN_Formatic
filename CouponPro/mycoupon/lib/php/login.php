<?php
    include "connection.php";

    $email = $_POST["email"];
    $pass = sha1($_POST["pass"]);

    try {
        if(isset($name,$email,$pass)){
            $req = $db->prepare("SELECT * FROM users WHERE email=? AND password=?");
            $req->execute(array($email, $pass));
            $exist = $req->rowCount();
            if($exist == 1){
                $array = $req->fetch();
               $msg = "success connection";
               $succes = 1;
            }else{
                $msg = "email or password incorrect";
                $succes = 0;
            }
        }else{
            $succes = 0;
            $msg = "error empty data";
        }
       
    } catch (PDOException $e) {
        $succes = 0;
        $msg = "Error: ".$e->getMessage();
    }
    echo json_encode([
        "data"=>[
            $msg,
            $succes,
            $array
        ]
    ]);
?>