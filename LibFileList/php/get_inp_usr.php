<?php   
	include('connect_db.php');

	$list = $_POST['files'];
	
	for ($k=0;$k<count($list);$k++)
	{
		$FileName = str_replace(chr(10),'',trim($list[$k]));
		$query = 'SELECT B.BookId, B.Title, B.FileSize, B.FileType, B.Deleted, B.Time, B.Lang, B.N, B.KeyWords FROM libbook B, libfilename F WHERE B.BookId = F.BookID AND F.FileName = "'.$FileName.'";';
		$q_book = mysql_query($query);
		if ($q_book)
		{
			$book = mysql_fetch_row($q_book);
			include('query.php');
		}
	}
	mysql_close ($dbcnx); 
 ?>