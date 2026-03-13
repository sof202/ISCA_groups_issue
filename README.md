# ISCA Group permissions issue

Currently (13/03/26), there is a problem with AD groups not being set on
nodes on ISCA. This of course means people are unable to access files and
directories that they only had permissions for thanks to the gid.

The problem is intermittent and a solution has not been found. As a result
this script was created in an attempt to find some kind of pattern. Is it a
problem with certain nodes? Perhaps a problem with the timing of it, or being
rate limited? I have no idea.

## Running

Simply run the runner script with bash:

```bash
bash runner.sh
```

You could do this in a new directory if you wanna run it multiple times:

```bash
datetime=$(date +%d-%m_%H-%M-%S)
mkdir "results-${datetime}"
cd "results-${datetime}"
bash ../runner.sh
```

## Cleanup

There may  be some jobs that just never ran for whatever reason (I did
my best to only go with nodes that are IDLE/ALLOC/MIX, but there could be
some problems still). To cancel these jobs you'll need to get their IDs with

```bash
squeue -u $USER | awk 'NR>1 {print $1}' | tr '\t' ' '
```

Then take all of these job ids and pump them into `scancel`:

```bash
scancel 1002010 210102 1201201 231121 # etc
```
