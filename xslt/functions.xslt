<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:functx="http://www.functx.com"
    exclude-result-prefixes="xs"
    version="3.0">

    <!-- Required for li indenting -->
    <xsl:function name="functx:repeat-string" as="xs:string">
        <xsl:param name="stringToRepeat" as="xs:string?"/> 
        <xsl:param name="count" as="xs:integer"/> 
        <xsl:sequence select="string-join((for $i in 1 to $count return $stringToRepeat), '')"/>
    </xsl:function>
    
    
</xsl:stylesheet>