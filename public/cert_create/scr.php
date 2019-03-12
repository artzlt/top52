<?php
  $record = array($argv[1], 
      $argv[2], 
      $argv[3], 
      $argv[4],
      $argv[5], 
      $argv[6], 
      $argv[7],
      $argv[8],
      $argv[9],
      $argv[10],
      $argv[11],
      $argv[12],
      $argv[13],
      $argv[14]);
  
  $reliz_file = $argv[11];
  $position_file = $argv[9];
  
  if($reliz_file < 10)
    $reliz_file = "0" . $reliz_file;
  if($position_file < 10)
    $position_file = "0" . $position_file;
  
  $handle = fopen("public/cert_create/records/rev" . $reliz_file . "_" . $position_file . ".csv", "w");
  fputcsv($handle, $record);
  fclose($handle);
?>    

<?php
        //Путь к папке с временными файлами
        //(если не указан, то файлы будут хранится в системной временной папке)

        $tmp_dir='';
        //генерируем пути к временным svg, ps и pdf файлам
        $tmp_svg_file=tempnam($tmp_dir,"");
        $tmp_ps_file=tempnam($tmp_dir,"");
        $pdf_file="public/cert_create/certificates/" . 'rev' . $reliz_file . '_' . $position_file . '.pdf';

        /* Шаблонизатор FastTemplate */
        include("public/cert_create/cls_fast_template.php");
        $tpl = new FastTemplate("public/cert_create/templates");

    try{

    /* Блок с получаемыми для шаблонизации данными */
    /* ........................... */
                $machine_name = $argv[1];
                if($machine_name !== "" and $machine_name !== " "){
                    if(strpos($machine_name, '"') === FALSE)
                        $machine_name = '"' . $machine_name . '"';
                    $machine_name = $machine_name . " ";
                }
                $sys_name = $machine_name;
                
                $testpeak = doubleval($argv[10])/1000000;
                if($testpeak < 1000)
                    $result = round($testpeak, 2) . " Tflop/s";
                else
                    $result = round($testpeak/1000, 2) . " Pflop/s";
                
                $pro_name = $argv[2] . " " . str_replace("@", ", ", $argv[3]);
                if($argv[4] !== " " and $argv[4] !== "")
                    $pro_name .= ", ускорителей " . $argv[4] . " " . str_replace("@", ", ", $argv[5]); 

                $div_name = $argv[8];
                if($div_name == '' or $div_name == ' '){
                    $div_name = '<br>';
                    $uni_name = $argv[7]."</br>";
                }
                else 
                    $uni_name = $argv[7];
                //$div_name = '<xs:element name="Summa" type="N15.2" default="/n"/>';
                $net_name = $argv[6];             
                $pos = $argv[9];
                $red = $argv[11];
                $r_name =  '"' . $argv[12] . '"';
                $date = $argv[14];
                $conf_type = $argv[13];
          
    /* ........................... */
    /* формируем имя результрующего файла в виде User_name.pdf */

      //  $pdf_file_name=$user_name.'kek.pdf';
          $pdf_file_name= 'rev' . $reliz_file . '_' . $position_file . '.pdf';

    /* обработка шаблона и получение результрующего файла */

                $tpl->define(array('svg'   => "template.svg"));
                $tpl->assign(array( 'system_name' => $sys_name,
                                    'p_name'    => $pro_name,
                                    'n_name'      => $net_name,
                                    'pod_name'      => $div_name,
                                    'u_namee'      => $uni_name,
                                    'position'      => $pos,
                                    't_result'      => $result,
                                    'red'      => $red,
                                    'name_of_red'      => $r_name,
                                    'date'      => $date,
                                    'test'      => $testpeak,
                                    'conf_type'      => $conf_type

                            ));
                $tpl->parse('SVG', 'svg');

                //сохраням полученный svg файл
                $tpl->FastWrite('SVG',$tmp_svg_file);

                //производим конвертацию svg-файла средствами inkscape'а в ps-файл
                //Ключи
                //    -T     — служит для преобразования текста в кривые (для нормальной поддержки шрифтов)
                //    -P    — указывает на необходимость преобразования в PostScript-файл
                system("inkscape -T $tmp_svg_file -P $tmp_ps_file" ,$success);
                //    system(

                   //в случае неудачного выполнения преобразования формируем исключение
                if($success!=0)
                    throw new Exception("Ошибка формирования ps-файла.");

                //преобразуем ps-файл в pdf с помощью утилиты ps2pdf

                //Ключи
                //    -dUseFlateCompression=true    — устанавливает использование компрессии
                //    -dPDFSETTINGS=/printer        — устанавливает оптимизацию для печати
                system("ps2pdf -dUseFlateCompression=true -dPDFSETTINGS=/printer $tmp_ps_file $pdf_file",$success);

                //в случае неудачного выполнения преобразования формируем исключение
                if($success!=0)
                    throw new Exception("Ошибка формирования pdf-файла.");

                //заголовок о том, что будем оправлять pdf-файл
                //header('Content-type: application/pdf');

                // Называться будет как $pdf_file_name
                //header('Content-Disposition: attachment; filename="'.$pdf_file_name.'"');

/*
 header('Content-type: application/pdf');
 header('Content-Disposition: inline; filename="' . $pdf_file_name . '"');
 header('Content-Transfer-Encoding: binary');
 header('Accept-Ranges: bytes');
*/
                // передаем сгенерированный файл
                //readfile($pdf_file);
               // flush();
              //echo($tmp_pdf_file);
                //echo($tmp_pdf_file);

                //удаляем временные файлы
                @unlink($tmp_svg);
                @unlink($tmp_ps_file);

    }catch(Exception $e){
        /* Если где-то произошла ошибка, то сообщаем об этом */
       // $tpl->define( array('error'   => «error.tpl»));
      //  $tpl->assign('ERROR',$e->getMessage());

      //  $tpl->parse('ERROR', 'error');
        $tpl->FastPrint('ERROR');
    }
?>
