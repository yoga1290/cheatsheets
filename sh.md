# process

```bash
# new process:
$CMD &
# process id:
PID=$!

# Process running at certain port
sudo ss -lptn "sport = :$PORT"
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
