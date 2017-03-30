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

tier1.sinks.sink1.type = org.apache.flume.sink.kafka.KafkaSink
tier1.sinks.sink1.topic = measurements_event
tier1.sinks.sink1.brokerList = ip-172-31-11-228.us-west-2.compute.internal:9092
tier1.sinks.sink1.batchSize = 20 
tier1.sinks.sink1.channel = channel1


# Other properties are specific to each type of
# source, channel, or sink. In this case, we
# specify the capacity of the memory channel.
tier1.channels.channel1.capacity = 100000

