#!/usr/bin/env ruby

require 'soap/driver'

server = ARGV.shift or raise ArgumentError.new( 'Target URL was not given.' )
proxy = ARGV.shift || nil

=begin
# http://www.hippo2000.net/cgi-bin/soap.cgi

NS = 'urn:Geometry2'

drv = SOAPDriver.new( Log.new( STDERR ), 'hippoApp', NS, server, proxy )
drv.addMethod( 'calcArea', 'x1', 'y1', 'x2', 'y2' )

puts drv.calcArea( 5, 1000, 10, 20 )
=end

=begin
# http://www.hippo2000.net/cgi-bin/soap.pl?class=Geometry

NS = 'urn:ServerDemo'

class Point
  @@namespace = NS
  def initialize( x, y )
    @x = x
    @y = y
  end
end

origin = Point.new( 10, 10 )
corner = Point.new( 110, 110 )

drv = SOAPDriver.new( Log.new( STDERR ), 'hippoApp', NS, server, proxy )
drv.addMethod( 'calculateArea', 'origin', 'corner' )

puts drv.calculateArea( origin, corner )
=end

# http://www.hippo2000.net/cgi-bin/soapEx.cgi

NS = 'urn:SoapEx'

drv = SOAPDriver.new( Log.new( STDERR ), 'hippoApp', NS, server, proxy )
drv.addMethod( 'parseChasen', 'target' )
drv.addMethod( 'parseChasenA', 'target' )

require 'uconv'


# ChaSen Sample 1
def putLine( index, kanaName, pos )
  line = "#{ index }\t\t#{ kanaName }\t\t#{ pos }"
  puts Uconv.u8toeuc( line )
end

targetString = Uconv.euctou8( 'SOAP��Ȥ��ȳڤ����Ǥ���?' )

result = drv.parseChasen( targetString )

index = Uconv.euctou8( '���Ф�' )
kanaName = Uconv.euctou8( '�ɤ�' )
pos = Uconv.euctou8( '�ʻ�' )

putLine( index, kanaName, pos )

result.each do | ele |
  putLine( ele[ index ], ele[ kanaName ], ele[ pos ] )
end


# ChaSen Sample 2
targetString = Uconv.euctou8( '�ڤ������ѤǤ���?' )

drv.parseChasenA( targetString ).each do | ele |
  puts Uconv.u8toeuc( ele )
end