# MCDF
multi-channel data formatter
##功能描述
该设计我们称之为多通道数据整形器（MCDF，multi-channel data formatter），它可以将上行（uplink）多个通道数据经过内部的FIFO，最终以数据包（data packet）的形式送出。用于处理上行数据和下行数据的接口协议不同，此外多通道数据整形器也有寄存器的读写接口，可以支持更多的控制功能。

