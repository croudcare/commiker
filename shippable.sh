#! /bin/bash

rm -f config/database.yml
cat << EOF > config/database.yml
test:
  adapter: postgresql
  encoding: unicode
  database: commiker_test
  host: localhost
  pool: 25
  username: postgres
  password: postgres
EOF

rm -f config/config.yml
cat << EOF > config/config.yml
test:
  AUTHENTICATION_SECRET: 'auth_test_secret'
  SESSION_SECRET: 'session_test_secret'
  PIVOTAL_TOKEN: 'pivotal_test_token'
  PUSHER_KEY: ''
  PUSHER_SECRET: ''
  PUSHER_APP_ID: ''
  USE_PUSHER: false
EOF

