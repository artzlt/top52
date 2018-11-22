    <?php
        //Путь к папке с временными файлами
        //(если не указан, то файлы будут хранится в системной временной папке)

        $tmp_dir='';
        //генерируем пути к временным svg, ps и pdf файлам
        $tmp_svg_file=tempnam($tmp_dir,"");
        $tmp_ps_file=tempnam($tmp_dir,"");
        $tmp_pdf_file=tempnam($tmp_dir,"");

        /* Шаблонизатор FastTemplate */
        include("cls_fast_template.php");
        $tpl = new FastTemplate("templates");

    try{

    /* Блок с получаемыми для шаблонизации данными */
    /* ........................... */
          $file = $_FILES['user_files']['tmp_name'];
          $handle = fopen($file, 'r');
	  
          $zip = new ZipArchive();
          $zip->open("files.zip", ZipArchive::CREATE);

          while(($data = fgetcsv($handle)) !== FALSE)
          {
                $sys_name = $data[0];
                $pro_name = $data[1];
                $net_name = $data[2];
                $uni_name = $data[3];
                $pos = $data[4];
                $result = $data[5];
                $red = $data[6];
                $r_name = $data[7];
                $date = $data[8];
          
    /* ........................... */
    /* формируем имя результрующего файла в виде User_name.pdf */

      //  $pdf_file_name=$user_name.'kek.pdf';
          $pdf_file_name='kek.pdf';

    /* обработка шаблона и получение результрующего файла */

                $tpl->define(array('svg'   => "template.svg"));
                $tpl->assign(array( 'system_name' => $sys_name,
                                    'p_name'    => $pro_name,
                                    'n_name'      => $net_name,
                                    'u_name'      => $uni_name,
                                    'position'      => $pos,
                                    't_result'      => $result,
                                    'red'      => $red,
                                    'name_of_red'      => $r_name,
                                    'date'      => $date
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
                system("ps2pdf -dUseFlateCompression=true -dPDFSETTINGS=/printer $tmp_ps_file $tmp_pdf_file",$success);

                //в случае неудачного выполнения преобразования формируем исключение
                if($success!=0)
                    throw new Exception("Ошибка формирования pdf-файла.");

                $zip->addFile($pdf_file_name);
                //удаляем временные файлы
                @unlink($tmp_svg);
                @unlink($tmp_ps_file);
                @unlink($tmp_pdf_file);
}
                $zip->close();

                //заголовок о том, что будем оправлять pdf-файл
                header('Content-type: application/zip');

                // Называться будет как $pdf_file_name
                header('Content-Disposition: attachment; filename=files.zip');
                header('Content-length: ' . filesize('files.zip'));

/*
 header('Content-type: application/pdf');
 header('Content-Disposition: inline; filename="' . $pdf_file_name . '"');
 header('Content-Transfer-Encoding: binary');
 header('Accept-Ranges: bytes');
*/
                // передаем сгенерированный файл
                readfile("files.zip");
               // flush();
		//echo($tmp_pdf_file);
                //echo($tmp_pdf_file);

    }catch(Exception $e){
        /* Если где-то произошла ошибка, то сообщаем об этом */
       // $tpl->define( array('error'   => «error.tpl»));
      //  $tpl->assign('ERROR',$e->getMessage());

      //  $tpl->parse('ERROR', 'error');
        $tpl->FastPrint('ERROR');
    }
    ?>
