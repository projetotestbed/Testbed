#!/usr/bin/env python
#####################################################################
#
#  WSN Testbed Project                                    Feb,2014
#  TBRelay links a local tcp port service to each mote data port
#  and log into TestBed BD the data traffic. 
#
#  TBNetx.cfg config file identifies each tcp-service to be started.
#  TBD.cfg config file defines database connection information
#
#  Params:
#          client - Client ip addr used to restrict the access
#          netId - Network Identifier (netId)
#          netVersion - Network Version Identifier (netVersion)
#          TestId - Current user Test ID
#          TestPID - Current TBControl PID
#          ConfigPath - Config file Path
#
#####################################################################

import socket,asyncore,sys
import psycopg2
from psycopg2.pool import ThreadedConnectionPool
import ConfigParser


# Current test globals
gblClientIP = '0.0.0.0'
gblTestID = 0
gblTBControlPID = 0

#DB Conection Pool
dbpool=0

class forwarder(asyncore.dispatcher):
    def __init__(self, ip, port, remoteip,remoteport,moteId,backlog=5):
        asyncore.dispatcher.__init__(self)
	self.port = port
	self.moteId = moteId
        self.remoteip=remoteip
        self.remoteport=remoteport
        self.create_socket(socket.AF_INET,socket.SOCK_STREAM)
        self.set_reuse_addr()
        self.bind((ip,port))
        self.listen(backlog)
        
    def maskAddr(self,config,received):
        #print config,received
        c = config.split('.')
        r = received.split('.')
        #print len(c), len(r)
        if (len(c) == 4) and (len(r) == 4) :
            result = (c[0] == '255') or (c[0] == r[0])
            result = result and ((c[1] == '255') or (c[1] == r[1]))
            result = result and ((c[2] == '255') or (c[2] == r[2]))
            result = result and ((c[3] == '255') or (c[3] == r[3]))
            return result
        else:
            print '--- Malformed IP address'
            return False

    def handle_accept(self):
        conn, addr = self.accept()
        print '--- Port %d connect from %s'%(self.port,addr[0])
        if self.maskAddr(gblClientIP,addr[0]) :
            sender(receiver(conn),self.remoteip,self.remoteport,self.moteId)
            logData = 'Client IP %s connected on port %d'%(addr[0],self.port)
            # Database operation
            recDBconn = dbpool.getconn()
            recDBconn.autocommit = True
            recDBcursor = recDBconn.cursor()
            recDBcursor.execute("INSERT INTO logdata (netid, netversion, testid, logtime, nodeid, logtype,logline,pid) VALUES (%s, %s, %s, CURRENT_TIMESTAMP, %s,'TEST',%s,%s)",(gblNetId,gblNetVersion, gblTestID,self.moteId,logData,gblTBControlPID))
            dbpool.putconn(recDBconn)
        else:
            print '--- Invalid Client IP %s on port %d, expecting %s'%(addr[0],self.port,gblClientIP)
            conn.close()
            logData = 'Invalid Client IP %s on port %d, expecting %s'%(addr[0],self.port,gblClientIP)
            # Database operation
            recDBconn = dbpool.getconn()
            recDBconn.autocommit = True
            recDBcursor = recDBconn.cursor()
            recDBcursor.execute("INSERT INTO logdata (netid, netversion, testid, logtime, nodeid, logtype,logline,pid) VALUES (%s, %s, %s, CURRENT_TIMESTAMP, %s,'TEST',%s,%s)",(gblNetId,gblNetVersion, gblTestID,self.moteId,logData,gblTBControlPID))
            dbpool.putconn(recDBconn)



class receiver(asyncore.dispatcher):
    def __init__(self,conn):
        asyncore.dispatcher.__init__(self,conn)
        self.from_remote_buffer=''
        self.to_remote_buffer=''
        self.sender=None
        self.moteId = 55

    def handle_connect(self):
        pass

    def handle_read(self):
        read = self.recv(4096)
        #print 'Rec:: %04i -->'%len(read)
        self.from_remote_buffer += read

    def writable(self):
        return (len(self.to_remote_buffer) > 0)

    def handle_write(self):
        sent = self.send(self.to_remote_buffer)
        logData = "DATA OUT: %s"%(':'.join(x.encode('hex') for x in self.to_remote_buffer))
#        print 'Rec:: <-- [%s,%s,%s] %s'% (self.moteId,gblTestID,gblTBControlPID,logData)
        # Database operation
        recDBconn = dbpool.getconn()
        recDBconn.autocommit = True
        recDBcursor = recDBconn.cursor()
        recDBcursor.execute("INSERT INTO logdata (netid, netversion, testid, logtime, nodeid, logtype,logline,pid) VALUES (%s, %s, %s, CURRENT_TIMESTAMP, %s,'DATA',%s,%s)",(gblNetId,gblNetVersion, gblTestID,self.moteId,logData,gblTBControlPID))
        dbpool.putconn(recDBconn)
        # write data to buffer
        self.to_remote_buffer = self.to_remote_buffer[sent:]

    def handle_close(self):
        caddr, cport = self.getsockname()
        logData = 'Client quit port %d'%(cport)
        print logData
        self.close()
        if self.sender:
            self.sender.close()
        # Database operation
        recDBconn = dbpool.getconn()
        recDBconn.autocommit = True
        recDBcursor = recDBconn.cursor()
        recDBcursor.execute("INSERT INTO logdata (netid, netversion, testid, logtime, nodeid, logtype,logline,pid) VALUES (%s, %s, %s, CURRENT_TIMESTAMP, %s,'TEST',%s,%s)",(gblNetId,gblNetVersion, gblTestID,self.moteId,logData,gblTBControlPID))
        dbpool.putconn(recDBconn)


class sender(asyncore.dispatcher):
    def __init__(self, receiver, remoteaddr,remoteport,moteId):
        asyncore.dispatcher.__init__(self)
	receiver.moteId = moteId
        self.receiver=receiver
        receiver.sender=self
        self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
	try:
            self.connect((remoteaddr, remoteport))
        except Exception, e:
	    print "Sender connect ERROR [%s]\n" % e
	
    def handle_connect(self):
        pass

    def handle_read(self):
        read = self.recv(4096)
        #print 'Send:: <-- %04i'%len(read)
        self.receiver.to_remote_buffer += read

    def writable(self):
        return (len(self.receiver.from_remote_buffer) > 0)

    def handle_write(self):	
        sent = self.send(self.receiver.from_remote_buffer)
        logData = "DATA  IN: %s"%(':'.join(x.encode('hex') for x in self.receiver.from_remote_buffer))
#        print 'Send:: --> [%s,%s,%s] %s'%(self.receiver.moteId,gblTestID,gblTBControlPID,logData)
        # Database operation
        sndDBconn = dbpool.getconn()
        sndDBconn.autocommit = True
        sndDBcursor = sndDBconn.cursor()
        sndDBcursor.execute("INSERT INTO logdata (netid, netversion,testid, logtime, nodeid, logtype,logline,pid) VALUES (%s, %s, %s, CURRENT_TIMESTAMP, %s,'DATA',%s,%s)",(gblNetId,gblNetVersion,gblTestID,self.receiver.moteId,logData,gblTBControlPID))
        dbpool.putconn(sndDBconn)
        # write data to buffer
        self.receiver.from_remote_buffer = self.receiver.from_remote_buffer[sent:]

    def handle_close(self):
        print '--- Sender closed'
        self.close()
        print '--- try to close receiver'
        self.receiver.close()

if __name__=='__main__':

    
    gblClientIP = sys.argv[1]
    gblNetId = sys.argv[2]
    gblNetVersion = sys.argv[3]
    gblTestID = sys.argv[4]
    gblTBControlPID = sys.argv[5]
    CfgPath = sys.argv[6]

    nodesCfgFile = "%s%s%s%s" %(CfgPath,'/TBNet',gblNetId,'.cfg')
    dbCfgFile = "%s%s" %(CfgPath,'/TBDB.cfg')


    # Read configuration for Database access
    cp = ConfigParser.ConfigParser()
    cp.read(dbCfgFile)
    try:
        dbname = cp.get('database','dbname')
        dbuser = cp.get('database','user')
        dbhost = cp.get('database','host')
        dbpass = cp.get('database','dbpass')
        dbpoolSize = cp.get('database','dbpoolSize')
    except ConfigParser.NoOptionError, e:
        print "TBDB.cfg: missing parameter"
        exit(1)

    # Create DB connection pool
    dbpool = ThreadedConnectionPool(2, int(dbpoolSize), "dbname='%s' user='%s' host='%s' password='%s'"%(dbname,dbuser,dbhost,dbpass))
    # Starts each channel/thread
    for line in file(nodesCfgFile):
        print line
        if line[:1] != '#' and len(line.strip()) > 0:
            moteId,local_port,dev_addr,dev_port = line.split()
            #settings.append((int(moteId),int(local_port),dev_addr,int(dev_port)))
            forwarder('',int(local_port),dev_addr,int(dev_port), int(moteId))
    try:
        asyncore.loop()
    except KeyboardInterrupt, e:
        print e
    except asyncore.ExitNow, e:
        print e
    # close all DB Pool Connection 
    print "Closing DB connection pool"
    dbpool.closeall()



