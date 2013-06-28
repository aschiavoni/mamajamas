# TODO: this is hardcoded for my dev machine
# a future improvement would be to make this generic
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U ryan -d mamajamas_production ~/Downloads/latest.dump
