#!/bin/bash
# Log entries willbe single line records and will  contain multiple fields
# and the fields will be separated by a vertical pipe character "|" to
# separate the fields of the record.
#
# EVENT|execname|process#|BATCH#|Test#|TimeSTAMP|Event|Specific|Fields
#
# EVENT Types
#		START Record for when the test begins
#		FINISH Record for when the test ends
#		DELTA Record that records information about the wall time of the 
#			Test - about the interval between START and FINISH
#		RATE Record that tracks information about the rate at which the processes
#			execute to insure that we are able to schedule/allocate adequate time
#			for future runs of the application
if [ -z "${__funclogger}" ]
then
	export __funclogger=1

	source func.errecho
	source func.insufficient

	function logger()
	{

		####################
		# Since the test number is a global variable stored in the file
		# system, it is passed in.  Every 20 tests, output the titles
		# for the records in the log file
		####################
		# errecho ${LINENO} ${FUNCNAME} "#5=$5"
		if [[ ! $5 =~ -*[0-9]+ ]]
		then
			mod_test_number="999999"
		else
			mod_test_number=$(expr $5 % 20)
		fi
		# errecho ${LINENO} ${FUNCNAME} "#mod_test_number=$mod_test_number"
		if [ ${mod_test_number} -eq 0 ]
		then
			####################
			# Initialize the titles
			####################
			commontitles="${commontitles}Executable|"
			commontitles="${commontitles}Process #|"
			commontitles="${commontitles}Batch #|"
			commontitles="${commontitles}Test #|"
			
			starttitles="START|${commontitles}Filesystem|"
			starttitles="${starttitles}Began Time|"
			starttitles="${starttitles}Num Processes|"
			starttitles="${starttitles}Num Nodes|"
	
			finishtitles="FINISH|${commontitles}Filesystem|"
			finishtitles="${finishtitles}Finish Time|"
			finishtitles="${finishtitles}Num Processes|"
			finishtitles="${finishtitles}Num Nodes|"
	
			deltatitles="DELTA|${commontitles}Filesystem|"
			deltatitles="${deltatitles}Duration Time|"
			deltatitles="${deltatitles}Duration Seconds|"
			deltatitles="${deltatitles}Num Processes|"
	
			ratetitles="RATE|${commontitles}Filesystem|"
			ratetitles="${ratetitles}Duration Time|"
			ratetitles="${ratetitles}Num Processes|"
			ratetitles="${ratetitles}Rate Band|"
			ratetitles="${ratetitles}Processes Per Hour|"
		fi

		####################
		# Check the initial arguments
		####################
		NUMARGS=5
		if [ $# -lt ${NUMARGS} ]
		then
			insufficient ${LINENO} ${FUNCNAME} ${NUMARGS} $@
		fi
		logevent="$1"
		logexec="$2"
		# logexec="$2"
		# logprocessnumber="$3"
		# logbatch="$4"
		# logtestnum="$5"

		logexecbase=${logexec##*/}
		upper_exec=$(echo ${logexecbase}|tr [:lower:] [:upper:])
		if [ -z "${IOR_TESTLOG}" ]
		then
			if [ -z "${IOR_TESTDIR}" ]
			then
				errecho ${LINENO} ${FUNCNAME} "Environment variable IOR_TESTDIR not set"
				errecho ${LINENO} ${FUNCNAME} "Environment variable IOR_TESTLOG not set"
				exit 1
			else
				export IOR_ETCDIR=${IOR_TESTDIR}/etc
				export IOR_TESTLOG=${IOR_ETCDIR}/${upper_exec}.testlog.txt
			fi
		fi

    case ${logevent} in
			START)	# Handle the START Log entry
				####################
				# Write the titles to the log files
				####################
				if [ ${mod_test_number} -eq 0 ]
				then
					echo "${starttitles}" >> ${IOR_TESTLOG}
				fi
				NUMSTARTARGS=9
				if [ $# -lt ${NUMSTARTARGS} ]
				then
					errecho ${LINENO} "${FUNCNAME} error in ${logevent} parameter count"
					insufficient ${LINENO} ${FUNCNAME} ${NUMSTARTARGS} $@
				fi
# 				logfilesystem="$6"
# 				logdate_began="$7"
# 				lognumprocs="$8"
# 				lognumnodes="$9"
				echo "${1}|${2}|${3}|${4}|${5}|${6}|${7}|${8}|${9}" >> ${IOR_TESTLOG}
				;;
			FINISH)	# Handle the FINISH Log entry
				if [ ${mod_test_number} -eq 0 ]
				then

				####################
				# Write the titles to the log files
				####################
					echo "${finishtitles}" >> ${IOR_TESTLOG}
				fi
				NUMFINISHARGS=9
				if [ $# -lt ${NUMFINISHARGS} ]
				then
					errecho ${LINENO} "${FUNCNAME} error in ${logevent} parameter count"
					insufficient ${LINENO} ${FUNCNAME} ${NUMFINISHARGS} $@
				fi
# 				logfilesystem="$6"
# 				logdate_finish="$7"
# 				lognumprocs="$8"
# 				lognumnodes="$9"
				echo "${1}|${2}|${3}|${4}|${5}|${6}|${7}|${8}|${9}" >> ${IOR_TESTLOG}
				;;
			DELTA)	# Handle the DELTA Log entry
				if [ ${mod_test_number} -eq 0 ]
				then
	
					####################
					# Write the titles to the log files
					####################
					echo "${deltatitles}" >> ${IOR_TESTLOG}
				fi
				NUMDELTAARGS=9
				if [ $# -lt ${NUMDELTAARGS} ]
				then
					errecho ${LINENO} "${FUNCNAME} error in ${logevent} parameter count"
					insufficient ${LINENO} ${FUNCNAME} ${NUMDELTAARGS} $@
				fi
# 				logfilesystem="$6"
# 				logdate_timedelta="$7"
# 				log_time_delta_Seconds="$8"
# 				lognumprocs="$9"
				echo "${1}|${2}|${3}|${4}|${5}|${6}|${7}|${8}|${9}" >> ${IOR_TESTLOG}
				;;
			RATE)	# Handle the RATE Log entry
				if [ ${mod_test_number} -eq 0 ]
				then
	
					####################
					# Write the titles to the log files
					####################
					echo "${ratetitles}" >> ${IOR_TESTLOG}
				fi
				NUMRATEARGS=10
				if [ $# -lt ${NUMRATEARGS} ]
				then
					errecho ${LINENO} "${FUNCNAME} error in ${logevent} parameter count"
					insufficient ${LINENO} ${FUNCNAME} ${NUMRATEARGS} $@
				fi
# 				logfilesystem=$6
# 				logdelta=$7
# 				lognumprocs=$8
# 				logroundup=$9
# 				lognewrate=$10
				echo "${1}|${2}|${3}|${4}|${5}|${6}|${7}|${8}|${9}|${10}" >> ${IOR_TESTLOG}
				;;
			\?)
				errecho ${FUNCNAME} ${LINENO} "Invalid Log Type ${logevent}"
				exit 1
				;;
    esac
	}
	export -f logger
fi # if [ -z "${__funclogger}" ]
