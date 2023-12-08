<?php
    $host = "localhost";
    $dbname = "id21630265_coupon";
    $user = "id21630265_patrick";
    $pass = "Ptrk@1556#";

    try {
        $db = new PDO("mysql:host=$host;dbname=$dbname", $user, $pass);
        echo "connected";
    } catch (PDOException $e) {
        echo "Error: ".$e->getMessage();
    }
?>
