# Please paste flume.conf here. Example:

# Sources, channels, and sinks are defined per
# agent name, in this case 'tier1'.
tier1.sources  = source1
tier1.channels = channel1
tier1.sinks    = sink1

# For each source, channel, and sink, set
# standard properties.
tier1.sources.source1.type     = netcat
tier1.sources.source1.bind     = 127.0.0.1
tier1.sources.source1.port     = 9999
tier1.sources.source1.channels = channel1
tier1.channels.channel1.type   = memory
tier1.sinks.sink1.type=hbase
tier1.sinks.sink1.type = asynchbase
tier1.sinks.sink1.serializer = org.apache.flume.sink.hbase.SimpleAsyncHbaseEventSerializer
tier1.sinks.sink1.channel=channel1
tier1.sinks.sink1.table=measurements
tier1.sinks.sink1.columnFamily=cf1
# Other properties are specific to each type of
# source, channel, or sink. In this case, we
# specify the capacity of the memory channel.
tier1.channels.channel1.capacity = 100000
