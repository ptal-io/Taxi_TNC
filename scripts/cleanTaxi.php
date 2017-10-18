<?php


	$handle = fopen($argv[1], "r");
	$out = fopen($argv[2],"w");

	if ($handle) {
	    while (($line = fgets($handle)) !== false) {
	        $f = str_replace("|","",trim(substr($line,0,42))) . "|";
	        $f .= str_replace("|","",trim(substr($line,42,257))) . "|";
	        $f .= str_replace("|","",trim(substr($line,257,257))) . "|";
	        $f .= str_replace("|","",trim(substr($line,257*2,257))) . "|";
	        $f .= str_replace("|","",trim(substr($line,257*3,257))) . "|";
	        $f .= str_replace("|","",trim(substr($line,257*4,257))) . "|";
	        $f .= str_replace("|","",trim(substr($line,257*5,257))) . "|";
	        $f .= str_replace("|","",trim(substr($line,257*6,257))) . "|";
	        $f .= str_replace("|","",trim(substr($line,257*7,257))) . "|";
	        $f .= str_replace("|","",trim(substr($line,257*8,257))) . "|";
	        $f .= str_replace("|","",trim(substr($line,257*9,257))) . "|";
	        $f .= str_replace("|","",trim(substr($line,257*10,257))) . "|";
	        $f .= str_replace("|","",trim(substr($line,257*11,257))) . "|";
	        $f .= str_replace("|","",trim(substr($line,257*12,257))) . "|";
	        $f .= str_replace("|","",trim(substr($line,257*13,257))) . "|";
	        $f .= str_replace("|","",trim(substr($line,257*14,257))) . "|";
	        $f .= str_replace("|","",trim(substr($line,257*15,257))) . "|";
	        $f .= str_replace("|","",trim(substr($line,257*16,257))) . "|";
	        $f .= str_replace("|","",trim(substr($line,257*17,257))) . "|";
               // $f .= str_replace("|","",trim(substr($line,257*18,257))) . "|";

                // PICKUP
                $f .= str_replace("|","",trim(substr($line,4668,42))) . "|";
                $f .= str_replace("|","",trim(substr($line,4710,42))) . "|";
                $f .= str_replace("|","",trim(substr($line,4752,257))) . "|";

                // DROPOFF
                $f .= str_replace("|","",trim(substr($line,5009,42))) . "|";
                $f .= str_replace("|","",trim(substr($line,5051,42))) . "|";
                $f .= str_replace("|","",trim(substr($line,5093,257))) . "|";

                // AIRPORT / PU / DO
                $f .= str_replace("|","",trim(substr($line,5350,9))) . "|";
                $f .= str_replace("|","",trim(substr($line,5359,19))) . "|";
                $f .= str_replace("|","",trim(substr($line,5378,19)));
                //$a = explode("|",$f);
                //echo count($a) . "\n";
                fwrite($out, $f."\n");
            }

            fclose($handle);
        } else {
            echo "error";
        }
        fclose($out);
        //echo $cnt . "\n";
?>
