<?php

		$servername = 'localhost';
        $resu = 'Cert_BKZnkqHw';
        $drowssap = 'c8qP4LdH';
        $dbname = 'new_octoshell';

        $conn = pg_connect("host=" . $servername . " dbname=" . $dbname . " user=" . $resu . " password=" . $drowssap);

    	pg_query("SET NAMES 'utf8'");

        $result = pg_query("SELECT COUNT(*) FROM top50_benchmarks");
        $n_relizes = pg_fetch_all($result)[0]["count"] - 1;
        pg_free_result($result);

        pg_close($conn);

        $handle = fopen("public/cert_create/medium/step1", 'w');
        fwrite($handle, $n_relizes);
        fclose($handle);
?>
