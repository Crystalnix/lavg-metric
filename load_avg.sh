if !([ $INSTANCEID ]); then
    export INSTANCEID=`ec2-metadata -i | awk '{print $2}'`
fi

if !([ $AWS_DEFAULT_REGION ]); then
    AZONE=`ec2-metadata -z | awk '{print $2}'`
    export AWS_DEFAULT_REGION=${AZONE%?}
fi

if !([ $CLOUDWATCH_OPTS ]); then
    export CLOUDWATCH_OPTS="--namespace System/Detail/Linux --dimensions Instance=$INSTANCEID"
fi

aws cloudwatch put-metric-data --metric-name "LoadAverage5Min" --value $(cat /tmp/proc/loadavg | awk '{print $2}') --unit "Count" $CLOUDWATCH_OPTS
