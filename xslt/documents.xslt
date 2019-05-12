<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:functx="http://www.functx.com"
    exclude-result-prefixes="xs"
    version="3.0">
        
    <!-- This file generates the actual Markdown 
         documents:
         
     Introduction - I
        
        Introduction paras
        
        Intro A
        Intro B
        Intro C

    Model Convention - M
        Chapter 1 = 7

    Commentaries - C
        Commentaries 1 - 32

    Positions - P
        Intro
        Positions 1 - 30

    -->
    
    <xsl:variable name="vol1" select="'../docs/vol1'"/>
    
    <!-- INTRODUCTION -->
    <xsl:template match="volume1/introduction">
        <xsl:result-document href="{$vol1}/introduction/index.md">
            <xsl:apply-templates select="* except section"/>
            <xsl:apply-templates select="para/footnote" mode="footnote"/>
        </xsl:result-document>
        <xsl:apply-templates select="section"/>
    </xsl:template>

    <xsl:template match="footnote" mode="footnote">
        <xsl:number level="any" count="footnote" format="[^1]:"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
    </xsl:template>

    <xsl:template match="volume1/introduction/section">
        <xsl:result-document href="{$vol1}/introduction/{@id}.md">
            <xsl:apply-templates/>
            <xsl:apply-templates select=".//footnote" mode="footnote"/>
        </xsl:result-document>
    </xsl:template>
    
    <!-- CONVENTION MODEL -->
    <xsl:template match="conventionmodel">
        <xsl:result-document href="{$vol1}/conventionmodel/index.md">
            <xsl:apply-templates select="* except chapter"/>
            <xsl:apply-templates select=".//footnote" mode="footnote"/>               </xsl:result-document>
        <xsl:apply-templates select="chapter"/>
    </xsl:template>
    
    <xsl:template match="conventionmodel/chapter">
        <xsl:result-document href="{$vol1}/conventionmodel/{@id}.md">
            <xsl:apply-templates/>
            <xsl:apply-templates select=".//footnote" mode="footnote"/>                  </xsl:result-document>
    </xsl:template>
        
    <!-- COMMENTARIES -->
    <xsl:template match="commentaries/commentary">
        <xsl:result-document href="{$vol1}/commentaries/{@id}.md">
            <xsl:apply-templates/>
        </xsl:result-document>
    </xsl:template>
        
    <!-- POSITIONS  -->
    <xsl:template match="positions/introduction">
        <xsl:result-document href="{$vol1}/positions/index.md">
            <xsl:apply-templates select="* except position"/>
        </xsl:result-document>
        <xsl:apply-templates select="position"/>
    </xsl:template>
    
    <xsl:template match="positions/position">
        <xsl:result-document href="{$vol1}/positions/{@id}.md">
            <xsl:apply-templates/>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>