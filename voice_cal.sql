CREATE PROCEDURE voice_cal()
BEGIN
	DECLARE pv_subscriber_id number(10);
	DECLARE pv_plan_type VARCHAR(20);
	DECLARE pv_voice_time INT;
	DECLARE pv_free_voice_min INT;
	DECLARE pv_rate_per_min decimal(6,2);
	DECLARE pv_voice_bill DECIMAL(6,2);
	DECLARE pv_count INT;

	DECLARE calc_cursor CURSOR FOR
		select t.subscriber_id,t.plan_type,(CAST(EXTRACT(HOUR FROM t.voice_time) AS INT ))*60+(cast(extract(minute from t.voice_time )as int))
		,p.free_voice_min,p.rate_per_min 
		from cr_Slipstream_Telecom.cr_transaction t , cr_Slipstream_Telecom.cr_plan_master p
		where t.plan_type = p.plan_type;

	OPEN calc_cursor;
		FETCH calc_cursor into pv_subscriber_id,pv_plan_type,pv_voice_time,
			pv_free_voice_min,pv_rate_per_min;
		calc_Loop:
		WHILE(SQLCODE=0) DO
 			IF pv_voice_time <> 0 then
 				SET pv_count=(select count(subscriber_id) FROM cr_Slipstream_Telecom.cr_bill where subscriber_id=pv_subscriber_id);
 				IF  pv_count <> 0 and pv_voice_time > pv_free_voice_min then
					UPDATE cr_Slipstream_Telecom.cr_bill
  					SET voice_bill=voice_bill+((pv_voice_time-pv_free_voice_min)*pv_rate_per_min)
  					where subscriber_id=pv_subscriber_id;
  				ELSE
  					SET pv_voice_bill=((pv_voice_time-pv_free_voice_min)*pv_rate_per_min);
  					INSERT INTO cr_Slipstream_Telecom.cr_bill(subscriber_id,voice_bill) values(pv_subscriber_id,pv_voice_bill);
  				END IF;
 			END IF; 
 			FETCH calc_cursor into pv_subscriber_id,pv_plan_type,pv_voice_time,pv_free_voice_min,pv_rate_per_min;

		END WHILE;
	CLOSE calc_cursor;
END;






