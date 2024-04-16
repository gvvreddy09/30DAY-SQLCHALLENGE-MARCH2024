create table Day_Indicator
(
	Product_ID 		varchar(10),	
	Day_Indicator 	varchar(7),
	Dates			date
);
insert into Day_Indicator values ('AP755', '1010101', STR_TO_DATE('04-Mar-2024','%d-%b-%Y'));
insert into Day_Indicator values ('AP755', '1010101', STR_TO_DATE('05-Mar-2024','%d-%b-%Y'));
insert into Day_Indicator values ('AP755', '1010101', STR_TO_DATE('06-Mar-2024','%d-%b-%Y'));
insert into Day_Indicator values ('AP755', '1010101', STR_TO_DATE('07-Mar-2024','%d-%b-%Y'));
insert into Day_Indicator values ('AP755', '1010101', STR_TO_DATE('08-Mar-2024','%d-%b-%Y'));
insert into Day_Indicator values ('AP755', '1010101', STR_TO_DATE('09-Mar-2024','%d-%b-%Y'));
insert into Day_Indicator values ('AP755', '1010101', STR_TO_DATE('10-Mar-2024','%d-%b-%Y'));
insert into Day_Indicator values ('XQ802', '1000110', STR_TO_DATE('04-Mar-2024','%d-%b-%Y'));
insert into Day_Indicator values ('XQ802', '1000110', STR_TO_DATE('05-Mar-2024','%d-%b-%Y'));
insert into Day_Indicator values ('XQ802', '1000110', STR_TO_DATE('06-Mar-2024','%d-%b-%Y'));
insert into Day_Indicator values ('XQ802', '1000110', STR_TO_DATE('07-Mar-2024','%d-%b-%Y'));
insert into Day_Indicator values ('XQ802', '1000110', STR_TO_DATE('08-Mar-2024','%d-%b-%Y'));
insert into Day_Indicator values ('XQ802', '1000110', STR_TO_DATE('09-Mar-2024','%d-%b-%Y'));
insert into Day_Indicator values ('XQ802', '1000110', STR_TO_DATE('10-Mar-2024','%d-%b-%Y'));

SELECT Product_ID, Day_Indicator, Dates FROM (
	SELECT *,
		CASE 
		WHEN SUBSTRING(Day_Indicator, WEEKDAY(dates) + 1, 1) = '1' THEN 1 ELSE 0
		END AS temp
	FROM day_indicator
) AS temp_table
WHERE temp = 1;
