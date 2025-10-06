<?php
// public/logout.php
session_start();
session_unset();
session_destroy();
header("Location: /cecom/public/index.php");
exit;
