#!/bin/bash

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    while ! nc -z $DATABASE_HOST $DATABASE_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL started"
fi

echo "================================ Sever is starting now  =================================="

celery -A django_docker worker -l info &
celery -A django_docker beat -l info &
python manage.py migrate &
gunicorn --bind 0.0.0.0:8000 --reload django_docker.wsgi &
#python manage.py runserver 0.0.0.0:8000 &


trap 'kill -TERM $PID_CELERY $PID_GUNICORN' TERM INT

PID_CELERY=$!
PID_GUNICORN=$!

wait $PID_CELERY $PID_GUNICORN

trap - TERM INT
wait $PID_CELERY $PID_GUNICORN

#exec "$@"