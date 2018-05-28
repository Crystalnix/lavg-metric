FROM renskiy/cron:alpine

WORKDIR app

ADD . /app/

RUN crontab crontab.txt

CMD crond -b
