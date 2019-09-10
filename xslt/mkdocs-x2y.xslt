<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:l="http://local"
    exclude-result-prefixes="xs"
    expand-text="yes"
    version="3.0">
    
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="config">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="site_name">
        <xsl:value-of select="l:indent(.)"/>
        <xsl:value-of select="name() || ': ' || ."/>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <xsl:template match="theme | palette | feature | markdown_extensions">
        <xsl:value-of select="l:indent(.)"/>
        <xsl:value-of select="name() || ':&#xa;'"/>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="
        theme/name | 
        theme/favicon | 
        theme/logo |
        theme/custom_dir |
        primary |
        accent |
        tabs | 
        permalink
        ">
        <xsl:value-of select="l:indent(.)"/>{
        name() || ": " || (if (. = ['true', 'false']) then (.) else ("'" || . || "'"))
        }<xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="_item[count(text()) eq 1]">
        <xsl:value-of select="l:indent(.)"/>
        <xsl:text>- </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="_item[count(element()) eq 1]">
        <xsl:value-of select="l:indent(.)"/>
        <xsl:text>- </xsl:text>
        <xsl:value-of select="name(child::*[1])"/>
        <xsl:text>:&#xa;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:function name="l:indent" as="xs:string">
        <xsl:param name="elt" as="element()"/>
        <xsl:variable name="times" select="count($elt/ancestor::*)-1"/>
        <xsl:variable name="indent" select="'  '"/>
        <xsl:sequence select="string-join((for $i in 1 to $times return $indent), '')"/>
    </xsl:function>
</xsl:stylesheet>