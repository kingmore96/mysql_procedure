CREATE DEFINER=`root`@`%` PROCEDURE `calTuozhanJiXiao`(
in start_time datetime,
in end_time datetime
)
BEGIN
	declare tuozhan_name varchar(255);
	declare tuozhan_mobile varchar(255);
	declare done int DEFAULT 0;
	
	DECLARE tuozhan_info CURSOR FOR 
	select name,mobile from an_tuozhan_info 
	where status = 1;
	
	DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
	
	open tuozhan_info;
	
	truncate table an_tuozhan_performance;
	
	while done <> 1 do
		FETCH next from tuozhan_info INTO tuozhan_name,tuozhan_mobile;
		call getGroudServiceData(tuozhan_name,tuozhan_mobile,start_time,end_time);
	end while;
END