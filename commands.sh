# Is container my_container running?
if [ $(docker inspect -f {{.State.Running}} my_container) == "true" ]; then
    echo "my_container is running"
else
    echo "my_container is not running"
fi

# Get last 30 lines of my_container logs and clean
tail -n 30 $(docker inspect -f {{.LogPath}} swaps_pricer) | sed "s/^.\{8\}//" | sed "s/..$//"
