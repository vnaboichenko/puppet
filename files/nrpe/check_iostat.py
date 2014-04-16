#!/usr/bin/python

import sys,time,argparse

parser = argparse.ArgumentParser(description='')
parser.add_argument('-w', action='store', dest='warning', help='warning level')
parser.add_argument('-c', action='store', dest='critical', help='critical level')
args=parser.parse_args()

TimeToSleep=5


FirstRead=[]
def readDiskstat(IOData):

    DiskioFile = file("/proc/diskstats","r")
    DiskioFileDesc=DiskioFile.readlines()
    IOData.append({})
    for B in DiskioFileDesc:
	if ( not "loop" in B ) and ( not "ram" in B):
	    C=B.strip().split()
	    IOData[0].update({C[2]:{}})
	    IOData[0][C[2]]['Reads']=C[3]
	    IOData[0][C[2]]['ReadsMerged']=C[4]
	    IOData[0][C[2]]['SectorsReads']=C[5]
	    IOData[0][C[2]]['ReadTime']=C[6]
	    IOData[0][C[2]]['Writes']=C[7]
	    IOData[0][C[2]]['WritesMerged']=C[8]
	    IOData[0][C[2]]['SetrorsWrites']=C[9]
	    IOData[0][C[2]]['WriteTime']=C[10]
	    IOData[0][C[2]]['IOInProgress']=C[11]
	    IOData[0][C[2]]['IOms']=C[12]
	    IOData[0][C[2]]['IOWeighted']=C[13]
    time.sleep(TimeToSleep)
    DiskioFile.close()
    DiskioFile = file("/proc/diskstats","r")
    DiskioFileDesc=DiskioFile.readlines()
    IOData.append({})
    for B in DiskioFileDesc:
	if ( not "loop" in B ) and ( not "ram" in B):
	    C=B.strip().split()
	    IOData[1].update({C[2]:{}})
	    IOData[1][C[2]]['Reads']=C[3]
	    IOData[1][C[2]]['ReadsMerged']=C[4]
	    IOData[1][C[2]]['SectorsReads']=C[5]
	    IOData[1][C[2]]['ReadTime']=C[6]
	    IOData[1][C[2]]['Writes']=C[7]
	    IOData[1][C[2]]['WritesMerged']=C[8]
	    IOData[1][C[2]]['SetrorsWrites']=C[9]
	    IOData[1][C[2]]['WriteTime']=C[10]
	    IOData[1][C[2]]['IOInProgress']=C[11]
	    IOData[1][C[2]]['IOms']=C[12]
	    IOData[1][C[2]]['IOWeighted']=C[13]
    PerfData=""
    Status=0
    StatusString="OK |"
    for N in IOData[0]:
	Reads=str(int(IOData[1][N]['Reads'])-int(IOData[0][N]['Reads'])/int(TimeToSleep))
	Writes=str(int(IOData[1][N]['Writes'])-int(IOData[0][N]['Writes'])/int(TimeToSleep))
	DiskUtil=str((int(IOData[1][N]['IOms'])-int(IOData[0][N]['IOms']))/((int(TimeToSleep)*10)))
	PerfData=PerfData+("%s_Reads=%s " % (N, Reads))
	PerfData=PerfData+("%s_Writes=%s " % (N, Writes) )
	PerfData=PerfData+("%s_Util=%s " % (N, DiskUtil) )
	if int(DiskUtil) >= int(args.warning):
	    Status=1
	    StatusString="WARNING |"
	if int(DiskUtil) >= int(args.critical):
	    Status=2
	    StatusString="CRITICAL |"

    print StatusString , PerfData
    sys.exit(Status)




IO=[]
readDiskstat(IO)






#Field  1 -- # of reads completed
#    This is the total number of reads completed successfully.
#Field  2 -- # of reads merged, 
# field 6 -- # of writes merged
#    Reads and writes which are adjacent to each other may be merged for
#    efficiency.  Thus two 4K reads may become one 8K read before it is
#    ultimately handed to the disk, and so it will be counted (and queued)
#    as only one I/O.  This field lets you know how often this was done.
#Field  3 -- # of sectors read
#    This is the total number of sectors read successfully.
#Field  4 -- # of milliseconds spent reading
#    This is the total number of milliseconds spent by all reads (as
#    measured from __make_request() to end_that_request_last()).
#Field  5 -- # of writes completed
#    This is the total number of writes completed successfully.
#Field  7 -- # of sectors written
#    This is the total number of sectors written successfully.
#Field  8 -- # of milliseconds spent writing
#    This is the total number of milliseconds spent by all writes (as
#    measured from __make_request() to end_that_request_last()).
#Field  9 -- # of I/Os currently in progress
#    The only field that should go to zero. Incremented as requests are
#    given to appropriate struct request_queue and decremented as they finish.
#Field 10 -- # of milliseconds spent doing I/Os
#    This field increases so long as field 9 is nonzero.
#Field 11 -- weighted # of milliseconds spent doing I/Os
#    This field is incremented at each I/O start, I/O completion, I/O
#    merge, or read of these stats by the number of I/Os in progress
#    (field 9) times the number of milliseconds spent doing I/O since the
#    last update of this field.  This can provide an easy measure of both
#    I/O completion time and the backlog that may be accumulating.