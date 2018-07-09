# Creating Profiles

This section will describe how to create your very first “Hello, World” profile. It will also outline a useful workflow for creating, testing, and deploying profiles.

Creating and refining profiles is an iterative process. Iterating against a live stream of data is slow, difficult and error prone. The Profile Debugger was created to provide a controlled and isolated execution environment to create, refine and troubleshoot profiles.

## Launch the Stellar Shell. We will leverage the Profiler Debugger from within the Stellar Shell.

```
[root@node1 ~]# cd /usr/hcp/current/metron/
[root@node1 ~]# ./bin/stellar
Stellar, Go!
[Stellar]>>> %functions PROFILER
PROFILER_APPLY, PROFILER_FLUSH, PROFILER_INIT
```

Create a simple hello-world profile that will count the number of messages for each ip_src_addr. The SHELL_EDIT function will open an editor in which you can copy/paste the following Profiler configuration.

```
[Stellar]>>> conf := SHELL_EDIT()
[Stellar]>>> conf
{
  "profiles": [
    {
      "profile": "hello-world",
      "onlyif":  "exists(ip_src_addr)",
      "foreach": "ip_src_addr",
      "init":    { "count": "0" },
      "update":  { "count": "count + 1" },
      "result":  "count"
    }
  ]
}
```

## Create a Profile execution environment; the Profile Debugger.

The Profiler will output the number of profiles that have been defined, the number of messages that have been applied and the number of routes that have been followed.

A route is defined when a message is applied to a specific profile.

If a message is not needed by any profile, then there are no routes.
If a message is needed by one profile, then one route has been followed.
If a message is needed by two profiles, then two routes have been followed.

```
[Stellar]>>> profiler := PROFILER_INIT(conf)
[Stellar]>>> profiler
Profiler{1 profile(s), 0 messages(s), 0 route(s)}
```

Create a message that mimics the telemetry that your profile will consume.

This message can be as simple or complex as you like. For the hello-world profile, all you need is a message containing an ip_src_addr field.

```
[Stellar]>>> msg := SHELL_EDIT()
[Stellar]>>> msg
{
	"ip_src_addr": "10.0.0.1"
}
```

Apply the message to your Profiler, as many times as you like.

```
[Stellar]>>> PROFILER_APPLY(msg, profiler)
Profiler{1 profile(s), 1 messages(s), 1 route(s)}
[Stellar]>>> PROFILER_APPLY(msg, profiler)
Profiler{1 profile(s), 2 messages(s), 2 route(s)}
```

# Flush the Profiler.

A flush is what occurs at the end of each profiler interval, for example a 15 minute period, in the Profiler. The result is a list of Profile Measurements. Each measurement is a map containing detailed information about the profile data that has been generated. The value field is what is written to HBase when running this profile in the Profiler topology.

There will always be one measurement for each [profile, entity] pair. This profile simply counts the number of messages by IP source address. Notice that the value is ‘3’ for the entity ‘10.0.0.1’ as we applied 3 messages with an ‘ip_src_addr’ of ’10.0.0.1’.

```
[Stellar]>>> values := PROFILER_FLUSH(profiler)
[Stellar]>>> values
[{period={duration=900000, period=1669628, start=1502665200000, end=1502666100000},
profile=hello-world, groups=[], value=3, entity=10.0.0.1}]
```

# Apply real, live telemetry to your profile.

Once you are happy with your profile against a controlled data set, it can be useful to introduce more complex, live data. This example extracts 10 messages of live, enriched telemetry to test your profile(s).

```
[Stellar]>>> %define bootstrap.servers := "node1:6667"
node1:6667
[Stellar]>>> msgs := KAFKA_GET("indexing", 10)
[Stellar]>>> LENGTH(msgs)
10
```

Apply those 10 messages to your profile(s).

```
[Stellar]>>> PROFILER_APPLY(msgs, profiler)
  Profiler{1 profile(s), 10 messages(s), 10 route(s)}
```

