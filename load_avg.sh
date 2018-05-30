if !([ $INSTANCEID ]); then
    export INSTANCEID=`ec2-metadata -i | awk '{print $2}'`
fi

if !([ $AWS_DEFAULT_REGION ]); then
    AZONE=`ec2-metadata -z | awk '{print $2}'`
    export AWS_DEFAULT_REGION=${AZONE%?}
fi

if !([ $CLOUDWATCH_OPTS ]); then
    ENVIRONMENT_NAME=`aws ec2 describe-tags --output text --filters "Name=resource-id,Values=$INSTANCEID" "Name=key,Values=elasticbeanstalk:environment-name" --region "$AWS_DEFAULT_REGION" --query "Tags[*].Value"`
    export CLOUDWATCH_OPTS="--namespace ElasticBeanstalk --dimensions EnvironmentMetrics=$ENVIRONMENT_NAME"
fi

aws cloudwatch put-metric-data --metric-name "LoadAverage5Min" --value $(cat /tmp/proc/loadavg | awk '{print $2}') --unit "Count" $CLOUDWATCH_OPTS
