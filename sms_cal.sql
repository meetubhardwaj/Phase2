CREATE PROCEDURE SMS_cal()
BEGIN
	DECLARE pv_subscriber_id number(10);
	DECLARE pv_plan_type VARCHAR(20);
	DECLARE pv_sms_used INT;
	DECLARE pv_free_sms INT;
	DECLARE pv_sms_rate decimal;
	DECLARE pv_count INT; 
	DECLARE pv_sms_bill INT;
	DECLARE calc_cursor 

CURSOR FOR
  	select t.subscriber_id,t.plan_type,t.sms_used,p.free_sms,p.sms_rate
 	from cr_slipstream_telecom.cr_transaction t,cr_slipstream_telecom.cr_plan_master p
 	where t.plan_type=p.plan_type; 
  OPEN calc_cursor; 
  FETCH calc_cursor into pv_subscriber_id,pv_plan_type,pv_sms_used,
            pv_free_sms,pv_sms_rate; 
	calc_Loop:
  	WHILE(SQLCODE=0) DO
	-- IF pv_sms_used <> 0 then
  	SET pv_count=(select count(subscriber_id) FROM cr_Slipstream_Telecom.cr_bill 
  			where subscriber_id=pv_subscriber_id);     
  	IF  pv_count <> 0  then
      		IF pv_sms_used > pv_free_sms then
      			UPDATE cr_Slipstream_Telecom.cr_bill
      			SET sms_bill=sms_bill+(pv_sms_used-pv_free_sms)*pv_sms_rate
      			where subscriber_id=pv_subscriber_id; 
      		END IF;
     	ELSE
    		SET pv_sms_bill=((pv_sms_used-pv_free_sms)*pv_sms_rate);
    		INSERT INTO cr_Slipstream_Telecom.cr_bill(subscriber_id,sms_bill) values(pv_subscriber_id,pv_sms_bill);
 	END IF; 
 		FETCH calc_cursor into pv_subscriber_id,pv_plan_type,pv_sms_used,
            		pv_free_sms,pv_sms_rate; 
  	END WHILE;
CLOSE calc_cursor;
END;
