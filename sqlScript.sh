#!/bin/bash

startDateTime="2022-06-01 06:29:26"
endDateTime="2022-07-01 00:30:30"
START=1
END=1000
count=0
pstr="[=======================================================================]"
teacherID=("63772b80-23ce-4a57-9bc3-a9f222e819e5" "74cb44c8-6396-4b0c-aca6-87614a63fee0" "dea793cf-618f-4a54-86a9-7235689f3a0f")
learnerID=("ee327182-01aa-4331-a967-af8ac5fbb56f" "0d1321ff-9c9b-497f-97ad-24e3e01d9784" "685011c3-4730-4398-bb4d-6d33b3347c9a" "deff9a68-73cb-4718-b663-7e8947e726dd")
#Script to run automated sql queries 
#Here c is number of Lessons
for (( c=$START; c<=$END; c++ ))
do	
	#Prepare sql query
	selectedlearnerID=${learnerID[ $RANDOM % ${#learnerID[@]} ]}
	selectedteacherID=${teacherID[ $RANDOM % ${#teacherID[@]} ]}
	companyId=$(( $RANDOM % 3 + 1 ))
	cDate=$(date '+%Y-%m-%d %H:%M:%S')
	UUID=$(uuidgen)
	stop_flg=0
	delete_flg=0
	roomId="room-z${c}"
	urlRecord="https://room.com/room/${c}"
	startDateTime=$(date '+%Y-%m-%d %H:%M:%S' -d "$startDateTime 12 hour"); 
	endDateTime=$(date '+%Y-%m-%d %H:%M:%S' -d "$endDateTime 12 hour"); 
	note="Lorem Ipsum is simply dummy text of the printing and typesetting for lesson ${c}"
	payment_id=1
	approval_flg=1
	cancel_flg=0
	title="Test Notice ${c}"
	notice="Lorem Ipsum is simply dummy text of the printing and typesetting for Note ${c} Date ${startDateTime}"
	relaese_flg=1
	targetnumber=$(( $RANDOM % 3 ))
	feed_back="This is a feedbak for learner for lesson ${c}"
	number=$(( $RANDOM % 2 + 1 ))
	((count++)) 
	
	if [ "$selectedlearnerID" = "ee327182-01aa-4331-a967-af8ac5fbb56f" ]; then
		companyId=1
	elif [ "$selectedlearnerID" == "0d1321ff-9c9b-497f-97ad-24e3e01d9784" ];
	then
		companyId=2
	elif [ "$selectedlearnerID" == "685011c3-4730-4398-bb4d-6d33b3347c9a" ];
	then
		companyId=2
	elif [ "$selectedlearnerID" == "deff9a68-73cb-4718-b663-7e8947e726dd" ];
	then
		companyId=3
	else
		companyId=$companyId
	fi

	
	#Display a progress bar indicator
	pd=$(( $c * 73 / $END ))
	printf "\r%3d.%1d%% %.${pd}s" $(( $c * 100 / $END )) $(( ($c * 1000 / $END) % 10 )) $pstr

	#mysql DB connection 
	./mysql.config 2>/dev/null<<EOF
	
	#sql query
	INSERT INTO t_lesson VALUES($companyId, "${c}", "${cDate}", "${UUID}", "${cDate}", "${UUID}", $stop_flg, $delete_flg, 
		"${roomId}", "${urlRecord}", "${startDateTime}", "${endDateTime}", "${note}", $payment_id, $approval_flg, $cancel_flg);

	INSERT INTO t_lesson_teacher VALUES($companyId, "${c}", "${selectedteacherID}", "${endDateTime}", "${cDate}", "${UUID}", "${cDate}","${UUID}", $stop_flg, $delete_flg,"${roomId}");
	
	INSERT INTO t_notice VALUES("${c}", "${cDate}", "${UUID}", "${cDate}", "${UUID}", $stop_flg, $delete_flg, "${targetnumber}", "${title}", "${notice}", "${startDateTime}", "${endDateTime}", $relaese_flg, 0);
	
EOF
	for (( i=1; i<=$number; i++ ))
	do
	./mysql.config 2>/dev/null<<EOF
	INSERT INTO t_lesson_learner VALUES ($companyId, "${c}", "$selectedlearnerID", "$cDate", "$UUID", "$cDate", "$UUID", $stop_flg, $delete_flg, "$roomId", "$feed_back");
EOF
	selectedlearnerID=${learnerID[ $RANDOM % ${#learnerID[@]} ]}
	done
done
echo "${count} Lessons Created"
echo "End of script"