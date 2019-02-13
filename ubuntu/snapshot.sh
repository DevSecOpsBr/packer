#!/bin/sh

function create_snapshot() {

    aws ec2 copy-snapshot --source-region us-west-1 --source-snapshot-id snap-df75e5b5 --destination-region us-west-1 --description "This is my copied snapshot." > snapshot_id.txt

    SNAP_ID=`grep -i "snap" snapshot_id.txt | awk -F'"' '{print $4}'`

    echo $SNAP_ID

    eval sed -i -e "s#\\_REPLACEME_#"${SNAP_ID}"#g" variables.json

}

function create_volume() {

    SNAP_ID=`grep "snap-" snapshot_id.txt|awk -F'"' '{print $4}' snapshot_id.txt`
    STATUS=`aws ec2 describe-snapshots --snapshot-ids $SNAP_ID grep -i "state" | awk -F'"' '{ print $4}'`

    if [ $STATUS = "completed" ]; then
        

        aws ec2 create-volume --region eu-west-1 --availability-zone eu-west-1a --snapshot-id $SNAP_ID --volume-type gp2 > volume_id.txt

        export VOL_ID=`grep -i "volumeid" volume_id.txt|awk -F'"' '{print $4}'`
    else
        echo "Snapshot copying still working. Wait..."
        exit 1;
    fi

    exit 0;
}

$@
