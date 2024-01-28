<?php

	//	iTunes 7 Artwork Finder - Proof of Concept
	//	by Collin Allen
	//	collin [at] command-tab.com
	
	//	Test URL (thanks Ethereal):
	//	http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZSearch.woa/wa/coverArtMatch?an=The%20Fray&gn=Soundtrack&pn=Grey's%20Anatomy%2C%20Vol.%202%20(TV%20Soundtrack%20Version)
	
	$fp = fsockopen("ax.phobos.apple.com.edgesuite.net", 80, $errno, $errstr, 30);
	if (!$fp)
	{
		echo "$errstr ($errno)<br />\n";
	}
	else
	{
		$out = "GET /WebObjects/MZSearch.woa/wa/coverArtMatch?an=Metallica&pn=Master%20of%20Puppets HTTP/1.1\r\n"; // urlencode() the data you send 
		$out .= "X-Apple-Tz: -21600\r\n"; // Tz = time zone?
		$out .= "X-Apple-Store-Front: 143441\r\n"; // perhaps the storefront is which country iTunes Store I use?
		$out .= "User-Agent: iTunes/7.0 (Macintosh; U; PPC Mac OS X 10.4.7)\r\n"; // it's PHP in disguise!
		$out .= "Accept-Language: en-us, en;q=0.50\r\n";
		//$out .= "X-Apple-Validation: 7291CA13-3F379CF3EAFB4F6263482A025DC3F67F\r\n";  // encryption? hashing?
		
		// If you change artist data in the GET request and don't change the X-Apple-Validation string, the request doesn't go through.
		// The iTunes Store apparently doesn't require this header, though.  Disabling it, as I did above, and changing the artist data still works.  Hmm.
		
		$out .= "Accept-Encoding: gzip, x-aes-cbc\r\n";
		$out .= "Connection: close\r\n";
		$out .= "Host: ax.phobos.apple.com.edgesuite.net\r\n\r\n";
		
		fwrite($fp, $out); // send the request
		while (!feof($fp)) 
		{
			$buf .= fgets($fp, 128); // accumulate return data
		}
		fclose($fp);
		
		$string_rightbefore_gzipped = "Connection: close\r\n\r\n";
		$pos = strpos($buf,$string_rightbefore_gzipped); // find the string right before the gzipped content
		
		$gzstart = $pos + strlen($string_rightbefore_gzipped) + 10;		// some math to get the positioning right.  the +10 came from the only comment:
																		// http://us3.php.net/manual/en/function.gzinflate.php#33810
																		
		$gzd = substr($buf,$gzstart); // slice out the gzipped data
		
		echo gzinflate($gzd); // print the decompressed data containing the link to the artwork
	}

?>