<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    expand-text="yes"
    version="3.0">
    
  <xsl:output method="text" />
  <xsl:strip-space elements="*" />

  <xsl:include href="mkdocs-x2y.xslt"/>
  <xsl:include href="inline.xslt"/>
  <xsl:include href="nav.xslt"/>
  <xsl:include href="documents.xslt"/>
  <xsl:include href="functions.xsl"/>
    
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="text()" priority="1">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>
  
  <!-- TODO: vol1 & vol2! -->
  <xsl:template match="/mtc/volume1">
    <!-- generate mkdocs.yml file -->
    <xsl:call-template name="mkdocs-cfg"/>
    
    <!-- generate markdown files -->
    <xsl:apply-templates/>
  </xsl:template>

  <!-- block elements -->
  <xsl:template match="para[not(parent::footnote)]">
    <xsl:if test="@number">
      <xsl:variable name="number" select="replace(@number, '\.$', '\\.') || '  '"/>
      <xsl:value-of select="$number"/>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>
  
  <xsl:template match="
    introduction/title |
    introduction/section/title |
    conventionmodel/title |
    commentary/title |
    position/title">
    <xsl:text># </xsl:text>
    <xsl:apply-templates select="*|text()" />
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->  
  </xsl:template>
  
  <xsl:template match="introduction/section/section/title">
    <xsl:text>## </xsl:text>
    <xsl:apply-templates select="*|text()" />
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>
  
  <xsl:template match="introduction/section/section/section/title">
    <xsl:text>### </xsl:text>
    <xsl:apply-templates select="*|text()" />
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>
  
  <xsl:template match="conventionmodel/preface/title">
    <xsl:text>## </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>

  <xsl:template match="conventionmodel/preface/subtitle">
    <xsl:text>### </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>
  
  
  <xsl:template match="itemizedlist/listitem/para">
    <xsl:text>&#xa;&#xa;- </xsl:text>
    <xsl:apply-templates select="*|text()" />
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>
</xsl:stylesheet>