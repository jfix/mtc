<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    expand-text="yes"
    version="3.0">
    
  <xsl:output method="xml" omit-xml-declaration="true"/>
  <xsl:strip-space elements="*" />

  <xsl:include href="mkdocs-x2y.xslt"/>
  <xsl:include href="inline.xslt"/>
  <xsl:include href="nav.xslt"/>
  <xsl:include href="documents.xslt"/>
  <xsl:include href="table.xslt"/>
  <xsl:include href="functions.xslt"/>
    
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="text()" priority="1">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>
  
  <xsl:param name="language" select="//mtc/@language"/>
  
  <!-- TODO: vol1 & vol2! -->
  <xsl:template match="/mtc/volume1">
    <!-- generate mkdocs.yml file -->
    <xsl:call-template name="mkdocs-cfg"/>
    
    <!-- generate markdown files -->
    <xsl:apply-templates/>
  </xsl:template>

  <!-- block elements -->
  <xsl:template match="para[not(parent::footnote)]">
    <xsl:choose>
      <xsl:when test="parent::listitem[parent::itemizedlist]">
        <xsl:text>&#xa;&#xa;- </xsl:text>
        <xsl:apply-templates select="*|text()" />
        <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
      </xsl:when>
      
      <xsl:when test="parent::listitem[parent::orderedlist]">
        <!--<xsl:variable name="item" select="concat(count(parent::listitem[preceding-sibling::listitem])+1,') ')"/>-->
        <xsl:variable name="item" select="count(parent::listitem[preceding-sibling::listitem])+1"/>
        <xsl:variable name="level">
          <xsl:choose>
            <xsl:when test="parent::listitem[parent::orderedlist[parent::listitem[parent::orderedlist]]]">2</xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:if test="$item=1"><xsl:text>&#xa;&#xa;</xsl:text></xsl:if>
        
        <xsl:choose>
          <xsl:when test="$level=1">
1. <xsl:apply-templates select="*|text()" />
            <!--<xsl:text>*</xsl:text>
            <xsl:number format="a) " count="listitem"/>
            <xsl:text>*</xsl:text>-->
          </xsl:when>
          <xsl:when test="$level=2">
    1. <xsl:apply-templates select="*|text()" />
            <!--<xsl:text>*</xsl:text>
            <xsl:number format="i) " count="listitem"/>
            <xsl:text>*</xsl:text>-->
          </xsl:when>
        </xsl:choose>

        <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:if test="@number">
          <xsl:variable name="number" select="replace(@number, '\.$', '\\.') || '  '"/>
          <xsl:value-of select="$number"/>
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="
    introduction/title |
    conventionmodel/title |
    commentary/title |
    position/title">
    <xsl:text># </xsl:text>
    <xsl:apply-templates select="*|text()" />
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->  
  </xsl:template>
 
  <xsl:template match="introduction/section/title">
    <xsl:text># </xsl:text>
    <xsl:apply-templates select="concat(parent::section/@number, ' ', *|text())" />
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>
  
  <xsl:template match="introduction/section/section/title">
    <xsl:text>## </xsl:text>
    <xsl:apply-templates select="*|text()" />
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>
  
  <xsl:template match="introduction/section/section/section/title">
    <!--<xsl:text>### </xsl:text>-->
    <strong><xsl:apply-templates select="*|text()" /></strong>
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>
  
  <xsl:template match="conventionmodel/titleabbrev"/>
  
  <xsl:template match="conventionmodel/preface/title">
    <xsl:text>## </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>

  <xsl:template match="conventionmodel/preface/subtitle">
    <xsl:text>**</xsl:text>
      <xsl:apply-templates/>
    <xsl:text>**&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>
  
  <xsl:template match="chapter/title"/>
  
  <xsl:template match="article/title">
    <xsl:text>## </xsl:text>
    <xsl:value-of select="concat(parent::article/@titleabbrev, '. ')"/>
    <xsl:apply-templates select="*|text()" />
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>
  
  <xsl:template match="article/info/revhistory/title"/>

  <xsl:template match="info">
    <xsl:text>**</xsl:text>
      <xsl:value-of select="if ($language='en') then ('HISTORY') else ('HISTORIQUE')"/>
    <xsl:text>**&#xa;&#xa;</xsl:text> <!-- Block element -->
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>