<?php
    function hex2str($hex){
        $str = "";
        for($i = 2; $i < strlen($hex); $i += 2)
            $str .= chr(hexdec(substr($hex, $i, 2)));
        return $str;
    }

    $reliz = $argv[1];
    $position = $argv[2];

	$files = scandir("public/cert_create/records");

    $is_in = FALSE;
    $n_rec = -1;
    for($i = 0; $i < count($files); $i++)
	{
		$pieces = explode("_", $files[$i]);
		$pos = intval(explode(".", $pieces[1])[0]);
		$rel = intval(substr($pieces[0], 3));
        if($pos == $position and $rel == $reliz)
        {
			$handle = fopen("public/cert_create/records/" . $files[$i], "r");
			$record = fgetcsv($handle);

            $is_in = TRUE;
            $n_rec = $i;

            $machine_name = $record[0];
            $firm_proc = $record[1];
            $proc_name = $record[2];
            $firm_acc = $record[3];
            $acc_name = $record[4];
            $network_name = $record[5];
            $uni = $record[6];
            $division = $record[7];
            $testpeak = $record[9];
            $reliz_name = $record[11];
            $reliz_type = $reсord[12];
            $year = $record[13];

			fclose($handle);

            break;
        }
	}
?>

<?php
    if($argv[3] == FALSE or $is_in == FALSE)
    {
        $servername = 'localhost';
        $resu = 'Cert_BKZnkqHw';
        $drowssap = 'c8qP4LdH';
        $dbname = 'new_octoshell';

        $conn = pg_connect("host=" . $servername . " dbname=" . $dbname . " user=" . $resu . " password=" . $drowssap);

    	pg_query("SET NAMES 'utf8'");

    	//Edition ID
        $result = pg_query("SELECT id FROM top50_benchmarks WHERE name_eng LIKE '%" . $reliz . "%'");
        $reliz_id = pg_fetch_all($result)[0]["id"];
        pg_free_result($result);

        //Machine ID
        $result = pg_query("SELECT machine_id FROM top50_benchmark_results WHERE benchmark_id =" . $reliz_id . " AND result = " . $position);
        $id = pg_fetch_all($result)[0]["machine_id"];
        pg_free_result($result);

        //Linpack result
        $result = pg_query("SELECT result FROM top50_benchmark_results WHERE benchmark_id = 27" . " AND machine_id = " . $id);
        $testpeak = pg_fetch_all($result)[0]["result"];
        pg_free_result($result);

        //Machine name, division name
        $result = pg_query("SELECT name, org_id FROM top50_machines where id = " . $id);
        $row = pg_fetch_all($result);
        $machine_name = $row[0]["name"];
		$division_id = $row[0]["org_id"];
        pg_free_result($result);

        $result = pg_query("SELECT name FROM top50_organizations where id = " . $division_id);
        $division = pg_fetch_all($result)[0]["name"];
        pg_free_result($result);

        //University name
        $result = pg_query("SELECT prim_obj_id FROM top50_relations where sec_obj_id = " . $division_id);
        $uni_id = pg_fetch_all($result)[0]["prim_obj_id"];
        pg_free_result($result);

        $result = pg_query("SELECT name FROM top50_organizations where id = " . $uni_id);
        $uni = pg_fetch_all($result)[0]["name"];
        pg_free_result($result);

        //Communication network
        $result = pg_query("SELECT dict_elem_id FROM top50_attribute_val_dicts where attr_id = 10 and obj_id = " . $id);
		$comm_id = pg_fetch_all($result)[0]["dict_elem_id"];
        pg_free_result($result);

		$result = pg_query("SELECT name FROM top50_dictionary_elems where id = " . $comm_id);
		$network_name = pg_fetch_all($result)[0]["name"];
        pg_free_result($result);
        
        //Processors, accelerators
        $result = pg_query("SELECT sec_obj_id FROM top50_relations where prim_obj_id = " . $id);
        $nodes = pg_fetch_all($result);
        pg_free_result($result);

        $proc_name = [];
        $acc_name = [];
        $firm_proc = "";
        $firm_acc = "";
        for($i = 0; $i < count($nodes); $i++){
        	$result = pg_query("SELECT sec_obj_id FROM top50_relations where prim_obj_id = " . $nodes[$i]["sec_obj_id"]);
        	$procs = pg_fetch_all($result);
        	pg_free_result($result);

        	for($j = 0; $j < count($procs); $j++){
        		$result = pg_query("SELECT type_id FROM top50_objects where id = " . $procs[$j]["sec_obj_id"]);
	        	$type = pg_fetch_all($result)[0]["type_id"];
	        	pg_free_result($result);

	        	if($type == 6){
                    $result = pg_query("SELECT value FROM top50_attribute_val_dbvals where attr_id = 25 AND obj_id = " . $procs[$j]["sec_obj_id"]);
                    $freq = pg_fetch_all($result)[0]["value"];
                    pg_free_result($result);  

					$result = pg_query("SELECT dict_elem_id FROM top50_attribute_val_dicts where attr_id = 15 AND obj_id = " . $procs[$j]["sec_obj_id"]);
		        	$proc_id = pg_fetch_all($result)[0]["dict_elem_id"];
		        	pg_free_result($result);

					$result = pg_query("SELECT name FROM top50_dictionary_elems where id = " . $proc_id);
		        	if(in_array(pg_fetch_all($result)[0]["name"], $proc_name) == FALSE)
		        		$proc_name[] = pg_fetch_all($result)[0]["name"] . " " . doubleval(hex2str($freq))/1000 . " ГГц";
		        	pg_free_result($result);

		        	if($firm_proc == ""){
						$result = pg_query("SELECT dict_elem_id FROM top50_attribute_val_dicts where attr_id = 20 AND obj_id = " . $procs[$j]["sec_obj_id"]);
			        	$firm_proc_id = pg_fetch_all($result)[0]["dict_elem_id"];
			        	pg_free_result($result);

						$result = pg_query("SELECT name FROM top50_dictionary_elems where id = " . $firm_proc_id);
			        	$firm_proc = pg_fetch_all($result)[0]["name"];
			        	pg_free_result($result);          		
		        	}		        	
		     	}	     

		     	if($type == 7){
					$result = pg_query("SELECT dict_elem_id FROM top50_attribute_val_dicts where attr_id = 16 AND obj_id = " . $procs[$j]["sec_obj_id"]);
		        	$acc_id = pg_fetch_all($result)[0]["dict_elem_id"];
		        	pg_free_result($result);

					$result = pg_query("SELECT name FROM top50_dictionary_elems where id = " . $acc_id);
		        	if(in_array(pg_fetch_all($result)[0]["name"], $acc_name) == FALSE)
		        		$acc_name[] = pg_fetch_all($result)[0]["name"];
		        	pg_free_result($result);		    

                    if($firm_acc == ""){
                        $result = pg_query("SELECT dict_elem_id FROM top50_attribute_val_dicts where attr_id = 21 AND obj_id = " . $procs[$j]["sec_obj_id"]);
                        $firm_acc_id = pg_fetch_all($result)[0]["dict_elem_id"];
                        pg_free_result($result);

                        $result = pg_query("SELECT name FROM top50_dictionary_elems where id = " . $firm_acc_id);
                        $firm_acc = pg_fetch_all($result)[0]["name"];
                        pg_free_result($result);                        
                    }    	
		     	}

		     	if($type == 8){
					$result = pg_query("SELECT dict_elem_id FROM top50_attribute_val_dicts where attr_id = 22 AND obj_id = " . $procs[$j]["sec_obj_id"]);
		        	$proc_id = pg_fetch_all($result)[0]["dict_elem_id"];
		        	pg_free_result($result);

					$result = pg_query("SELECT name FROM top50_dictionary_elems where id = " . $proc_id);
		        	if(in_array(pg_fetch_all($result)[0]["name"], $acc_name) == FALSE)
		        		$acc_name[] = pg_fetch_all($result)[0]["name"];
		        	pg_free_result($result);

                    if($firm_acc == ""){
                        $result = pg_query("SELECT dict_elem_id FROM top50_attribute_val_dicts where attr_id = 23 AND obj_id = " . $procs[$j]["sec_obj_id"]);
                        $firm_acc_id = pg_fetch_all($result)[0]["dict_elem_id"];
                        pg_free_result($result);

                        $result = pg_query("SELECT name FROM top50_dictionary_elems where id = " . $firm_acc_id);
                        $firm_acc = pg_fetch_all($result)[0]["name"];
                        pg_free_result($result);                        
                    }       		        	
		     	}	     	        	
        	}
        }

        $proc_name = join("@", $proc_name);
        $acc_name = join("@", $acc_name);

        pg_close($conn);
    }

    $handle = fopen("public/cert_create/medium/step2", "w");
    fwrite($handle, $machine_name . "\n");
    fwrite($handle, $firm_proc . "\n");
    fwrite($handle, $proc_name . "\n");
    fwrite($handle, $firm_acc . "\n");
    fwrite($handle, $acc_name . "\n");
    fwrite($handle, $network_name . "\n");
    fwrite($handle, $uni . "\n");
    fwrite($handle, $division . "\n");
    fwrite($handle, $testpeak . "\n");
    fwrite($handle, $reliz_name . "\n");
    fwrite($handle, $reliz_type . "\n");
    fwrite($handle, $year . "\n");
    fclose($handle);
?>