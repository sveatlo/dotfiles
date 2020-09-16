t=0

toggle() {
    t=$(((t + 1) % 2))
}


trap "toggle" USR1

while true; do
    if [ $t -eq 0 ]; then
        ~/src/scripts/weather.py --output-format '%{T4}{{current.icon}}%{T-}  {{current.temperature}}°C'
    else
        ~/src/scripts/weather.py --output-format '{{city}} - {{current.temperature}}°C, {{current.description_long}} -> {{next.temperature}}°C, {{next.description_long}}'
    fi

    sleep 600 &
    wait
done
