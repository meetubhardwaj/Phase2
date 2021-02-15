CREATE PROCEDURE dataConsumed_cal()
BEGIN
	DECLARE pv_subscriber_id number(10);
	DECLARE pv_plan_type VARCHAR(20);
	DECLARE pv_data_consumed number(10);
	DECLARE pv_data_rate_per_kb decimal(6,2);
	DECLARE pv_monthly_charges INT;
	DECLARE pv_data_bill DECIMAL(6,2);
	DECLARE pv_count INT;

	DECLARE calc_cursor CURSOR FOR
		select t.subscriber_id,t.plan_type,t.data_consumed,p.data_rate_per_kb
		from cr_Slipstream_Telecom.cr_transaction t , cr_Slipstream_Telecom.cr_plan_master p
		where t.plan_type = p.plan_type;

	OPEN calc_cursor;
		FETCH calc_cursor into pv_subscriber_id,pv_plan_type,pv_data_consumed,
			pv_data_rate_per_kb;
		calc_Loop:
		WHILE(SQLCODE=0) DO
 			IF pv_data_consumed <> 0 then
 				SET pv_count=(select count(subscriber_id) FROM cr_slipstream_telecom.cr_bill where subscriber_id=pv_subscriber_id);
 				IF  pv_count <> 0 then
					UPDATE cr_slipstream_telecom.cr_bill
  					SET data_bill=data_bill+(pv_data_consumed*pv_data_rate_per_kb)
  					where subscriber_id=pv_subscriber_id;
  				ELSE
  					SET pv_data_bill=(pv_data_consumed*pv_data_rate_per_kb);
  					INSERT INTO cr_slipstream_telecom.cr_bill(subscriber_id,data_bill) values(pv_subscriber_id,pv_data_bill);
  				END IF;
 			END IF; 
 			FETCH calc_cursor into pv_subscriber_id,pv_plan_type,pv_data_consumed,pv_data_rate_per_kb;

		END WHILE;
	CLOSE calc_cursor;
END; 





