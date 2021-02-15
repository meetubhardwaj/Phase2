bteq < create_lnd_tbl.btq
bteq < macros.btq
tbuild -f Load_lnd_cust_profile.tpt -j Load_lnd_cust_profile
tbuild -f Load_lnd_cust_stats.tpt -j Load_lnd_cust_stats
tbuild -f Load_lnd_Loyalty.tpt -j Load_lnd_Loyalty
tbuild -f Load_lnd_plan_master.tpt -j Load_lnd_plan_master

bteq < Load_stg_cust_stats.btq
bteq < Load_stg_cust_profile.btq
bteq < Load_stg_loyalty.btq
bteq < Load_stg_plan_master.btq

bteq < Load_cr_cust_stats.btq
bteq < Load_cr_cust_profile.btq
bteq < Load_cr_loyalty.btq
bteq < Load_cr_plan_master.btq

::===============================================================
:: DAY 1							=
::								=
::===============================================================
bteq < delete_voice_plan_run.btq
bteq < day1.btq 
tbuild -f update_lnd_voice_plan_run.tpt -j update_lnd_voice_plan_run -u "FileName='voice_plan_run_1.csv'"
bteq < Load_stg_voice_plan_run.btq
bteq < delete_data_plan_run.btq
tbuild -f update_lnd_data_plan_run.tpt -j update_data_plan_run -u "FileName='data_plan_run_1.csv'"
bteq < Load_stg_data_plan_run.btq
bteq < Load_cr_transaction.btq
::===============================================================
:: DAY 2							=
::								=
::===============================================================
bteq < delete_voice_plan_run.btq
bteq < day2.btq
tbuild -f update_lnd_voice_plan_run.tpt -j update_lnd_voice_plan_run -u "FileName='voice_plan_run_2.csv'"
bteq < Load_stg_voice_plan_run.btq
bteq < delete_data_plan_run.btq
tbuild -f update_lnd_data_plan_run.tpt -j update_data_plan_run -u "FileName='data_plan_run_2.csv'"
bteq < Load_stg_data_plan_run.btq
bteq < Load_cr_transaction.btq
::===============================================================
:: DAY 3							=
::								=
::===============================================================
bteq < delete_voice_plan_run.btq
bteq < day3.btq
tbuild -f update_lnd_voice_plan_run.tpt -j update_lnd_voice_plan_run -u "FileName='voice_plan_run_3.csv'"
bteq < Load_stg_voice_plan_run.btq
bteq < delete_data_plan_run.btq
tbuild -f update_lnd_data_plan_run.tpt -j update_data_plan_run -u "FileName='data_plan_run_3.csv'"
bteq < Load_stg_data_plan_run.btq
bteq < Load_cr_transaction.btq
bteq < procedures.btq

::===============================================================
:: BILL CALCULATION IS IN PROCESS...................		=
::								=
::===============================================================


bteq < call_procedures.btq

::===============================================================
:: ALL SET LOOKING GOOD ...................			=
::								=
::===============================================================





