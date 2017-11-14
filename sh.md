# process

```bash
# new process:
$CMD &
# process id:
PID=$!

# Process running at certain port
sudo ss -lptn "sport = :$PORT"
PID=$(sudo ss -lptn "sport = :$PORT" | grep -o "pid=[0-9]*" | sed -e "s/pid=//g" | xargs)

# Free all ports:
sudo ss -lptn | grep -o "pid=[0-9]*" | sed "s/pid=//g" | xargs sudo kill
```

# I/O direct:

+ `$CMD >stdout.txt`
+ `$CMD 1>stdout.txt`
+ `$CMD 2>&1`
+ `$CMD 2>stderr.txt`
+ `cat input.txt | $CMD` (e.g: `cat MySQL.sql | mysql ...`)
+ `OUTPUT=$($CMD)`


# Memory
+ `watch -n 5 free -h`
+ `df -h`


# `no tty present and no askpass program specified` fix

```bash
ORIGINAL='%admin ALL=(ALL) ALL'
REP='%admin ALL=(ALL) NOPASSWD: ALL'
sudo cat /etc/sudoers | sed -e "s/$ORIGINAL/$REP/g" >tmp
sudo mv tmp /etc/sudoers

# see https://askubuntu.com/a/189542
```
