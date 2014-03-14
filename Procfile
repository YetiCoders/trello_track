web: bundle exec puma -t ${PUMA_MIN_THREADS:-4}:${PUMA_MAX_THREADS:-12} -w ${PUMA_WORKERS:-2} -p $PORT -e ${RACK_ENV:-development}
