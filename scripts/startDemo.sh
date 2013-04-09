#!/bin/sh

# Parse options
echo Starting Demo Script
echo 'Forward:[W]  Backward:[S] Quit:[Q]'
echo

function moveForward {
	if [ $STATE -lt 5 ]
	then
		((STATE++))
	fi
	case $STATE in
		1)
			cd ../../system/cvb
			rm dashboards/*.* 
			cd endpoints/kettle
			rm *.ktr
			cd ../..
			cd ../../cpkDemo/scripts
			cp ../cvb/dashboards/fileList.* ../../system/cvb/dashboards/.
			cp ../cvb/cvb.xml ../../system/cvb/.
			cp ../cvb/endpoints/kettle/listFiles.ktr ../../system/cvb/endpoints/kettle/.
			cp ../cvb/endpoints/kettle/_filterFirstMatch.ktr ../../system/cvb/endpoints/kettle/.
			cp ../cvb/endpoints/kettle/_validateFiles.ktr ../../system/cvb/endpoints/kettle/.
			cp ../cvb/endpoints/kettle/_getAccessSettings.ktr ../../system/cvb/endpoints/kettle/.
			cp ../cvb/endpoints/kettle/_filterCombineMatch.ktr ../../system/cvb/endpoints/kettle/.
			echo
			echo "Removed Sample Endpoints and Added File List -- Now in step $STATE"
		;;
		2)
			cp ../cvb/endpoints/kettle/getLocations.ktr ../../system/cvb/endpoints/kettle/.
			cp ../cvb/endpoints/kettle/downloadFile.kjb ../../system/cvb/endpoints/kettle/.
			cp ../cvb/endpoints/kettle/_addFileNamesToResult.ktr ../../system/cvb/endpoints/kettle/.
			echo
			echo "Added Download File and Get Locations endpoints -- Now in step $STATE"
		;;
		3)
			cp ../cvb/dashboards/admin/settings.* ../../system/cvb/dashboards/admin/.
			cp ../cvb/endpoints/kettle/_filterCombineMatch.ktr ../../system/cvb/endpoints/kettle/.
			echo
			echo "Added Settings Dashboard -- Now in step $STATE"
		;;
		*)
			echo
		;;
	esac
}

function moveBackward {
	if [ $STATE -gt -1 ]
	then
		((STATE--))
	fi
	case $STATE in
		0)
			rm -rf ../../system/cvb/dashboards
			rm -rf ../../system/cvb/endpoints
			cp -r ../cvb-bare/dashboards ../../system/cvb/.
			cp -r ../cvb-bare/endpoints ../../system/cvb/.
			echo
			echo "Removed File List and Added Sample Endpoints -- Now in step $STATE"
		;;
		1)
			cd ../../system/cvb
			cd endpoints/kettle
			rm downloadFile.kjb _addFileNamesToResult.ktr getLocations.ktr
			cd ../..
			cd ../../cpkDemo/scripts
			echo
			echo "Removed Download File and Get Locations Endpoints -- Now in step $STATE"
		;;
		2)
			cd ../../system/cvb
			rm dashboards/admin/settings.* 
			cd ../../cpkDemo/scripts
			echo
			echo "Removed Settings Dashboard -- Now in step $STATE"
		;;
		*)
			echo
		;;
	esac
}

function init {
	STATE=0
	rm -rf ../../system/cvb/dashboards
	rm -rf ../../system/cvb/endpoints
	cp -r ../cvb-bare/dashboards ../../system/cvb/.
	cp -r ../cvb-bare/endpoints ../../system/cvb/.
	echo
	echo "Moving to initial state -- Now in step $STATE"
}

init



EXIT=false
while [  $EXIT == false ]; do
	read -p "" -n 1
	if [[ $REPLY =~ ^[W]$ ]]
	then
	  moveForward
	fi
	if [[ $REPLY =~ ^[S]$ ]]
	then
	  moveBackward
	fi
	if [[ $REPLY =~ ^[Q]$ ]]
	then
	  EXIT=true
	fi
done


echo
echo Done
