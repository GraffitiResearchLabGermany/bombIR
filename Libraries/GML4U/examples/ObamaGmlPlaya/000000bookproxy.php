<?php

		// 000000book	
		$host = "000000book.com";
		$port = "80";
				
		// Timeout for opening socket
		$timeout = 30;

		// Timeout for reading from socket
		$read_timeout = 15;  // Seconds
		
		// Defaults to random
	    $path = "/random.gml";
		
		if (isset($_GET['api'])) {
	        if ($_GET['api'] == "latest") {
	        	$path = "/latest.gml";
	        } 
		}
		else if (isset($_GET['tagid'])) {
      // Check digits only
			if (preg_match("/^[0-9]+$/", $_GET['tagid'])) {
        		$path = "/data/".$_GET['tagid'].".gml";
        	}		
		}

		$request = "GET " . $path . " HTTP/1.0\r\n" . "Host: " . $host . "\r\n";
		$request = $request . "User-Agent: GML4U Processing library's proxy\r\n";
		$request = $request . "Connection: Close\r\n";
		$request = $request . "\r\n";
		
		$fp = @fsockopen($host, $port, $errno, $errstr, $timeout);
		
		if ($fp != false)
		{
			fwrite($fp, $request);
	
			socket_set_timeout($fp,$read_timeout);
			
			$isBody = false;
            $headers = "";
			
			while (!feof($fp))
			{
				$content = fgets($fp, 1024);
				if ($isBody)
				{
					echo $content;
				}
				else
				{
          $headers .= $content;
					if ($content == "\r\n")
					{
						$isBody = true;
            //header($headers);
					}

				}	
			}
			fclose($fp);
		}

?>
